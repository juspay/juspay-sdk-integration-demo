/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

const fs = require('fs');

const _ = require('lodash');
const xml2js = require('xml2js');
const path = require('path')

//This will help in getting the cordova application structure.
const utilities = {
    getAndroidResPath: function(context) {

        var platforms = context.opts.cordova.platforms;
        //check for the platform is android or not
        if (platforms.indexOf("android") === -1) {
            return null;
        }

        var androidPath = context.opts.projectRoot + '/platforms/android/app/src/main';

        if (!fs.existsSync(androidPath)) {
            androidPath = context.opts.projectRoot + '/platforms/android';

            // This will detect what application structure we are getting.
            if (!fs.existsSync(androidPath)) {
                console.log("Unable to detect type of cordova-android application structure");
                throw new Error("Unable to detect type of cordova-android application structure");
            } else {
                console.log("Detected pre cordova-android 7 application structure");
            }
        } else {
            console.log("Detected cordova-android 7 application structure");
        }

        return androidPath;
    },

    getAndroidManifestPath: function(context) {
        return this.getAndroidResPath(context);
    },

    // This will help in getting the androidPath
    getAndroidSourcePath: function(context) {
        var platforms = context.opts.cordova.platforms;

         //check for the platform is android or not
        if (platforms.indexOf("android") === -1) {
            return null;
        }

        var androidPath = context.opts.projectRoot + '/platforms/android/app/src/main/java';

        if (!fs.existsSync(androidPath)) {
            androidPath = context.opts.projectRoot + '/platforms/android/src';

            if (!fs.existsSync(androidPath)) {
                console.log("Unable to detect type of cordova-android application structure");
                throw new Error("Unable to detect type of cordova-android application structure");
            } else {
                console.log("Detected pre cordova-android 7 application structure");
            }
        } else {
            console.log("Detected cordova-android 7 application structure");
        }

        return androidPath;
    },

    updateClientProject: function(context, packageName) {
        const packagePath = packageName.replace(/\./g, "/");
        // HyperActivity
        const hyperActivityInputPath = utilities.getAndroidSourcePath(context) + "/in/juspay/hypersdk/HyperActivity.java";
        const hyperActivityOutputPath = utilities.getAndroidSourcePath(context) + "/" + packagePath + '/HyperActivity.java';

        // Replacing packageName in HyperActivity with app's packageName and writing it to the merchant's packagePath
        let hyperActivityCode = fs.readFileSync(hyperActivityInputPath).toString();
        hyperActivityCode = hyperActivityCode.replace(/\$\{mypackage\}/g, packageName);
        fs.writeFile(hyperActivityOutputPath, hyperActivityCode, function (err) {
            if (err) return console.error(err);
        });

        // deleting the old HyperActivity
        fs.unlink(hyperActivityInputPath, function (err) {
            if (err) return console.error(err);
        });

        // ProcessActivity
        const processActivityInputPath = utilities.getAndroidSourcePath(context) + "/in/juspay/hypersdk/ProcessActivity.java";
        const processActivityOutputPath = utilities.getAndroidSourcePath(context) + "/" + packagePath + '/ProcessActivity.java';

        // Replacing packageName in ProcessActivity with app's packageName and writing it to the merchant's packagePath
        let processActivityCode = fs.readFileSync(processActivityInputPath).toString();
        processActivityCode = processActivityCode.replace(/\$\{mypackage\}/g, packageName);
        fs.writeFile(processActivityOutputPath, processActivityCode, function (err) {
            if (err) return console.error(err);
        });

        // deleting the old ProcessActivity
        fs.unlink(processActivityInputPath, function (err) {
            if (err) return console.error(err);
        });


        // Replacing packageName in HyperSDKPlugin with app's packageName
        const hyperSdkPluginPath = utilities.getAndroidSourcePath(context) +"/in/juspay/hypersdk/HyperSDKPlugin.java";
        let hyperSdkPluginCode = fs.readFileSync(hyperSdkPluginPath).toString();
        hyperSdkPluginCode = hyperSdkPluginCode.replace(/\$\{mypackage\}/g, packageName);
        fs.writeFileSync(hyperSdkPluginPath, hyperSdkPluginCode, function (err) {
            if (err) return console.error(err);
        });

        // Add the Complete path to the MainActivity
        const mainActivityPath = utilities.getAndroidSourcePath(context) + "/" + packagePath + '/MainActivity.java';

        // will replace FragmentActivity with our HyperActivity.
        let mainActivityCode = fs.readFileSync(mainActivityPath).toString();
        const newSuperClass = "extends HyperActivity";
        mainActivityCode = mainActivityCode.replace("extends CordovaActivity", newSuperClass);


        // This will add 'in.juspay.hypersdk.HyperActivity' into our MainActivity
        // so that HyperActivity.java could be accessed directly.
        fs.writeFile(mainActivityPath, mainActivityCode, function(err) {
            if (err) return console.error(err);
        });
    }
};


