<script type="text/javascript">
     var juspay_form = Juspay.Setup({
        payment_form: "#payment_form",
        success_handler: function(status) {},
        error_handler: function(error_code, error_message, bank_error_code, bank_error_message, gateway_id) {}
        iframe_elements: {
            security_code: {
                /* Class name of the <div> which will hold the iframe element for card security code. */
                container: ".security_code_div",
                
             attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "xxx"
                }
            }
        },
        styles: {
            /* Add the styling for card security code input field here */
            ".security_code": {
                "line-height": "50px",
                "font-size": "16px",
                "width": "60px"
            },
            /* Add the styling to be added to input fields in focus state */
            ":focus": {
            }
        },
        /* 
         * This function will be called with an event object as parameter in two cases:
         * 1. When some event occurs on the security_code field inside iframe element.
         * 2. The user clicks on the submit button and the values in some of the input fields are invalid. (In second case, we will send the event object with state of the first invalid field in checkout form, which is security_code here.)
         
         * This event object will contain the state of the input field. You should use this event object to show validation messages in your checkout form. */

        iframe_element_callback: function(event) {
             /* The event information will be available in the event object 
             
             *  1. event.target_element - (security_code) 
             *  2. event.valid - (true/false) 
             *  3. event.empty - (true/false) 
             *  4. event.card_brand  */
        }
    })
</script>

<script type="text/javascript">
    juspay_form.tokenize({
      /* juspay_form is the reference of the object returned from Juspay.Setup() */
      success_handler : function(response) {
        /*
         * response.token contains the card token
         * response.start_payment() will start the transaction
         */
      },
      error_handler : function(response) {

      }
    })
</script>