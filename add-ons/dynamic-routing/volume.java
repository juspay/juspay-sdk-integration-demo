  // def myGateways = ['HDFC','ICICI']
  // Goal: 50% approx split between two gateways

  if(currentTimeMillis % 10 < 5) {
    setGatewayPriority(['HDFC', 'ICICI'])
  }
  else {
    setGatewayPriority(['ICICI', 'HDFC'])  
  }

  // def myGateways = ["HDFC","ICICI", "AXIS"]
  // Goal: 1/2 split between two gateways and use third as backup
  if(currentTimeMillis % 10 < 5) {
    setGatewayPriority(['HDFC', 'ICICI', 'AXIS'])
  }
  else {
    setGatewayPriority(['ICICI', 'HDFC', 'AXIS'])
  } 