// context will help to get the path of files
module.exports = (context) => {

    // Write on the rootGradlePath and replaces it with gradle
    let rootGradlePath = context.opts.projectRoot + '/platforms/android/build.gradle';
    var rootGradleString = fs.readFileSync(rootGradlePath).toString();

    let pluginClassPath = `classpath "in.juspay:hypersdk.plugin:2.0.4"`;
    let clientIdExt = `ext {\n\t\tclientId = "<clientId shared by Juspay team>"\n\t}\n`;
    let finalString = (clientIdExt + '\tdependencies {\n\t\t' + pluginClassPath).replace(/\t/g, '    ')
    rootGradleString = rootGradleString.replace('dependencies {', finalString);


    fs.writeFile(rootGradlePath, rootGradleString, function(err) {
        if (err) return console.error(err);
    });

    // Write on the repositoryGradlePath and replaces it with maven
    let repositoryGradlePath = context.opts.projectRoot + '/platforms/android/repositories.gradle';
    var repositoryGradleString = fs.readFileSync(repositoryGradlePath).toString();

    let maven = `\tmaven { url "https://maven.juspay.in/jp-build-packages/hyper-sdk/" }\n`.replace(/\t/g, '    ');
    repositoryGradleString = repositoryGradleString.replace("}", maven + "}");

    fs.writeFile(repositoryGradlePath, repositoryGradleString, function(err) {
        if (err) return console.error(err);
    });

     // This block will help us to get MainActivity's Path
    let androidManifestPath = utilities.getAndroidManifestPath(context);

    if (androidManifestPath != null) {
        const parseString = xml2js.parseString;
        const manifestPath = androidManifestPath + '/AndroidManifest.xml';
        const androidManifest = fs.readFileSync(manifestPath).toString();
        const configFilePath = context.opts.projectRoot + '/config.xml';
        if (androidManifest) {
            parseString(androidManifest, (err, manifest) => {

                if (err) throw new Error('Error parsing AndroidManifest', err);

                // Getting the package name from the manifest
                let packageName = manifest['manifest']['$']['package']
                if (!packageName) {
                    let configXmlData = fs.readFileSync(configFilePath).toString();
                    xml2js.parseString(configXmlData, (error, configData) => {
                      if (error) {
                          throw new Error('Error parsing config.xml:', error);
                      }
                      const widget = configData.widget;
                      if (widget && widget.$) {
                        const androidPackageName = widget.$['android-packageName'];
                        const idAttributeValue = widget.$.id;
                        packageName = androidPackageName || idAttributeValue;
                        if (!packageName) {
                            throw new Error("Could not fetch packageName from config.xml, please add id or android-packageName in widget element of config.xml");
                        }
                        utilities.updateClientProject(context, packageName);
                      } else {
                        throw new Error('Widget element not found in config.xml');
                      }
                    });
                } else {
                    utilities.updateClientProject(context, packageName);
                }
            })
        }
    }
}
