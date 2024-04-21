<%@ page import="java.io.*,java.util.*,in.samplekit.PaymentHandler" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Merchant payment status page</title>
</head>
<body>
    <center>

        <!-- block:start:order-status -->
                <font size="4" color="blue"><b>Return url request body params</b></font>
                <table border="1">

                    <%
                        Enumeration enumeration=request.getParameterNames();
                         String name="", value="";
                         while(enumeration.hasMoreElements()) {
                              name = ""+enumeration.nextElement();
                              value = request.getParameter(name);
                    %>
                            <tr>
                                <td><%= name %></td>
                                <td><%= value %></td>
                            </tr>
                    <%
                        }
                    %>
                </table>
            </center>
        <!-- block:end:order-status -->

    <%
        try {
            PaymentHandler paymentHandler = new PaymentHandler();

            String orderId = request.getParameter("order_id");
            String reqStatus = request.getParameter("status");
            String statusId = request.getParameter("status_id");
            String signature = request.getParameter("signature");

            LinkedHashMap<String, String> param = new LinkedHashMap<String, String>();
            param.put("order_id", orderId);
            param.put("status", reqStatus);
            param.put("status_id", statusId);

            if(paymentHandler.validateHMAC_SHA256(param, signature) == false) {
    %>
                <h1>"Signature verification failed"</h1>
    <%
                return;
            }

            Map<String, Object> orderStatusResponse = paymentHandler.orderStatus(orderId);
            Integer amount = (Integer) orderStatusResponse.get("amount");

            String message = "Your order with order_id " + orderId + " and amount " + amount + " has the following status: ";
            String status = (String) orderStatusResponse.get("status");

            switch (status) {
                case "CHARGED":
                    message += "order payment done successfully";
                    break;
                case "PENDING":
                case "PENDING_VBV":
                    message += "order payment pending";
                    break;
                case "AUTHORIZATION_FAILED":
                    message += "order payment authorization failed";
                    break;
                case "AUTHENTICATION_FAILED":
                    message += "order payment authentication failed";
                    break;
                default:
                    message += "order status " + status;
                    break;
            }
    %>

    <h1><%= message %></h1>

    <center>
        <font size="4" color="blue"><b>Response received from order status payment server call</b></font>
        <table border="1">
            <%
                for (Map.Entry<String, Object> entry : orderStatusResponse.entrySet()) {
                    String pname = entry.getKey();
                    String pvalue = entry.getValue() != null ? entry.getValue().toString() : "";
            %>
                    <tr>
                        <td><%= pname %></td>
                        <td><%= pvalue %></td>
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
