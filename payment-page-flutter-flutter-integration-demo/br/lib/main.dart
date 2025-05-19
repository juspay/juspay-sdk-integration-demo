import 'package:flutter/material.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:flutter/services.dart';
import './screens/home.dart';

void main() {
  final hyperSDK = HyperSDK();
  runApp(MyApp(hyperSDK: hyperSDK));
}

class MyApp extends StatelessWidget {
  // Create Juspay Object
  // // block:start:create-hyper-sdk-instance
  final HyperSDK hyperSDK;
  // // block:end:create-hyper-sdk-instance
  const MyApp({Key? key, required this.hyperSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // Call this function only once in a session
    // block:start:create-tenant-instance
    hyperSDK.createHyperServicesWithTenantId("<tenant_name>", "<client_d>");
    // block:end:create-tenant-instance

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        hyperSDK: hyperSDK,
      ),
    );
  }
}
