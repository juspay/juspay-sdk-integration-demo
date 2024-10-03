var amount = order_reference.amount;
var is_domestic = payment.card_issuer_country && payment.card_issuer_country.toLowerCase() == "india";
var card_type = payment.card_type;
var card_brand = payment.card_brand;
var method = payment.method;
var is_card = payment.method_type == "CARD";
var resp = {};
var card_bin = payment.card_bin;
resp.fixed_surcharge_amount = null;

if (is_card && is_domestic) {
    if (card_bin == "408849" || card_bin == "508553" || card_bin == "416021" || card_bin == "459156" || card_bin == "652163" || card_bin == "552093" || card_bin == "526799") {
        resp.surcharge_rate = 10.0;
        resp.tax_rate = 0.0;
    }
    else if (card_type == "DEBIT" && card_brand == "RUPAY") {
        resp.surcharge_rate = 5.0;
        resp.tax_rate = 0.0;
    }
    else if (card_type == "CREDIT") {
        resp.surcharge_rate = 6.0;
        resp.tax_rate = 0.0;
    } else if (card_type == "PREPAID") {
        resp.surcharge_rate = 7.0;
        resp.tax_rate = 0.0;
    } else {
        resp.surcharge_rate = 8.0;
        resp.tax_rate = 0.0;
    }
}
resp;
