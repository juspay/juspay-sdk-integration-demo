  def priorities = ["AXIS", "PAYU"] 
if (order.udf1 == "payu_offer") {
    priorities = ["PAYU"]
    enforceGatewayPriority(priorities)
}
else {
    setGatewayPriority(priorities)
}