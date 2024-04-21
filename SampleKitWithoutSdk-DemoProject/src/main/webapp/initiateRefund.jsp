<%@ page import="java.io.*,java.util.*,in.samplekit.PaymentHandler" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    try {
         PaymentHandler paymentHandler = new PaymentHandler();
         String orderId = (String) request.getParameter("order_id");
         String amount = (String) request.getParameter("amount");
         String refundId = request.getParameter("unique_request_id");
         if (refundId == null) {
            refundId = "ord_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
         } else {
            refundId = (String) refundId;
         }

         Map<String, Object> params = new LinkedHashMap<String, Object>();
         params.put("unique_request_id", refundId);
         params.put("order_id", orderId);
         params.put("amount", amount);
         Map<String, Object> refundResponse = paymentHandler.refund(params);
         String refundStatus = (String) refundResponse.get("status");
%>
<html>
<head>
    <title>Merchant Refund</title>
</head>
<body>
    <h1>Refund status:- <%= refundStatus %></h1>
    <p>Here is the stringified map response:- </p>
    <p><%= refundResponse %></p>

    <center>
        <font size="4" color="blue"><b>Response received from order status payment server call</b></font>
        <table border="1">
            <%
                String pair=null, pname=null, pvalue=null;
                for (Map.Entry<String, Object> entry : refundResponse.entrySet()) {
                    pname = entry.getKey();
                    pvalue = entry.getValue() != null ? entry.getValue().toString() : "";
            %>
                <tr>
                    <td><%= pname %> </td>
                    <td> <%= pvalue %> </td>
                </tr>
            <%
                }
            %>
        </table>
    </center>

<%
    } catch (PaymentHandler.APIException e) {
%>
        <p> Payment server threw a non-2xx error. Error message:  <%= e.getMessage() %> </p>
<%
    } catch (Exception e) {
%>
        <p> Unexpected error occurred </p>
<%
    }
%>

</body>
</html>
