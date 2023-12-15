<script type="text/javascript">
      var juspay_form = Juspay.Setup({
          payment_form: "#payment_form",
          success_handler: function (status) {},
          error_handler: function (
            error_code,
            error_message,
            bank_error_code,
            bank_error_message,
            gateway_id
          ) {},
          card_bin_digit_count: 6,
       
        /* Fingerprint will work only if customer_id and client_auth_token are present in set-up as shown below */
        customer: {
          customer_id: "XXX",
          client_auth_token: "tkn_SSS",
        },
        iframe_elements: {
            card_number: {
                /* Class name of the <div> which will hold the iframe element for card number. */
                container: ".card_number_div",
                attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "4111 1111 1111 1111"
                }
            },
            name_on_card: {
                /* Class name of the <div> which will hold the iframe element for card holder name. */
                container: ".name_on_card_div",
                attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "Cardholder Name"
                }
            },
            card_exp_month: {
                /* Class name of the <div> which will hold the iframe element for card expiry month. */
                container: ".card_exp_month_div",
                attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "MM"
                }
            },
            card_exp_year: {
                /* Class name of the <div> which will hold the iframe element for card expiry year. */
                container: ".card_exp_year_div",
                attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "YY"
                }
            },
            security_code: {
                /* Class name of the <div> which will hold the iframe element for card security code. */
                container: ".security_code_div",
                attributes: {
                    /* Field Attributes, which you want to set for the <input> field inside the iframe element. */
                    placeholder: "123"
                }
            }
        },

        /* Set `auto_tab_enabled` flag to true if you want to enable auto-switching between fields when the user types the valid data (recommended but optional). 
         * It will have the following order:`card_exp_month` -> `card_exp_year` ->`security_code`. */
        auto_tab_enabled : true,

        /* Set `auto_tab_from_card_number` to either `card_exp_month` or `name_on_card` based on which field is rendered after card_number (recommended but optional).
         * Note 1: Please set `auto_tab_enabled` to `true` as shown above to enable this functionality. */
        auto_tab_from_card_number : "card_exp_month",

       /* Set `tokenize_support` flag to true if you want to check tokenize support response of a particular card bin. */
       tokenize_support : true,

        styles: {
            /* Add common styling for all input fields here */
            "input": {
            },
            /* Add the styling for card number input field here */
            ".card_number": {
                "line-height": "10px",
                "font-size": "16px"
            },
            /* Add the styling for card holder name input field here */
            ".name_on_card": {
                "line-height": "20px",
                "font-size": "16px",
            },
            /* Add the styling for card expiry month input field here */
            ".card_exp_month": {
                "line-height": "30px",
                "font-size": "16px",
                "width": "60px"
            },
            /* Add the styling for card expiry year input field here */
            ".card_exp_year": {
                "line-height": "40px",
                "font-size": "16px",
                "width": "60px"
            },
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

        /* This function will be called with an event object as a parameter in two cases:
         * 1. When some event occurs on the input field inside the iframe element.
         * 2. The user clicks on the submit button and the values in some of the input fields are invalid. (In the second case, we will send the event object with the state of the first invalid field in the checkout form.)
         
         * This event object will contain the state of the input field. You should use this event object to show validation messages in your checkout form. */

        iframe_element_callback: function(event) {
        /* The event information will be available in the event object */
            console.log(event);
            switch (event.target_element) {
              case "card_number":
                if (event.empty) {
                  frm.find(".card_number_div").addClass("invalid");
                } else if (event.valid) {
                  juspay_form.get_card_fingerprint({ /* This function will give card fingerprint in Pay-v3 callback once complete card number has been entered */
                    success_handler: function (response) {
                      console.log("got success_handler response", response);
                    },
                    error_handler: function (response) {
                      console.log("got error_handler response", response);
                    },
                  });
                  frm.find(".card_number_div").removeClass("invalid");
                } else if (event.partially_valid) {
                  frm.find(".card_number_div").removeClass("invalid");
                } else {
                  frm.find(".card_number_div").addClass("invalid");
                }
                break;
          },
        },
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