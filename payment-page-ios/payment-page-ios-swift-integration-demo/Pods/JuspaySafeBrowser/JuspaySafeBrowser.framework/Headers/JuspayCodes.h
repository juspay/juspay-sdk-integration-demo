/*
 * JUSPAY CONFIDENTIAL
 * __________________
 *
 * [2012] - [2016] JusPay Technologies Pvt Ltd
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of JusPay Technologies Pvt Ltd. The intellectual
 * and technical concepts contained
 * herein are proprietary to JusPay Techologies Pvt Ltd
 * and may be covered by Indian Patents Office and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from JusPay Technologies Pvt Ltd.
 */
#import <Foundation/Foundation.h>
@interface JuspayCodes : NSObject

#pragma mark - Error Codes
extern int JSCancelledByUser;
extern int JSURLNotPassed;
extern int JSClientIdNotPassed;

#pragma mark - Callback Parameters
extern NSString * const kENDURL;
extern NSString * const kMESSAGE;
extern NSString * const kTRANSACTIONID;

@end
