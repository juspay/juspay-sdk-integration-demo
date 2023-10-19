- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    UIOpenURLContext *URLContext = [URLContexts allObjects].firstObject;
    if (URLContext && URLContext.URL && ([URLContext.URL.absoluteString containsString:@"juspay-"] || [URLContext.URL.absoluteString containsString:@"amzn-"])) {
        [HyperServices handleRedirectURL:URLContext.URL sourceApplication:URLContext.options.sourceApplication];
    }
}