 def priorities = ['HDFC', 'ICICI', 'PAYU'] 
  // above is the default priority

  if (order.udf1 == 'web') {
    priorities = ['HDFC','PAYU','ICICI']
  }
  else if (order.udf1 == 'mobile' && order.udf2 == 'android')
    priorities = ['ICICI','HDFC','PAYU']
  }
  setGatewayPriority(priorities)