self.hyperInstance.initiate(self, payload: initiationPayload, callback: { [unowned self] (response) in
     if let data = response {
         let event = data["event"] as? String ?? ""
         if event == "show_loader" {
           // Show some loader here
         } else if event == "hide_loader" {
           // Hide Loader
         } else if event == "initiate_result" {
           // Get the payload
           let payload = data["payload"]
         } else if event == "process_result" {
           // Get the payload
           let payload = data["payload"]
           //Merchant handling
         }
     } else {
       //Error handling
     }
})