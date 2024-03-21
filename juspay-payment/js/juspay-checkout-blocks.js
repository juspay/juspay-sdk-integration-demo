const juspay_settings = window.wc.wcSettings.getSetting("juspay_payment_data", {});
const JuspayContent = () => {
  return window.wp.htmlEntities.decodeEntities(juspay_settings.description || "");
};
const juspayLabel =
  window.wp.htmlEntities.decodeEntities(juspay_settings.title) ||
  window.wp.i18n.__("Juspay", "juspay-payment");

const Juspay_Block_Gateway = {
  name: "juspay_payment",
  label: juspayLabel,
  content: Object(window.wp.element.createElement)(JuspayContent, null),
  edit: Object(window.wp.element.createElement)(JuspayContent, null),
  canMakePayment: () => {
    return true;
  },
  ariaLabel: juspayLabel,
  supports: {
    features: settings.supports,
  },
  placeOrderButtonLabel: "Proceed to Pay",
};
window.wc.wcBlocksRegistry.registerPaymentMethod(Juspay_Block_Gateway);
