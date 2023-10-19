hyperInstance.initiate(initiationPayload, object : HyperPaymentsCallbackAdapter() {
        fun onEvent(data: JSONObject, handler: JuspayResponseHandler?) {
            try {
                val event: String = data.getString("event")
                if (event == "show_loader") {
                    // Show some loader here
                } else if (event == "hide_loader") {
                    // Hide Loader
                } else if (event == "initiate_result") {
                    // Get the response
                    val response: JSONObject = data.optJSONObject("payload")
                } else if (event == "process_result") {
                    // Get the response
                    val response: JSONObject = data.optJSONObject("payload")
                    //Merchant handling
                }
            } catch (e: Exception) {
                // merchant code...
            }
        }
    })