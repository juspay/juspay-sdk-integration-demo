"payment_filter": {
       "allowDefaultOptions": true,
       "options": [{
               "paymentMethodType": "UPI",
               "enable": true,
               "upiFilters": [{
                       "upiType": "COLLECT",
               "enable": false,     
                       "upiMethods": ["@ybl", "@okhdfcbank"]
                   },
                   {
                       "upiType": "INTENT",
                       "enable": false,
                       "upiMethods": ["PHONEPE", "GPAY", "PAYTM"]
                   }]
               }
           ]
       }
