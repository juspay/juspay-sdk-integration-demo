package in.samplekit;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "HandlePaymentResponse", urlPatterns = {"/handlePaymentResponse", "/initiatePayment"})
public class HandlePaymentResponse extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        decideRoute(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        decideRoute(request, response);
    }

    protected void decideRoute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String path = request.getServletPath();
            if (path.startsWith("/handlePaymentResponse")) {
                request.getRequestDispatcher("handlePaymentResponse.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("initiatePayment.jsp").forward(request, response);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/text");
        }
    }
}
