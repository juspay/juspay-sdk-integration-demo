package in.samplekit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet(name = "HandlePaymentResponse", urlPatterns = {"/handlePaymentResponse", "/initiatePayment"})
public class HandlePaymentResponse extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        decideRoute(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        decideRoute(request, response);
    }

    protected void decideRoute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.startsWith("/handlePaymentResponse")) {
            request.getRequestDispatcher("handlePaymentResponse.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("initiatePayment.jsp").forward(request, response);
        }
    }
}
