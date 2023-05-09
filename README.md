# How to use this repo#

### What is this repository for? ###

* This repo is being used for Juspay Documentation made using tesseract repo
* This directory contains demo integration project for Juspay's suite of products

Refer to the docs.juspay.in for details around the integration process.

### Maintained Examples

| Folder Name                  | Product                                  | Platform                                   |
|------------------------------|------------------------------------------|--------------------------------------------|
| api-reference                | Collection of APIs used across products  | Agnostic                                   |
| ec-headless-sample           | Express Checkout SDK                     | Andriod, iOS, Flutter, React, Cordova      |
| payment-page-android         | Payment Page                             | Android                                    |
| payment-page-ios             | Payment Page                             | iOS                                        |
| payment-page-web             | Payment Page                             | Web                                        |
| payment-page-flutter         | Payment Page                             | Flutter                                    |
| payment-page-cordova         | Payment page                             | Cordova                                    |
| payment-page-react-native    | Payment page                             | React Native                               |
| payment-page-payment-locking | Payment locking feature for Payment Page | Andriod, iOS, Flutter, React, Cordova      |
| payv3-forms                  | payv3                                    | Web                                        |
| payment-page-sample-payload  | Sample payload for payment page          | Andriod, iOS, Flutter, React, Cordova, Web |

### How do I get set up? ###

* This repo is used to show the code section of the documentation.

### Contribution guidelines ###

* If you want to add any new product and/or platform. please follow the below steps.

1. All the code content of a particular platform of a product is kept in a branch "productName" + "-" + "platformName".
    Let suppose you are adding code for platform android in the product payment-page then the name of the branch will be 
        payment-page-android

2. And payment-page-android code have both Java and Kotlin so there will be two folders named accordingly and each folder should contain their demo code.
