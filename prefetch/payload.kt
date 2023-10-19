val preFetchPayload = JSONObject()

    try {
        val innerPayload = JSONObject()
        val clientId = "<clientID>"
        innerPayload.put("clientId", clientId)
        preFetchPayload.put("payload", innerPayload)
        preFetchPayload.put("service", "in.juspay.hyperpay")
    } catch (e: JSONException) {
        e.printStackTrace()
    }

    HyperServices.preFetch(this, preFetchPayload)