  def priorities = ['HDFC', 'ICICI', 'PAYU'] 
  // default priorities
  if (payment.cardBrand == 'MAESTRO') { 
    // if Maestro card, use ICICI as primary
    priorities = ['ICICI', 'PAYU', 'HDFC']
  }
  else if (payment.cardBrand == 'AMEX')
    priorities = ['PAYU', 'ICICI', 'HDFC']
  }
  setGatewayPriority(priorities)