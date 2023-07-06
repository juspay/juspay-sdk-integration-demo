//block:start:onBackPressed
@Override
public void onBackPressed() {
    boolean backPressHandled = hyperServices.onBackPressed();
    if(!backPressHandled) {
        super.onBackPressed();
    }
}
//block:end:onBackPressed