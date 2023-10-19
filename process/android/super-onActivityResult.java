@Override
protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
   hyperInstance.onActivityResult(requestCode, resultCode, data);
   // merchant code...
}