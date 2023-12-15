//
//  BridgeModule.h
//  HyperSDK
//
//  Copyright © Juspay Technologies. All rights reserved.
//

#ifndef BridgeModule_h
#define BridgeModule_h

@protocol BridgeModule

@required

- (void)setBridgeComponent:(id<BridgeComponent> _Nonnull)bridgeComponent;

- (NSArray<NSObject *> * _Nonnull)getJSIntefaces;

- (NSArray<NSString *> * _Nonnull)getEventsToWhitelist;

@end

#endif /* BridgeModule_h */
