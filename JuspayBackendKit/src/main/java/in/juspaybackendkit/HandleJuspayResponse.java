package in.juspaybackendkit;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import in.juspay.exception.*;
import in.juspay.model.Order;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class HandleJuspayResponse extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderId = req.getParameter("order_id");

        if (orderId == null || orderId.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(makeErrorMsg("order_id not present or cannot be empty"));
            return;
        }

        try {
            Order orderStatus = Order.status(orderId);

            String message;
            switch (orderStatus.getStatus()) {
                case "CHARGED":
                    message = "order payment done successfully";
                    break;
                case "PENDING":
                case "PENDING_VBV":
                    message = "order payment pending";
                    break;
                case "AUTHORIZATION_FAILED":
                    message = "order payment authorization failed";
                    break;
                case "AUTHENTICATION_FAILED":
                    message = "order payment authentication failed";
                    break;
                default:
                    message = "order status " + orderStatus.getStatus();
                    break;
            }

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("application/json");
            JsonObject orderStatusResponse = new JsonObject();
            orderStatusResponse.addProperty("order_id", orderId);
            orderStatusResponse.addProperty("message", message);
            orderStatusResponse.addProperty("order_status", orderStatus.getStatus());
            String jsonString = new Gson().toJson(orderStatusResponse);
            resp.getWriter().write(jsonString);
        }
        catch (JuspayException e) {
            e.printStackTrace();
            resp.setStatus(e.getHttpResponseCode());
            resp.setContentType("application/json");
            resp.getWriter().write(makeErrorMsg(e.getStatus()));
        }
    }

    private String makeErrorMsg(String msg) {
        return "{\n  \"message\": \"" + msg + "\"\n}";
    }
}
