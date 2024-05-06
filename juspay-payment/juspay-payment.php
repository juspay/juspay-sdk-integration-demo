<?php

/*
Plugin Name: Juspay Payment Gateway
Plugin URI: https://juspay.in/
Description:  WooCommerce payment plugin for Juspay.in
Version: 1.3.1
Updated: 11/03/2024
Author: Juspay Technologies
Author URI: https://juspay.in/
License: GPLv2 or later
*/

use PaymentHandler\APIException;
use PaymentHandler\PaymentHandler;
use PaymentHandler\PaymentHandlerConfig;

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly
}

register_activation_hook( __FILE__, 'juspay_plugin_activation_function' );

require_once __DIR__ . '/includes/juspay-webhook.php';
require_once __DIR__ . '/includes/juspay-payment-handler.php';

add_action( 'plugins_loaded', 'juspay_init_payment_class', 0 );
add_action( 'admin_post_nopriv_juspay_wc_webhook', 'juspay_webhook_init', 10 );
add_action( 'before_woocommerce_init', 'juspay_declare_compatibility', 5 );
add_action( 'woocommerce_blocks_loaded', 'juspay_woocommerce_blocks_support' );

define( 'JUSPAY_PAYMENT_PLUGIN_VERSION', '1.3.1' );
define( 'JUSPAY_PAYMENT_PLUGIN_URL', untrailingslashit( plugins_url( basename( plugin_dir_path( __FILE__ ) ), basename( __FILE__ ) ) ) );

