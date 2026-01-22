var amount = order_reference.amount;
var udf3 = order_reference.udf3
var is_card = payment.method_type == "CARD";
var is_credit_card = payment.card_type == "CREDIT"
var resp = {};


if (is_card && is_credit_card && amount > 2000 && udf3 == "Ola_money") {
    resp.surcharge_rate = 1;
    resp.tax_rate = 0;
}
else {
    resp.surcharge_rate = 0;
    resp.tax_rate = 0;
}
resp;
