//
//  BridgeComponent.h
//  HyperSDK
//
//  Copyright © Juspay Technologies. All rights reserved.
//

#ifndef BridgeCompontent_h
#define BridgeCompontent_h

#import <UIKit/UIKit.h>

extern NSString * _Nonnull const kHyperNetworkChangeNotification;

@protocol BridgeComponent

@required

- (UIView * _Nullable)getContainerView;

- (void)executeOnWebView:(NSString * _Nonnull)jsString;

- (void)trackEventWithLevel:(NSString * _Nonnull)level label:(NSString * _Nonnull)label value:(id _Nonnull)value category:(NSString * _Nonnull)category subcategory:(NSString * _Nonnull)subcategory;

@end

#endif /* BridgeCompontent_h */
