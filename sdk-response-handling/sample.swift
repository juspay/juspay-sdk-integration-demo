self.hyper.initiate(self, payload: initiatePayload, callback: { [weak self] (response) in

    if let data = response, let event = data["event"] as? String {
        if (event == "hide_loader") {
            // hide loader
        } else if (event == "initiate_result") {
            // handle initiate response
        } else if (event == "process_result") {
            let error = data["error"] as! Bool
            
            let innerPayload = data["payload"] as! [ String: Any ]
            let status = innerPayload["status"] as! String
            let pi = innerPayload["paymentInstrument"] as? String
            let pig = innerPayload["paymentInstrumentGroup"] as? String
            
            if (!error) {
                // txn success, status should be "charged"
                // process data -- show pi and pig in UI maybe also?
                // example -- pi: "PAYTM", pig: "WALLET"
                // call orderStatus once to verify (false positives)
            } else {
                
                let errorCode = data["errorCode"] as! String
                let errorMessage = data["errorMessage"] as! String
                switch (status) {
                    case "backpressed":
                        // user back-pressed from PP without initiating any txn
                        break;
                    case "user_aborted":
                        // user initiated a txn and pressed back
                        // poll order status
                        break;
                    case "pending_vbv", "authorizing":
                        // txn in pending state
                        // poll order status until backend says fail or success
                        break;
                    case "authorization_failed", "authentication_failed", "api_failure":
                        // txn failed
                        // poll orderStatus to verify (false negatives)
                        break;
                    case "new":
                        // order created but txn failed
                        // very rare for V2 (signature based)
                        // also failure
                        // poll order status
                        break;
                    default:
                        // unknown status, this is also failure
                        // poll order status
                        break;
                }
                // if txn was attempted, pi and pig would be non-empty
                // can be used to show in UI if you are into that
                // errorMessage can also be shown in UI
            }
        }
    }
})