function juspay_init_payment_class() {

	if ( ! class_exists( 'WC_Payment_Gateway' ) ) {
		return;
	}

	class Juspay_Payment extends WC_Payment_Gateway {

		protected $paymentHandlerConfig;
		protected $paymentHandler;

		public function __construct() {
			$this->id = 'juspay_payment';
			$this->method_title = __( 'Smart Gateway' );
			$this->method_description = __( 'Allow customers to securely pay via Smart Gateway' );
			$this->icon = plugins_url( 'images/logo.png?v=' . JUSPAY_PAYMENT_PLUGIN_URL, __FILE__ );

			$this->has_fields = true;

			$this->init_form_fields();
			$this->init_settings();

			switch ( $this->get_option( 'mode' ) ) {
				case "sandbox":
					$this->base_url = "https://smartgatewayuat.hdfcbank.com";
					break;
				case "production":
					$this->base_url = "https://smartgateway.hdfcbank.com";
					break;
				default:
					$this->base_url = "https://smartgatewayuat.hdfcbank.com";
					break;
			}

			$this->title = $this->get_option( 'title' );
			$this->description = $this->get_option( 'description' );
			$this->instructions = $this->get_option( 'instructions' );
			$this->notify_url = home_url( '/wc-api/wc_juspay' );

			if ( $this->get_option( 'enabled' ) == "yes" ) {
				try {
					$this->paymentHandlerConfig = PaymentHandlerConfig::getInstance()
						->withInstance(
							$this->get_option( 'merchant_id' ),
							$this->get_option( 'api_key' ),
							$this->get_option( 'client_id' ),
							$this->base_url,
							false,
							false,
							$this->get_option( 'response_key' ),
						);
					$this->paymentHandler = new PaymentHandler( null, $this->paymentHandlerConfig );
				} catch (Exception $e) {
					http_response_code( 500 ); // Internal Server Error
					exit();
				}
				wp_enqueue_style( 'juspaycss', plugins_url( '/css/juspay.css', __FILE__ ), array(), JUSPAY_PAYMENT_PLUGIN_URL );

				add_filter( 'plugin_action_links_' . plugin_basename( __FILE__ ), [ $this, 'plugin_action_links' ] );

				add_filter( 'woocommerce_thankyou_order_received_text', array( $this, 'juspay_thankyou' ) );

				add_action( 'woocommerce_api_wc_juspay', array( $this, 'check_juspay_response' ) );

				add_action( 'woocommerce_update_options_payment_gateways_' . $this->id, array( $this, 'process_admin_options' ) );

				add_action( "woocommerce_receipt_" . $this->id, array( $this, 'receipt_page' ) );

				add_action( 'woocommerce_order_actions', array( $this, 'juspay_add_manual_actions' ) );

				add_action( 'woocommerce_order_action_wc_manual_sync_action', array( $this, 'juspay_process_manual_sync_action' ) );

				wp_register_script(
					'juspay-checkout-blocks',
					plugins_url( '/js/juspay-checkout-blocks.js?v=' . JUSPAY_PAYMENT_PLUGIN_URL, __FILE__ ),
					array(),
					JUSPAY_PAYMENT_PLUGIN_VERSION
				);
			}
		}

		public function init_form_fields() {

			$webhookUrl = esc_url( admin_url( 'admin-post.php' ) ) . '?action=juspay_wc_webhook';

			$this->form_fields = array(
				'enabled' => array(
					'title' => 'Enable/Disable',
					'label' => 'Enable Smart Gateway',
					'type' => 'checkbox',
					'description' => '',
					'default' => 'no'
				),
				'title' => array(
					'title' => __( 'Title', 'juspay-payment' ),
					'type' => 'text',
					'description' => __( 'This controls the title which the user sees during checkout.', 'juspay-payment' ),
					'default' => __( "Smart Gateway", 'juspay-payment' )
				),
				'description' => array(
					'title' => __( 'Description', 'juspay-payment' ),
					'type' => 'textarea',
					'description' => __( 'This controls the description which the user sees during checkout.', 'juspay-payment' ),
					'default' => __( 'Credit, Debit Card / Net Banking / UPI / Wallets', 'juspay-payment' )
				),
				'mode' => array(
					'title' => 'Mode',
					'label' => 'Select Mode',
					'type' => 'select',
					'options' => array(
						'production' => __( 'Production', 'juspay-payment' ),
						'sandbox' => __( 'Sandbox', 'juspay-payment' ),
					),
					'default' => 'production',
				),
				'merchant_id' => array(
					'title' => 'Merchant ID',
					'label' => 'Enter your Merchant ID',
					'description' => 'You can find your merchant ID from the Dashboard',
					'type' => 'text'
				),
				'client_id' => array(
					'title' => 'Client ID',
					'type' => 'text',
				),
				'enable_webhook' => array(
					'title' => __( 'Enable Webhook', 'juspay-payment' ),
					'type' => 'checkbox',
					'description' => "<span>$webhookUrl</span><br/><br/>Use this URL to be entered as Webhook URL on your Dashboard",
					'label' => __( 'Enable Webhook', 'juspay-payment' ),
					'default' => 'no'
				),
				'webhook_username' => array(
					'title' => 'Webhook Username',
					'type' => 'text',
					'description' => 'You can find your Webhook Url from the settings section of Dashboard',
				),
				'webhook_password' => array(
					'title' => 'Webhook Password',
					'type' => 'password',
					'description' => 'You can find your Webhook Password from the settings section of Dashboard',
				),
				'api_key' => array(
					'title' => 'API Key',
					'type' => 'password',
					'description' => 'You can find your API Keys from the settings section of Dashboard',
				),
				'response_key' => array(
					'title' => 'Response Key',
					'type' => 'text',
					'description' => 'You can find your Response Key from the settings section of Dashboard',
				),
			);
		}

		function receipt_page( $order_id ) {
			echo $this->call_initiate_payment( $order_id );
		}

		/**
		 * Process the payment and return the result
		 **/
		function process_payment( $order_id ) {
			$redirect_url = $this->call_initiate_payment( $order_id, true );
			return array( 'result' => 'success', 'redirect' => $redirect_url );
		}

		public function check_juspay_response() {

			global $woocommerce;

			$msg['class'] = 'error';
			$msg['message'] = "Thank you for shopping with us. However, the transaction has been declined.";

			$order_id = $_REQUEST['order_id'];
			$status = $_REQUEST["status"];
			$signature = $_REQUEST["signature"];
			$statusId = $_REQUEST["status_id"];
			$params = [ "order_id" => $order_id, "status" => $status, "signature" => $signature, "status_id" => $statusId ];

			$status = $this->get_order_status( $params );

			$order = new WC_Order( $order_id );

			try {
				$msg['message'] = $this->get_status_message( array( 'status' => $status ) );

				if ( $status == 'CHARGED' || $status == 'COD_INITIATED' || $status == 'PENDING_VBV' ) {
					$msg['class'] = 'success';
				} else {
					$msg['class'] = 'error';
				}

				if ( $order->status != 'processing' ) {
					if ( $status == "CHARGED" || $status == "COD_INITIATED" ) {
						$order->payment_complete( $order_id );
						$order->add_order_note( 'Payment successful - Order ID: ' . $order_id );
						$woocommerce->cart->empty_cart();
					} else if ( $status == "PENDING_VBV" ) {
						$woocommerce->cart->empty_cart();
					}
				}
			} catch (Exception $e) {
				$order->add_order_note( "Error: " . $e->getMessage() );
				$msg['class'] = 'error';
				$msg['message'] = "Thank you for shopping with us. However, the transaction has been declined. Please retry the payment.";
			}


			if ( $msg['class'] != 'success' ) {
				if ( function_exists( 'wc_add_notice' ) ) {
					wc_add_notice( $msg['message'], $msg['class'] );

				} else {
					$woocommerce->add_error( $msg['message'] );
					$woocommerce->set_messages();
				}
			}

			if ( $msg['class'] == 'success' ) {
				$redirect_url = $this->get_return_url( $order );
			} else {
				$redirect_url = get_permalink( woocommerce_get_page_id( 'cart' ) );
			}
			wp_redirect( $redirect_url );
			exit;
		}

		function get_order_status( $params ) {
			if ( $this->paymentHandler->validateHMAC_SHA256( $params ) === false ) {
				$order = wc_get_order( $params['order_id'] );
				$order->add_order_note( 'Signature verification failed - Order ID: ' . $params['order_id'] );
				$order->add_order_note( 'Note: Ensure that the \'Response Key\' is properly configured in plugin settings.' );
				$order->add_order_note( 'Falling back to Order Status API' );
				$order = $this->paymentHandler->orderStatus( $params["order_id"] );
				return $order['status'];
			}
			return $params['status'];
		}

		function juspay_thankyou( $esc_html__ ) {
			$order_id = wc_get_order_id_by_order_key( $_GET['key'] );
			$order = wc_get_order( $order_id );
			$paymentResponse = $this->paymentHandler->orderStatus( $order_id );
			global $woocommerce;

			if ( $paymentResponse['status'] == "CHARGED" || $paymentResponse['status'] == "COD_INITIATED" ) {
				$order->payment_complete( $order_id );
				$woocommerce->cart->empty_cart();
				return esc_html__( $esc_html__, 'juspay-payment' );
			} else if ( $paymentResponse['status'] == "PENDING_VBV" ) {
				$woocommerce->cart->empty_cart();
			}
			$esc_html__ = $this->get_status_message( $paymentResponse );
			return esc_html__( $esc_html__, 'juspay-payment' );
		}

		function juspay_add_manual_actions( $actions ) {
			global $theorder;
			$this->method_title = __( 'Smart Gateway' );
			$order_id = $theorder->get_transaction_id();
			$terminal_status = array( "processing", "refunded" );
			if ( ! ( in_array( $theorder->status, $terminal_status ) || strlen( $order_id ) < 3 ) ) {
				$actions['wc_manual_sync_action'] = __( 'Sync Payment', 'juspay-payment' );
			}
			return $actions;
		}

		function juspay_process_manual_sync_action( $order ) {
			$order_id = $order->get_transaction_id();
			$response = $this->paymentHandler->orderStatus( $order_id );
			$order->add_order_note( 'Synced Payment Status : ' . $response['status'] . ' - Order ID: ' . $order_id );
			if ( $response['status'] == 'CHARGED' || $response['status'] == 'COD_INITIATED' ) {
				if ( $order->status != 'processing' ) {
					$order->payment_complete( $order_id );
					$order->add_order_note( "Payment successful - Order Id: " . $order_id );
					$paymentMethod = $response['payment_method'];
					$paymentMethodType = $response['payment_method_type'];
					$order->add_order_note( "Payment Method : $paymentMethod ($paymentMethodType) - Juspay Payment Id: " . $order_id );
				}
			}
		}

		function get_status_message( $order ) {
			$message = "Thank you for shopping with us. Your order has the following status: ";
			$status = $order["status"];

			switch ( $status ) {
				case "CHARGED":
				case "COD_INITIATED":
					$message = "Thank you for shopping with us. The order payment done successfully";
					break;
				case "PENDING":
				case "PENDING_VBV":
					$message = "Thank you for shopping with us. Please note that your payment is currently being processed. Kindly check the status after some time.";
					break;
				case "AUTHORIZATION_FAILED":
					$message = "Thank you for shopping with us. However, the transaction has been declined. Please retry the payment.";
					break;
				case "AUTHENTICATION_FAILED":
					$message = "Thank you for shopping with us. However, the transaction has been declined. Please retry the payment.";
					break;
				default:
					$message = $message . $status;
					break;
			}
			return $message;
		}

		public function call_initiate_payment( $order_id, $return_url = false ) {

			header( 'Content-Type: application/json' );

			$order = wc_get_order( $order_id );

			$transaction_id = $order->get_transaction_id();
			$juspay_order_exists = ! is_null( $transaction_id ) && $transaction_id != "";

			if ( $juspay_order_exists ) {

				$last_order = $this->paymentHandler->orderStatus( $order_id );
				$redirectUrl = $last_order['payment_links']['web'];

				if ( $return_url ) {
					return $redirectUrl;
				} else {
					header( "Location: $redirectUrl" );
				}
				exit();
			}

			$order_id = strval( $order_id );

			$order->set_transaction_id( $order_id );
			$order->save();

			$customer = wp_get_current_user();

			global $woocommerce;

			if ( $customer->ID === 0 ) {
				$customer_id = "guest";
				$customer_id_hash = substr( hash_hmac( 'sha512', $customer_id, time() . "" ), 0, 16 );
				$customer_id = "guest_" . $customer_id_hash;
			} else {
				$customer_id = $customer->ID . "";
				$customer_registered = $customer->user_registered;
				$customer_id_hash = substr( hash_hmac( 'sha512', $customer_id, $customer_registered . "" ), 0, 16 );
				$customer_id = "cust_" . $customer_id_hash;
			}

			$amount = (int) ( $order->get_total() );
			try {
				$params = array();
				$params['amount'] = $amount;
				$params['currency'] = get_woocommerce_currency();
				$params['order_id'] = $order_id;
				$params['udf1'] = "WooCommerce";
				$params["merchant_id"] = $this->get_option( 'merchant_id' );
				$params['customer_email'] = $order->get_billing_email();
				$params['customer_phone'] = $order->get_billing_phone();
				$params['billing_address_first_name'] = $order->get_billing_first_name();
				$params['billing_address_last_name'] = $order->get_billing_last_name();
				$params['customer_id'] = $customer_id;
				$params['payment_page_client_id'] = $this->get_option( 'client_id' );
				$params['action'] = "paymentPage";
				$params['return_url'] = $this->notify_url;

				try {
					$session = $this->paymentHandler->orderSession( $params );

					$redirectUrl = $session['payment_links']['web'];

				} catch (Exception $e) {
					$order->add_order_note( 'Error: ' . $e->getMessage() );

					if ( function_exists( 'wc_add_notice' ) ) {
						wc_add_notice( "Something went wrong. Please contact support for assistance." );

					} else {
						$woocommerce->add_error( 'Something went wrong. Please contact support for assistance.' );
						$woocommerce->set_messages();
					}
					$redirectUrl = get_permalink( woocommerce_get_page_id( 'cart' ) );
				}
			} catch (APIException $e) {
				$order->add_order_note( 'Error: ' . $e->getMessage() );

				if ( function_exists( 'wc_add_notice' ) ) {
					wc_add_notice( "Something went wrong. Please contact support for assistance." );

				} else {
					$woocommerce->add_error( 'Something went wrong. Please contact support for assistance.' );
					$woocommerce->set_messages();
				}
				$redirectUrl = get_permalink( woocommerce_get_page_id( 'cart' ) );
			}


			if ( $return_url ) {
				return $redirectUrl;
			} else {
				header( "Location: $redirectUrl" );
			}
			exit();
		}

		function plugin_action_links( $links ) {
			// Check if the Settings link is already present in the array
			$link_exists = false;
			foreach ( $links as $link ) {
				if ( strpos( $link, 'admin.php?page=wc-settings&tab=checkout&section=juspay_payment' ) !== false ) {
					$link_exists = true;
					break;
				}
			}

			// If the link is not already present, add it
			if ( ! $link_exists ) {
				$plugin_links = [ 
					'<a href="admin.php?page=wc-settings&tab=checkout&section=juspay_payment">' . esc_html__( 'Settings', 'juspay-payment' ) . '</a>',
				];
				$links = array_merge( $plugin_links, $links );
			}

			return $links;
		}
	}

	function juspay_add_payment_class( $gateways ) {
		$gateways[] = 'Juspay_Payment';
		return $gateways;
	}

	add_filter( 'woocommerce_payment_gateways', 'juspay_add_payment_class' );

}

