<?php
if ( ! defined( 'ABSPATH' ) )
	exit; // Exit if accessed directly
use Automattic\WooCommerce\Blocks\Payments\Integrations\AbstractPaymentMethodType;

require_once __DIR__ . '/../juspay-payment.php';

final class Juspay_Checkout_Blocks extends AbstractPaymentMethodType {
	private $gateway;
	protected $name = 'juspay_payment';

	public function initialize() {
		$this->settings = get_option( 'woocommerce_juspay_payment_settings', [] );
		$this->gateway = new Juspay_Payment();
	}

	public function is_active() {
		return ! empty ( $this->settings['enabled'] ) && 'yes' === $this->settings['enabled'];
	}

	public function get_payment_method_script_handles() {
		wp_register_script(
			'juspay_checkout-blocks-integration',
			JUSPAY_PAYMENT_PLUGIN_URL . '/js/juspay-checkout-blocks.js',
			[ 'wc-blocks-registry', 'wc-settings', 'wp-element', 'wp-html-entities', 'wp-i18n' ],
			JUSPAY_PAYMENT_PLUGIN_VERSION,
			true
		);

		if ( function_exists( 'wp_set_script_translations' ) ) {
			wp_set_script_translations( 'juspay_checkout-blocks-integration' );
		}

		return [ 'juspay_checkout-blocks-integration' ];
	}

	public function get_payment_method_data() {
		return [ 'title' => $this->gateway->title ];
	}
}