/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Cordova/CDV.h>
#import <HyperSDK/HyperSDK.h>

@interface HyperSDKPlugin : CDVPlugin

@property HyperServices *hyperInstance;
@property NSString *callback;

@end

@implementation HyperSDKPlugin

- (dispatch_queue_t)methodQueue{
    return dispatch_get_main_queue();
}

- (void)pluginInitialize {
    if (!_hyperInstance) {
        _hyperInstance = [HyperServices new];
    }
}

- (void)preFetch:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult* pluginResult = nil;
    if (!_hyperInstance) {
        _hyperInstance = [HyperServices new];
    }
    
    NSDictionary *arguments = [HyperSDKPlugin stringToDictionary:[command.arguments objectAtIndex:0]];
    if (arguments && arguments.count>0) {
        @try {
            if (arguments && [arguments isKindOfClass:[NSDictionary class]] && arguments.allKeys.count>0) {
                [HyperServices preFetch:arguments];
                pluginResult = [CDVPluginResult
                                resultWithStatus:CDVCommandStatus_ERROR
                          messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
            } else {
                pluginResult = [CDVPluginResult
                                resultWithStatus:CDVCommandStatus_ERROR
                          messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
            }
        } @catch (NSException *exception) {
            pluginResult = [CDVPluginResult
                            resultWithStatus:CDVCommandStatus_ERROR
                      messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
        }
    } else {
        pluginResult = [CDVPluginResult
                        resultWithStatus:CDVCommandStatus_ERROR
                  messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
    }
}

- (void)createHyperServices:(CDVInvokedUrlCommand*)command {
    self.hyperInstance = [HyperServices new];
}

- (void)initiate:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult* pluginResult = nil;
    _callback = command.callbackId;
    
    NSDictionary *arguments = [HyperSDKPlugin stringToDictionary:[command.arguments objectAtIndex:0]];
    if (arguments && arguments.count>0) {
        @try {
            NSDictionary *jsonData = arguments;
            if (jsonData && [jsonData isKindOfClass:[NSDictionary class]] && jsonData.allKeys.count>0) {
                __weak HyperSDKPlugin *weakSelf = self;
                [_hyperInstance initiate:self.viewController payload:jsonData callback:^(NSDictionary<NSString *,id> * _Nullable data) {
                    pluginResult = [CDVPluginResult
                                          resultWithStatus:CDVCommandStatus_OK
                                    messageAsString:[HyperSDKPlugin dictionaryToString:data]];
                    pluginResult.keepCallback = [NSNumber numberWithInt:1];
                    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
                }];
            } else {
                pluginResult = [CDVPluginResult
                                      resultWithStatus:CDVCommandStatus_ERROR
                                messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
            }
        } @catch (NSException *exception) {
            pluginResult = [CDVPluginResult
                            resultWithStatus:CDVCommandStatus_ERROR
                      messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
        }
    } else {
        pluginResult = [CDVPluginResult
                        resultWithStatus:CDVCommandStatus_ERROR
                  messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
    }
}

- (void)process:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult* pluginResult = nil;
    
    NSDictionary *arguments = [HyperSDKPlugin stringToDictionary:[command.arguments objectAtIndex:0]];
    if (arguments && arguments.count>0) {
        @try {
            if (arguments && [arguments isKindOfClass:[NSDictionary class]] && arguments.allKeys.count>0) {
                if ([self.hyperInstance isInitialised]) {
                    [self.hyperInstance process:arguments];
                } else {
                    // Define proper error code and return proper error
                    
                }
            } else {
                pluginResult = [CDVPluginResult
                                resultWithStatus:CDVCommandStatus_ERROR
                          messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
                [pluginResult setKeepCallbackAsBool:YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
            }
        } @catch (NSException *exception) {
            pluginResult = [CDVPluginResult
                            resultWithStatus:CDVCommandStatus_ERROR
                      messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
        }
    } else {
        pluginResult = [CDVPluginResult
                        resultWithStatus:CDVCommandStatus_ERROR
                  messageAsString:[HyperSDKPlugin dictionaryToString:@{}]];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self->_callback];
    }
}

- (void)isNull:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = [CDVPluginResult
                                     resultWithStatus:CDVCommandStatus_ERROR
                messageAsString:[HyperSDKPlugin dictionaryToString:@{@"status":self.hyperInstance? @true : @false}]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)terminate:(CDVInvokedUrlCommand*)command {
    if (_hyperInstance) {
        [_hyperInstance terminate];
    }
    CDVPluginResult *pluginResult = [CDVPluginResult
                                     resultWithStatus:CDVCommandStatus_ERROR
                messageAsString:[HyperSDKPlugin dictionaryToString:@{@"status":self.hyperInstance? @true : @false}]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isInitialised:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = [CDVPluginResult
                                     resultWithStatus:CDVCommandStatus_ERROR
                messageAsString:[HyperSDKPlugin dictionaryToString:@{@"status":self.hyperInstance? @true : @false}]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (NSDictionary*)stringToDictionary:(NSString*)string{
    if (string.length<1) {
        return @{};
    }
    NSError *error;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (error) {}
    return json;
}

+ (NSString*)dictionaryToString:(id)dict{
    if (!dict || ![NSJSONSerialization isValidJSONObject:dict]) {
        return @"";
    }
    NSString *data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil] encoding:NSUTF8StringEncoding];
    return data;
}

- (CGRect)safeAreaFrame {
    
    if (@available(iOS 11.0, *)) {
        return self.viewController.view.safeAreaLayoutGuide.layoutFrame;
    }
    return self.viewController.view.frame;
}

@end
