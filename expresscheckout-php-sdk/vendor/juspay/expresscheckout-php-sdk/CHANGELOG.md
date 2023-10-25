# Change Log

## [1.0.3] - 2017-02-28
### Added
- Added paymentMethod and paymentMethodType in Order class.
- Added implementation for Wallet create, createAndAuthenticate, authenticate, link & delink.
- Added implementation for wallet refresh by walletId.
- Added implementation for PaymentMethod list api.

## [1.0.2] - 2016-11-11
### Added
- Added PaymentLinks.php class, which contains the payment links for an order.
- Now the object of Order class will contain a reference to an object of PaymentLinks class.

## [1.0.1] - 2016-08-30
### Added
- API implementation for Order create, update, list, status and refund.
- API implementation for Transaction create.
- API implementation for Card create, list, delete and tokenize.
- API implementation for Customer create, update, and get.
- API implementation for Wallet list and refresh.
