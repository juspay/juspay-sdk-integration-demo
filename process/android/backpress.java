@Override
public void onBackPressed() {
    boolean backPressHandled = hyperInstance.onBackPressed();
    if(!backPressHandled) {
        super.onBackPressed();
    }
}