hyperInstance.hyperSDKCallback = { [unowned self] response in
    if let data = response {
        let event = data["event"] as? String ?? ""
        if event == "initiate_result" {
            
        } else if event == "process_result" {
            
        }
    }
}