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
#import <UIKit/UIKit.h>

@interface BrowserParams : NSObject

//Transaction starting params

/**
 Url for starting transaction.
 */
@property (nonatomic, strong) NSString *url;

/**
 Data required to load along with url for starting transaction.
 */
@property (nonatomic, strong) NSString *postData;

/**
 Base64 encoded html file.
 */
@property (nonatomic, strong) NSString *html;

/**
 An array of enURLs to be checked if transaction has completed.
 @code if URL is like http://www.test.com/success
 params.endUrlRegexes = @[".*www.test.com/success.*"];
 */
@property (nonatomic, strong) NSArray *endUrlRegexes;

//Merchant specific params

/**
 Identifies the merchant.
 */
@property (nonatomic, strong) NSString *merchantId;

/**
 MerchantId followed by platform name.
 */
@property (nonatomic, strong) NSString *clientId;

//Transaction extra params

/**
 Represents the current transactionId.
 */
@property (nonatomic, strong) NSString *transactionId;

/**
 Represents the order number assigned by the merchant.
 */
@property (nonatomic, strong) NSString *orderId;

/**
 Unique identifier of the customer.
 */
@property (nonatomic, strong) NSString *customerId;

/**
 Short note about transaction shown to the customer. ex. 'Paying INR 200 for Order 123456'
 */
@property (nonatomic, strong) NSString *displayNote;

/**
 Remarks about transaction. This will be automatically filled up in the bank page.
 */
@property (nonatomic, strong) NSString *remarks;

/**
 Amount of the transaction.
 */
@property (nonatomic, strong) NSString *amount;

/**
 Cookies that need to be stored in browser.
 */
@property (nonatomic, strong) NSArray *cookies;

/**
 Custom activity indicator dialog view.
 */
@property (nonatomic, strong) UIView *customActivityIndicator;

/**
 Contents to show on confirmation alert view while cancelling the transaction.
 */
@property (nonatomic, strong) NSArray *confirmationAlertContents;

//Customer specific params

/**
 Email address of the customer.
 */
@property (nonatomic, strong) NSString *customerEmail;

/**
 Mobile number of the customer.
 */
@property (nonatomic, strong) NSString *customerPhoneNumber;

//Extra params
@property (nonatomic, strong) NSArray<NSString*> *whiteListedDomainsRegex;
@property (nonatomic, strong) NSDictionary *customParameters;

@end
