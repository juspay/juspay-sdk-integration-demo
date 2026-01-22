"payment_filter":{
    "allowDefaultOptions": false,
    "options": [
        {
            "enable": true,
            "paymentMethodType": "CARD"
        }
    ],
    "emiOptions": {
    "standardEmi" : {
      "enable" : true,
      "credit":{
        "enable": true,
        "filters":[
            {
                "paymentMethodType": "CARD",
                "paymentMethod": "CARD",
                "enable": true,
                "issuerFilter": {
                    "issuers": ["JP_BOB"],
                    "tenures": ["3::3"],
                    "enable": true
                }
            }
        ]
      },
      "debit": {
        "enable": false
      },
      "cardless":{
        "enable": false
      }
    },
    "lowCostEmi" : {
      "enable" : false
    },
    "noCostEmi" : {
      "enable" : false
    },
    "showOnlyEmi": true
  }
 }
