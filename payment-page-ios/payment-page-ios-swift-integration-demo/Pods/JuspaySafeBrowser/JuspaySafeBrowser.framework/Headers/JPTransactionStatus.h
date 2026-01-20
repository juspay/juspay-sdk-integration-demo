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

/**
 A list of possible payment status.
 
 @typedef PaymentStatus
 @constant UNKNOWNSTATUS Status is unknown.
 @constant SUCCESS Payment was successful.
 @constant FAILURE Payment has failed.
 @constant CANCELLED Payment has been cancelled by user.
 */
typedef enum{
    JPUNKNOWNSTATUS,
    JPSUCCESS,
    JPFAILURE,
    JPCANCELLED
}JPPaymentStatus;

#define PaymentsStatusString(enum) [@[@"UNKNOWN",@"SUCCESS",@"FAILURE",@"CANCELLED"] objectAtIndex:enum]

#import <Foundation/Foundation.h>

@interface JPTransactionStatus : NSObject

- (id)initWithInfo:(NSDictionary*)info;

/**
 Identifies the merchant.
 */
@property (nonatomic, strong) NSString *merchantId;

/**
 MerchantId followed by platform name.
 */
@property (nonatomic, strong) NSString *clientID;

/**
 Represents the current transactionId.
 */
@property (nonatomic, strong) NSString *paymentID;

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *paymentStatusS;

/**
 Status of payment.
 */
@property (nonatomic) JPPaymentStatus paymentStatus;

@end
