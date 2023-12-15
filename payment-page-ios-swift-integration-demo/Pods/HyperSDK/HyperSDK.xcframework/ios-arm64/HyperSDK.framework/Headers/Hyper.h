//
//  Hyper.h
//  HyperSDK
//
//  Copyright © Juspay Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// If this line gives error then it means that assets download didn't happen properly.
// That could be because of the following reasons:
// * Not all the steps are followed as given in the integration documentation.
// * Some error occured while doing pod install.
#import <HyperSDK/VerifyHyperAssets.h>
#import <HyperSDK/BridgeCompontent.h>
#import <HyperSDK/BridgeModule.h>

@protocol HyperDelegate <NSObject>

@optional

- (UIView * _Nullable)merchantViewForViewType:(NSString * _Nonnull)viewType;

/**
 Delegate method will be triggered once JuspaySafeBrowser's webview is initialized.

 @param webView The web view object.
*/
- (void)onWebViewReady:(WKWebView * _Nonnull)webView;

@end

@interface Hyper : NSObject

/**
 Hides bottom bar to provide more screen.
 
 @since v0.1
 */
@property (nonatomic) BOOL shouldHideBottomBarWhenPushed;

#pragma mark - SDK Integration

/**
 Callback block for communicating between callee to service .
 
 @param data Data being passed for service.
 
 @since v0.4
 */
typedef void (^HyperEventsCallback)(NSDictionary* _Nonnull data);

/**
 Callback block to handle various callbacks/outputs from the SDK.
 
 @param data Response data from SDK once execution is complete.
 
 @since v0.4
 */
typedef void (^HyperSDKCallback)(NSDictionary<NSString*, id>* _Nullable data);

/**
 Custom loader to be shown in case of network calls.
 
 @since v0.1
 */
@property (nonatomic, strong, nullable) UIView *activityIndicator;

/**
 Base view controller.
 
 @since v0.4
 */
@property (nonatomic, weak, nullable) UIViewController *baseViewController;


/**
 HyperSDK callback.
 
 @since v0.4
 */
@property (nonatomic, copy, nullable) HyperSDKCallback hyperSDKCallback;


/**
 Return the current version of SDK.
 
 @return Version number in string representation.
 
 @since v0.1
 */
+(NSString*_Nonnull)HyperSDKVersion;


/**
@property hyperDelegate
*/

@property (nonatomic, weak) id <HyperDelegate> _Nullable hyperDelegate;

/**
 For updating assets and establishing connections.
 
 @since v0.2
 */
+ (void)preFetch:(NSDictionary*_Nonnull)data;

/**
 Callback to be triggered by merchant.
 
 @return HyperEventsCallback to be triggered for passing data back.
 
 @since v0.4
 */
- (HyperEventsCallback _Nullable )merchantEvent;

/**
 * Handles the redirection back to the app from the PWA UI
 *
 * @param url the redirect URL
 * @param sourceApplication the sourceApplication where it comes from
 *
 * @return whether the response with the URl was handled successfully or not.
 *
 */
+ (BOOL)handleRedirectURL:(NSURL * _Nonnull)url sourceApplication:(NSString * _Nonnull)sourceApplication;

/**
Check if current instance is Initialised.

@since v2.0
*/
- (Boolean)isInitialised;
    
///---------------------
/// @name Hyper entry points
///---------------------

/**
 For initiating Hyper engine.
 
 @param viewController Reference ViewController marked as starting point of view. Requires view to have a base UINavigationController.
 @param initiationPayload Payload required for starting up engine.
 @param callback Callback block to handle various callbacks or events triggered by SDK.
 
 @since v0.4
 */
- (void)initiate:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)initiationPayload callback:(HyperSDKCallback _Nonnull)callback;

/**
 To perform an action.
 
 @param processPayload Payload required for the operation.
 
 @since v0.4
 */
- (void)process:(NSDictionary * _Nullable)processPayload;

/**
 To stop Hyper engine.
 
 @since v0.4
 */

- (void)terminate;


/**
 To stop a performed action.
 
 @param terminatePayload Payload required for  the operation.
 
 @since v0.4
 */

- (void)terminateProcess:(NSDictionary * _Nullable)terminatePayload;

/**
 Set it as true if HyperSDK's UI needs to be opened in a new view controller instead of adding it in baseViewController.
 The default is false.
 */
@property (nonatomic) BOOL shouldUseViewController;

@end

/**
HyperServices sub-class to allow uniform class calls across OS.

@since v2.0
*/
@interface HyperServices : Hyper
@end
