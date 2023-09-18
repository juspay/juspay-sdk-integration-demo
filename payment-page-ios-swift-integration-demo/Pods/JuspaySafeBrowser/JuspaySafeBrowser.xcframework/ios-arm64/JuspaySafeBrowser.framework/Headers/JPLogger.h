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
#import <JuspaySafeBrowser/JPTransactionStatus.h>

#define Logger [JPLogger sharedInstance]

@interface JPLogger : NSObject

@property (nonatomic, strong) NSString *clientID;

+(JPLogger*)sharedInstance;

- (void)resetSharedInstance;

/**
 Sends the status of payment to juspay.

 @param status Object of TransactionStatus contains information like TransactionId, Payment Status, etc.
 @warning This should always be called from finish transaction callback method. For sending status outside callbak use the later method.
 */
- (void)logPaymentStatus:(JPTransactionStatus*)status;

/**
 Sends the status of payment to juspay.

 @param transactionID TransactionId for which status is being sent
 @param paymentStatus Object of TransactionStatus contains information like TransactionId, Payment Status, etc.
 */
- (void)logPaymentStatus:(NSString*)transactionID paymentStatus:(JPPaymentStatus)paymentStatus;
@end
