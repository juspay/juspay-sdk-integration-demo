package in.juspaybackendkit;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import in.juspay.exception.JuspayException;
import in.juspay.model.OrderSession;
import in.juspay.model.RequestOptions;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

public class InitiateJuspayPayment extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonNode payload = getBody(req);
        if (payload == null) {
            resp.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            resp.getWriter().write(makeErrorMsg("only accepts application/json"));
            return;
        }

        String orderId = "order_" + UUID.randomUUID().toString().substring(12);
        String amount;

        if (payload.has("order_id") && !payload.get("order_id").asText().isEmpty()) {
            orderId = payload.get("order_id").asText();
        }

        if (!payload.has("amount")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(makeErrorMsg("amount is not present or not empty"));
            return;
        } else {
            amount = payload.get("amount").asText();
        }

        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();

        String paymentPageClientId = JuspayConfig.payment_page_client_id;
        String customerId = "hdfc-testing-customer-one";
        String scheme = req.getScheme();
        String returnUrl = scheme + "://" + serverName + ":" + serverPort + contextPath + "/handleJuspayResponse";

        try {
            Map<String, Object> params = new LinkedHashMap<>();
            params.put("order_id", orderId);
            params.put("payment_page_client_id", paymentPageClientId);
            params.put("amount", amount);
            params.put("customer_id", customerId);
            params.put("action", "paymentPage");
            params.put("return_url", returnUrl);
            params.put("currency", "INR");
            RequestOptions requestOptions = RequestOptions.createDefault().withCustomerId(customerId);
            OrderSession orderSession = OrderSession.create(params, requestOptions);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("application/json");
            String responseString = new Gson().toJson(orderSession);
            resp.getWriter().write(responseString);
        } catch (JuspayException e) {
            e.printStackTrace();
            resp.setStatus(e.getHttpResponseCode());
            resp.setContentType("application/json");
            resp.getWriter().write(makeErrorMsg(e.getErrorMessage()));
        }
    }

    private String makeErrorMsg(String msg) {
        return "{\n  \"message\": \"" + msg + "\"\n}";
    }

    private JsonNode getBody(HttpServletRequest req) {
        try {
            return new ObjectMapper().readValue(req.getInputStream(), JsonNode.class);
        } catch (Exception e) {
            return null;
        }
    }
}
