/**
 *
 * Returns a list of expenses that have been processed with a String status in each Object after execution
 * also returns a list of messages for run time status
 */
package Module.Expense;

import Entity.PaymentFactory;
import Entity.Token;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExecuteExpenses extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> messages = new ArrayList<>();
        messages.add("Errors from ExecuteExpenses");
        try {
            
            PaymentFactory pf = (request.getSession().getAttribute("paymentFactory") != null) ? (PaymentFactory) request.getSession().getAttribute("paymentFactory") : null;
            if (pf == null) {
                throw new IllegalArgumentException("No payment factory found at ExecuteExpenses servlet");
            } else if (pf.getPrePayments() == null || pf.getPrePayments().isEmpty()) {
                throw new IllegalArgumentException("No payments found in payment factory");
            }
            
            Token token = pf.getToken();
            if (token == null) {
                throw new IllegalArgumentException("No token found");
            }

            ExecutorService executorService = Executors.newSingleThreadExecutor();
            
            // Call QBO or XERO callable and redirect
            switch (token.getAccType().toLowerCase()) {
                // QBO
                case "qbo":
                    QBOCallable qboCallable = new QBOCallable(pf);
                    Future<PaymentFactory> qboFuture = executorService.submit(qboCallable);
                    request.getSession().setAttribute("expenseFuture", qboFuture);
                    break;
                // XERO
                case "xero":
                    /*
                    XEROCallable xeroCallable = new XEROCallable(pf);
                    Future<ExpenseFactory> xeroFuture = executorService.submit(xeroCallable);
                    request.getSession().setAttribute("expenseFuture", xeroFuture);
                    break;
                    */
                    throw new IllegalArgumentException("XERO not supported yet");

                default:
                    throw new IllegalArgumentException("No account type of " + token.getAccType() + " found");
            }

            // Set future into request session
            // Callable has been successfully created
            response.sendRedirect("ExpenseResults.jsp");
            return;

        } catch (NullPointerException npe) {
            messages.add("NullPointerException caught" + npe.getMessage());
        } catch (IllegalArgumentException iae) {
            messages.add("IllegalArgumentException caught" + iae.getMessage());
        } catch (IOException ioe) {
            messages.add("IOException caught" + ioe.getMessage());
        }

        request.setAttribute("messages", messages);
        request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
