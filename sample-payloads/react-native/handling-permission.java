@Override
public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
     HyperSdkReactModule.onRequestPermissionsResult(requestCode, permissions, grantResults);
}