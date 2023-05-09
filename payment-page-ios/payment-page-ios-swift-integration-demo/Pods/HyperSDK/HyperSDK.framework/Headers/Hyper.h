//
//  Hyper.h
//  HyperSDK
//
//  Copyright © Juspay Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

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

//////////////////////////// Start of depreceated methods ////////////////////////

/**
 Response block for communicating between service to callee.
 
 @param status Status after execution of service.
 @param responseData Response from service once execution is complete.
 @param error Error object with details if any error has occurred.
 
 @since v0.1
 */
typedef void (^HyperResponseBlock)(int status, id _Nullable responseData, NSError * _Nullable error);

/**
 Response block for communicating logs between service to callee.
 
 @param logData Logs being passed from service.
 
 @since v0.1
 */
typedef void (^HyperLogBlock)(id _Nonnull logData);

/**
 Callback block for communicating between callee to service .
 
 @param data Data being passed for service.
 
 @since v0.1
 */
typedef void (^CallbackBlock)(NSDictionary* _Nonnull data);

/**
 Callback block to handle various callbacks/outputs from the SDK when process is called.
 
 @param data Response from service once execution is complete.
 */
typedef void (^HyperResponseHandler)(NSDictionary* _Nonnull data);

/**
 Callback block for communicating between callee to service .
 
 @param data Data being passed from service to callee.
 @param callback Callback to be triggered if required.
 
 @since v0.1
 */
typedef void (^HyperCommunicationBlock)(id _Nonnull data, CallbackBlock _Nonnull callback);

/**
 Hides bottom bar to provide more screen.
 
 @since v0.1
 */
@property (nonatomic) BOOL shouldHideBottomBarWhenPushed;
    
/**
 Data passed by calling app. Contains services to start - Mandatory to pass {"service":"service to be started"}.
 @warning `data` must have a valid service of type `{"service":"service to be started"}`.
 
 @since v0.1
 */
@property (nonatomic, strong, nonnull) NSDictionary *data;
    
///---------------------
/// @name Hyper entry points
///---------------------

/**
 Entry point for starting hyper.
 
 @param viewController Reference ViewController marked as starting point of view.
 @param data Data params to be passed for service - Mandatory to pass {"service":"service to be started"}.
 @param callback HyperResponse callback returns status and additional data required to calling process.
 @warning `data` must have a valid service of type `{"service":"service to be started"}`.
 
 @since v0.1
 */
- (void)startViewController:(nonnull UIViewController*)viewController data:(nonnull NSDictionary*)data callback:(nonnull HyperResponseBlock)callback;

/**
 Entry point for starting hyper.
 
 @param viewController Reference ViewController marked as starting point of view.
 @param data Data params to be passed for service - Mandatory to pass {"service":"service to be started"}.
 @param logs HyperLog callback returns logs from hyper modules.
 @param comm HyperCommunication used to pass data to and from calling service in current running service.
 @param callback HyperResponse callback returns status and additional data required to calling process.
 @warning `data` must have a valid service of type `{"service":"service to be started"}`.
 
 @since v0.1
 */
- (void)startViewController:(nonnull UIViewController*)viewController data:(nonnull NSDictionary*)data logCallback:(nullable HyperLogBlock)logs commBlock:(nullable HyperCommunicationBlock)comm callback:( nonnull HyperResponseBlock)callback;

/**
 Callback to be triggered by merchant.
 
 @return Callbackblock which contains a dictionary.
 
 @since v0.1
 */
- (CallbackBlock _Nullable )onMerchantEvent;

/**
 For updating assets and establishing connections.
 
 @since v0.1
 */
- (void)preFetch:(NSDictionary*_Nonnull)data __attribute__((deprecated("Replaced by +preFetch:")));

/**
 For clearing local cached data.
 
 @since v0.2
 */
+ (void)clearCache;
//////////////////////////// End of depreceated methods ////////////////////////

#pragma (All methods above are depreciated and will be removed in future releases)
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
 Merchant view will be visible on top of rendered micro app.
 
 @since v0.2
 */
@property (nonatomic, strong, nullable) UIView *merchantView;

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
Check if current instance is intialized.

 This method is deprecated because of spelling mistake.
 Both methods will continue to be supported but please move to non-deprecated method.
 
@since v2.0
*/
- (Boolean)isInitialized __deprecated;

/**
Check if current instance is intialized.

 This method is deprecated because of spelling mistake.
 Both methods will continue to be supported but please move to non-deprecated method.
 
@since v2.0
*/
- (Boolean)isIntialized __deprecated;

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

@end

/**
HyperServices sub-class to allow uniform class calls across OS.

@since v2.0
*/
@interface HyperServices : Hyper
@end
