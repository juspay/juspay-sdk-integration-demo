var amount = order_reference.amount;
var resp = {};

if (amount > 100 && amount < 200) {
    resp.surcharge_rate = 5.0;
    resp.tax_rate = 1;
}
else if (amount > 200 && amount < 300) {
    resp.surcharge_rate = 10.0;
    resp.tax_rate = 2;
}
else {
    resp.surcharge_rate = 0;
    resp.tax_rate = 0;
}
resp;
