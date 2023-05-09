//block:start:onBackPressed
    @Override
    public void onBackPressed() {
        boolean handleBackpress = hyperServicesHolder.handleBackPress();
        if(handleBackpress) {
            super.onBackPressed();
        }

    }
    //block:end:onBackPressed