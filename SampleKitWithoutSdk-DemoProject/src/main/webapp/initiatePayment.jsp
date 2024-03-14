<%@ page import = "java.io.*,java.util.*,in.samplekit.PaymentHandler" %>
<html>
<head>
	<title>Merchant checkout page</title>
</head>
<body>
	<%
     try {
         PaymentHandler paymentHandler = new PaymentHandler();

         String orderId = "ord_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
         int amount = new Random().nextInt(100) + 1;

         String serverName = request.getServerName();
         int serverPort = request.getServerPort();
         String contextPath = request.getContextPath();

         String customerId = "hdfc-testing-customer-one";
         String scheme = request.getScheme();
         String returnUrl = scheme + "://" + serverName + ":" + serverPort + contextPath + "/handlePaymentResponse";

         Map<String, Object> params = new LinkedHashMap<String, Object>();
         params.put("order_id", orderId);
         params.put("payment_page_client_id", paymentHandler.paymentHandlerConfig.getPaymentPageClientId());
         params.put("amount", amount);
         params.put("customer_id", customerId);
         params.put("action", "paymentPage");
         params.put("return_url", returnUrl);
         params.put("currency", "INR");
         Map<String, Object> orderSessionResponse = paymentHandler.orderSession(params);
         Map<String, Object> paymentLinksObject = (Map<String, Object>) orderSessionResponse.get("payment_links");
         String webPaymentLink = (String) paymentLinksObject.get("web");
         response.sendRedirect(webPaymentLink);
    } catch (PaymentHandler.APIException e) {
%>
        <p> Payment server threw a non-2xx error. Error message:  <%= e.getMessage() %> </p>
<%
    } catch (Exception e) {
%>
        <p> Unexpected error occurred, Error message:  <%= e.getMessage() %> </p>
<%
    }
%>

 </body>
</html>
