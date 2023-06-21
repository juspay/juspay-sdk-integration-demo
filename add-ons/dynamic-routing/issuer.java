  def priorities = [ 'HDFC', 'ICICI' ] 
  // default priorities
  if (payment.cardIssuer == 'ICICI Bank') { 
    // if ICICI Bank card, use ICICI
    priorities = [ 'ICICI', 'HDFC' ]
  }
  else if (order.udf1 == 'mobile' && order.udf2 == 'android')
    // for android transactions, use ICICI
    priorities = [ 'ICICI', 'HDFC' ]
  }
  else { // for everything else use HDFC as primary
    priorities = [ 'HDFC', 'ICICI' ]
  }
  setGatewayPriority(priorities) 