// This is set to a priority of 10
function juspay_webhook_init() {
	$jpWebhook = new Juspay_Webhook();
	$jpWebhook->process();
}

function juspay_declare_compatibility() {
	if ( class_exists( '\Automattic\WooCommerce\Utilities\FeaturesUtil' ) ) {
		\Automattic\WooCommerce\Utilities\FeaturesUtil::declare_compatibility( 'custom_order_tables', __FILE__, true );
		\Automattic\WooCommerce\Utilities\FeaturesUtil::declare_compatibility( 'cart_checkout_blocks', __FILE__, true );
	}
}

function juspay_plugin_activation_function() {
	// Check WooCommerce
	if ( ! class_exists( 'WooCommerce' ) ) {
		deactivate_plugins( plugin_basename( __FILE__ ) );
		wp_die( 'This plugin requires WooCommerce to be installed and activated.' );
	}

	// Check WooCommerce version
	if ( version_compare( WC_VERSION, '7.0.0', '<' ) ) {
		deactivate_plugins( plugin_basename( __FILE__ ) );
		wp_die( 'This plugin requires WooCommerce version 7.0.0 or higher.' );
	}

	// Check WordPress version
	global $wp_version;
	if ( version_compare( $wp_version, '5.8', '<' ) ) {
		deactivate_plugins( plugin_basename( __FILE__ ) );
		wp_die( 'This plugin requires WordPress version 5.8 or higher.' );
	}

	// Check PHP version
	if ( version_compare( PHP_VERSION, '7.2', '<' ) ) {
		deactivate_plugins( plugin_basename( __FILE__ ) );
		wp_die( 'This plugin requires PHP version 7.2 or higher.' );
	}
}

function juspay_woocommerce_blocks_support() {
	if ( class_exists( 'Automattic\WooCommerce\Blocks\Payments\Integrations\AbstractPaymentMethodType' ) ) {
		require_once __DIR__ . '/includes/juspay-wc-blocks-support.php';
		add_action(
			'woocommerce_blocks_payment_method_type_registration',
			function (Automattic\WooCommerce\Blocks\Payments\PaymentMethodRegistry $payment_method_registry) {
				$payment_method_registry->register( new Juspay_Checkout_Blocks );
			},
			5
		);
	}
}
