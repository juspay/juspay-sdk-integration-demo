<?php
if ( ! defined( 'ABSPATH' ) )
	exit; // Exit if accessed directly

require_once __DIR__ . '/../juspay-payment.php';

class Juspay_Webhook {

	protected $juspay;

	const ORDER_SUCCEEDED = 'ORDER_SUCCEEDED';
	const ORDER_FAILED = 'ORDER_FAILED';

	protected $eventsArray = [ 
		self::ORDER_SUCCEEDED,
		self::ORDER_FAILED,
	];

	public function __construct() {
		$this->juspay = new Juspay_Payment();
	}

	public function process() {
		$post = file_get_contents( 'php://input' );
		if ( ! empty ( $post ) ) {
			$data = json_decode( $post, true );
			$headers = getallheaders();
			$authorization = $headers['authorization'];

			$enabled = $this->juspay->get_option( 'enable_webhook' );

			// Skip the webhook if not the valid data and event
			if ( ( $enabled === 'yes' ) and ( empty ( $data['event_name'] ) === false ) ) {
				// Skip the webhook if the authorization credentials are not valid
				if ( $this->shouldConsumeWebhook( $authorization ) === false ) {
					return;
				}
				switch ( $data['event_name'] ) {
					case self::ORDER_SUCCEEDED:
						return $this->paymentAuthorized( $data );

					case self::ORDER_FAILED:
						return $this->paymentFailed( $data );

					default:
						return;
				}
			}
		}

	}

	/**
	 * Handling the payment authorized webhook
	 *
	 * @param array $data Webook Data
	 */
	protected function paymentAuthorized( array $data ) {

		//
		// Order entity should be sent as part of the webhook payload
		//
		$juspay_order_id = $data['content']['order']['order_id'];
		$order_id = explode( '_', $juspay_order_id );
		$order_id = (int) $order_id[0];

		$order = wc_get_order( $order_id );

		if ( $order ) {
			if ( $order->status != 'processing' ) {
				$order->payment_complete( $juspay_order_id );
				$order->add_order_note( "Juspay payment successful (via Juspay Webhook) - Juspay Order Id: " . $juspay_order_id );
			}
			$paymentMethod = $data['content']['order']['payment_method'];
			$paymentMethodType = $data['content']['order']['payment_method_type'];
			$order->add_order_note( "Payment Method : $paymentMethod ($paymentMethodType) - Juspay Order Id: " . $juspay_order_id );
		}
		exit;
	}
	/**
	 * Does nothing for the main payments flow currently
	 * @param array $data Webook Data
	 */
	protected function paymentFailed( array $data ) {
		$juspay_order_id = $data['content']['order']['order_id'];

		$order = wc_get_order( $juspay_order_id );

		if ( $order ) {
			$order->add_order_note( "Juspay payment failed (via Juspay Webhook) - Juspay Order Id: " . $juspay_order_id );
			$paymentMethod = $data['content']['order']['payment_method'];
			$paymentMethodType = $data['content']['order']['payment_method_type'];
			$order->add_order_note( "Payment Method : $paymentMethod ($paymentMethodType) - Juspay Order Id: " . $juspay_order_id );
		}
		exit;
	}

	protected function shouldConsumeWebhook( $authorization ) {
		$webhook_username = $this->juspay->get_option( 'webhook_username' );
		$webhook_password = $this->juspay->get_option( 'webhook_password' );
		$b64EncodedCreds = "Basic " . base64_encode( $webhook_username . ":" . $webhook_password );
		return $b64EncodedCreds == $authorization;
	}
}
