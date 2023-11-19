<form class="juspay_inline_form" id="payment_form">
    <input type="hidden" class="merchant_id" value="guest">
    <input type="hidden" class="order_id" value="guest_order"/>
    <input type="text" class="card_number" placeholder="Card number">
    <input type="text" class="name_on_card" placeholder="Cardholder name">
    <input type="text" class="card_exp_month" placeholder="MM"> - <input type="text" class="card_exp_year" placeholder="YYYY">
    <input type="text" class="security_code" placeholder="CVV" >
    <input type="checkbox"  class="juspay_locker_save"> Save card information
    <button type="submit" class="make_payment">Pay</button>
    <input type="hidden" class="redirect" value="true">
</form>