  def priorities = ['HDFC', 'ICICI', 'ADYEN'] 
  // default priorities
  if (payment.cardBrand == 'MAESTRO') { 
    // if Maestro card, use ICICI as primary
    priorities = ['ICICI', 'ADYEN', 'HDFC']
  }
  else if (payment.cardBrand == 'AMEX')
    priorities = ['ADYEN', 'ICICI', 'HDFC']
  }
  setGatewayPriority(priorities)