let juspayRegex = try? NSRegularExpression(pattern: "amzn-.*|juspay-.*", options: [])
if (juspayRegex?.numberOfMatches(in: url.absoluteString, options: [], range: NSRange(location: 0, length: url.absoluteString.count)) ?? 0) > 0 {
    return HyperServices.handleRedirectURL(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String ?? "")
}