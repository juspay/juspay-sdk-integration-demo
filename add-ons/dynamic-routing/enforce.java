  def priorities = ["AXIS", "ADYEN"] 
if (order.udf1 == "payu_offer") {
    priorities = ["ADYEN"]
    enforceGatewayPriority(priorities)
}
else {
    setGatewayPriority(priorities)
}