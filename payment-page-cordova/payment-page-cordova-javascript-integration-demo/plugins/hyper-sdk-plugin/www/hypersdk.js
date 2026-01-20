    
    var cordova = require("cordova"),
        exec = require("cordova/exec");

    // Using shared callback as HyperSDK is more event based
    // than callback based
    var sharedCallback;

    // Helper method to call the native plugin
    function callNative(name, args, pluginCallback) {
        args = args || []
        exec(pluginCallback, pluginCallback, "HyperSDKPlugin", name, [args])
    }

    /**
     * @module HyperSDK
     */
    module.exports = {
        preFetch: function (payload, callback) {
            callNative("preFetch", payload, callback);
        },
        initiate: function (payload, callback) {
            sharedCallback = callback;
            callNative("initiate", payload, sharedCallback);
        },
        process: function (payload) {
            callNative("process", payload, sharedCallback);
        },
        onBackPress: function (callback) {
            callNative("backPress", {}, callback);
        },
        terminate: function () {
            callNative("terminate", {}, sharedCallback);
        },
        isInitialised: function () {
            callNative("isInitialised", {}, sharedCallback);
        }
    }