//
//  HyperCheckoutLite.h
//  HyperSDK
//
//  Copyright © 2023 Juspay Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyperSDK/Hyper.h"

@interface HyperCheckoutLite : NSObject

+ (void) openPaymentPage:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)sdkPayload callback:(HyperSDKCallback _Nonnull)callback;

@end
