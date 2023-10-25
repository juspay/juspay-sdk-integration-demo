# How to run this sample kit
- Go to root folder of this project where composer.json is located in terminal
- Run ```composer install``` to install all required dependency
- Place generated privateKey.pem and publicKey.pem in root folder of this project
- Replace key id and merchant id in Program.php
- Run php Program.php from root folder of this project

# How to Integrate into existing project
- Remove ```require realpath(__DIR__ .  '/vendor/autoload.php');``` in Program.php
- Run ```composer require juspay/expresscheckout-php-sdk``` to add this sdk as a dependency to your project
- Run ```composer install``` to all dependency of your project

[detailed docs](https://packagist.org/packages/juspay/expresscheckout-php-sdk)