# HyperSDK Cordova plugin

## Table of Contents

- [To run the Plugin integrated with Demo App](#Run)

## To run the Plugin integrated with Example Demo App



## Minimum Requirement

### Android

The minimum version of cordova-android supported with HyperSDK is [10.0.0](https://github.com/apache/cordova-android/blob/master/RELEASENOTES.md#1000-jul-17-2021) which uses `androidx` and `AppCompatActivity`.


## Prerequisites

1. [npm](https://www.npmjs.com/)
2. Java


## Steps to run

### Providing the Customer and Merchant details

Update the Customer and Merchant details present in `CustomerConfig.json` and `MerchantConfig.json`
```
{
  "service": "",
  "merchantId": "",
  "clientId": "",
  "apiKey": "",
  "privateKey": "",
  "merchantKeyId": "",
  "environment": "",
  "returnUrl": ""
}

{
  "customerId": "",
  "mobile": "",
  "email": "",
  "amount": ""
}

```

### Install cordova

```
npm install -g cordova

```

### Below commands have to be executed in Example Demo App

Navigate to Example Demo App -> cd example


### Prepare the platform 

```
cordova prepare <android/ios>

```

### For Android 

Modify the clientId in platforms/android/build.gradle then buildscript -> ext -> clientId. Provide the clientId given to you by the Juspay team.

### For IOS

Modify the clientId in platforms/ios/MerchantConfig.txt. Provide the clientId given to you by the Juspay team.

Navigate to platforms/ios/Podfile and add the below `Post Install` script in that file.

```
post_install do |installer|
 fuse_path = "./Pods/HyperSDK/Fuse.rb"
 clean_assets = false # Pass true to re-download all the assets
 if File.exist?(fuse_path)
   if system("ruby", fuse_path.to_s, clean_assets.to_s)
   end
 end
end

```

Run `pod install` in platforms/ios

```
pod install

```

### Build the Demo-App


Build the app using 

```
cordova build <android/ios>

```

### Run the app

Run the app using 

```
cordova run <android/ios>

```