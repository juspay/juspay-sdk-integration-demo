

@Override
protected void onStart() {
    super.onStart();
    //block:start:create-hyper-services-instance
    
    hyperServicesHolder = new HyperServiceHolder(this);

    //block:end:create-hyper-services-instance
    initiatePaymentsSDK();
    proceedButton = findViewById(R.id.rectangle_8);
    itemCountTv1 = findViewById(R.id.some_id);
    itemCountTv2 = findViewById(R.id.some_id2);
    proceedButton.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            if(item1Count>=1 || item2Count >=1){
                Intent intent = new Intent(ProductsActivity.this, CheckoutActivity.class);
                intent.putExtra("item1Count", item1Count);
                intent.putExtra("item2Count", item2Count);
                intent.putExtra("item1Price", item1Price);
                intent.putExtra("item2Price", item2Price);
                startActivity(intent);
            } else {
                Toast.makeText(ProductsActivity.this, "You should add atlease one item", Toast.LENGTH_SHORT).show();
            }
        }
    });
}

  