package in.juspaybackendkit;

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
import java.util.Random;
import java.util.UUID;

// block:start:InitiateJuspayPayment
public class InitiateJuspayPayment extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderId = "order_" + UUID.randomUUID().toString().substring(12);
        int amount = new Random().nextInt(100) + 1;

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
}
// block:end:InitiateJuspayPayment
