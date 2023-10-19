NSRegularExpression *juspayRegex = [NSRegularExpression regularExpressionWithPattern:@"amzn-.*|juspay-.*" options:0 error:nil];
if ([juspayRegex numberOfMatchesInString:[url absoluteString] options:0 range:NSMakeRange(0, [[url absoluteString] length])] > 0) {
    return [HyperServices handleRedirectURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
}