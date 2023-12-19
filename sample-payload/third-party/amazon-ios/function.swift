//Swift

func scene(_ scene: UIScene, openURLContexts URLContexts: Set) {
    if let URLContext = URLContexts.first {
        if URLContext.url.absoluteString.contains("juspay-") || URLContext.url.absoluteString.contains("amzn-") {
            HyperServices.handleRedirectURL(URLContext.url, sourceApplication: URLContext.options.sourceApplication ?? "")
        }
    }
}