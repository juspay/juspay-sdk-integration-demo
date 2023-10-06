 def priorities = ['HDFC', 'ICICI', 'ADYEN'] 
  // above is the default priority

  if (order.udf1 == 'web') {
    priorities = ['HDFC','ADYEN','ICICI']
  }
  else if (order.udf1 == 'mobile' && order.udf2 == 'android')
    priorities = ['ICICI','HDFC','ADYEN']
  }
  setGatewayPriority(priorities)