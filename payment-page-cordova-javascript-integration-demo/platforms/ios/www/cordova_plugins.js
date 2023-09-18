cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "cordova-plugin-native-spinner.SpinnerDialog",
      "file": "plugins/cordova-plugin-native-spinner/www/SpinnerDialog.js",
      "pluginId": "cordova-plugin-native-spinner",
      "clobbers": [
        "SpinnerDialog"
      ]
    },
    {
      "id": "cordova-plugin-x-toast.Toast",
      "file": "plugins/cordova-plugin-x-toast/www/Toast.js",
      "pluginId": "cordova-plugin-x-toast",
      "clobbers": [
        "window.plugins.toast"
      ]
    },
    {
      "id": "hyper-sdk-plugin.HyperSDKPlugin",
      "file": "plugins/hyper-sdk-plugin/www/hypersdk.js",
      "pluginId": "hyper-sdk-plugin",
      "clobbers": [
        "cordova.plugins.HyperSDKPlugin"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-native-spinner": "1.1.4",
    "cordova-plugin-x-toast": "2.7.3",
    "hyper-sdk-plugin": "2.0.0"
  };
});