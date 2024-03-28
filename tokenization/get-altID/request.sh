curl --location 'https://sandbox.juspay.in/get/altId' \
--header 'accept: application/json' \
--header 'content-type: application/json' \
--header 'x-merchantId: <juspay provided merchant id>' \
--header 'Authorization: <Basic base64 encoded api key' \
--data '{ 
    "cardData" : "eyJhbGciOiJSU0EtT0FFUJlbmMiOiJBMTI4R0NNIiwia2lkIjoia2V5XzFmMDViZWRhYzBiYjRhZThiODkwMDFjYmM1MDQzYTYzIn0.C3cXYdx6SDMitGktOwxqvRbDGFwtJJdtXPm2O5RjSq40QpUFlU1RfguqNhaz1KY2g4ccfKEEOQZ973uEDjorisUrc--bPCIwhyjsRCw4WhaK4iOayfC3rDjsMr-CEAmpyxNlWoI0pO3xv9g9k3QZfoOXhq9MQ0bLSvyap8jbU_F_vDqSsNAs4k_zPsjlGVvxqdlwiQ572iK6fyf6BcXI-TGrcxHXQnQtN6npppSXcBA8CHorgTlAXO-1GIKFvQeWE6OVDX2cvnMqp5v0xj_I8eNPcUO5iR7mNv22WfGJRrCVl5t33Bm3K1rsGfxER7KPa71pkwxjiTLCfGPOiIDxcA.g2Gms3ry9Bq9-xpL.hKItF3JJDRndwg1y3OopmzyMlj_74Hmlz3yAP5ZS5voFRwtUbmcqNQLvMMobnRQYSPXPC0aWqjtwSsflD_15zO1vWteiFHWamjfeQaXa5DgjzsTQM0X4bCowTEGdMRrtXgeWMfBXQ--js4KL3AYAUD4.UR7Zk0RRI61djBM72RRACg",
    "orderData" : 
    {       "amount" : 1.0,
            "currency": "INR",
            "authRefNumber": "20580201098"
    },
    "correlationId" : "tnjhvbjh",
    "cardBrand" : "VISA",
    "keyId" : "key_7fe0fabd2127cbeae1cb09",
    "submerchantId" : "Sub Merchant Identifier"
}