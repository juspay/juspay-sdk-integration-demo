//
//  Salvator.h
//  Salvator
//
//  Copyright © Juspay Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Salvator : NSObject

typedef void (^SalvatorCallback)(NSDictionary<NSString*, id>* _Nonnull data);

/**
 Entry point for starting SafeMode SDK.

 @param viewController Base viewcontroller on which the salvator view controller will be presented.
 @param payload Payload required to start the payment.
 @param callback SalvatorCallback callback block to handle the response.
 
 */

- (void)startPaymentOnViewController:(UIViewController * _Nonnull)viewController withPayload:(NSDictionary * _Nonnull)payload callback:(SalvatorCallback _Nonnull)callback;

@end
