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

typedef enum{
    CARDTYPEUNKNOWN,
    DEBITCARD,
    CREDITCARD
}JPSCardType;

typedef enum{
    UNKNOWN,
    MAESTRO,
    VISA,
    MASTERCARD,
    DINERSCLUB,
    JCB,
    DISCOVER,
    AMEX
}JPSCardBrand;

#import <Foundation/Foundation.h>

@interface JPCard : NSObject

@property (nonatomic, assign) JPSCardType cardType;
@property (nonatomic, assign) JPSCardBrand cardBrand;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *cvc;
@property (nonatomic, assign) NSUInteger expMonth;
@property (nonatomic, assign) NSUInteger expYear;
@property (nonatomic, readonly) NSString *last4;

- (void)setCardsBrand:(NSString*)cardNumber;

@end
