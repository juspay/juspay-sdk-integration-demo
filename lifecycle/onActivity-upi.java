@Override
protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
   hyperServices.onActivityResult(requestCode, resultCode, data);
   // merchant code...
}