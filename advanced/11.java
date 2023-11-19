<script type="text/javascript">
Juspay.Setup({
    payment_form: "#payment_form",
    success_handler: function(status) {},
    error_handler: function(error_code, error_message, bank_error_code,
        bank_error_message, gateway_id) {},
    card_encoding_key: ":card_encoding_key",
    card_encoding_version: "YYYY-MM-DD"
})
</script>