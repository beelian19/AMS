/**
 *
 * Returns a list of expenses that have been processed with a String status in each Object after execution
 * also returns a list of messages for run time status
 */
package Module.Expense;

import DAO.TokenDAO;
import Entity.Client;
import Entity.Expense;
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

        try {

            // Get the list of expenses
            ExpenseFactory ef;
            if (request.getSession().getAttribute("expenseFactory") == null) {
                throw new IllegalArgumentException("No expense factory found at ExecuteExpenses servlet");
            }
            ef = (ExpenseFactory) request.getSession().getAttribute("expenseFactory");
            List<Expense> expenses = ef.getExpenses();
            if (expenses.isEmpty()) {
                throw new IllegalArgumentException("No expense found in expense factory");
            }

            // Get token
            Token token;
            if (request.getAttribute("expenseToken") == null) {
                throw new IllegalArgumentException("No token in attribute expenseToken found");
            } else {
                token = (Token) request.getAttribute("expenseToken");
                token.setInUse("1");
                // Update the database that the client's token is in use
                if (!TokenDAO.updateToken(token)) {
                    throw new IllegalArgumentException("Update token failed");
                }
                
                ef.setToken(token);
            }

            // Get Client
            Client client;
            String realmid;
            if (request.getAttribute("expenseClient") == null) {
                throw new IllegalArgumentException("No client in attribute expenseClient found");
            } else {
                client = (Client) request.getAttribute("expenseClient");
                realmid = client.getRealmid();
                if (realmid == null || realmid.equals("")) {
                    throw new IllegalArgumentException("No realmid for client " + client.getCompanyName());
                }
            }

            ExecutorService executorService = Executors.newSingleThreadExecutor();
            
            // Call QBO or XERO callable and redirect
            switch (token.getAccType().toLowerCase()) {
                // QBO
                case "qbo":
                    QBOCallable qboCallable = new QBOCallable(ef);
                    Future<ExpenseFactory> qboFuture = executorService.submit(qboCallable);
                    request.getSession().setAttribute("expenseFuture", qboFuture);
                    break;
                // XERO
                case "xero":
                    XEROCallable xeroCallable = new XEROCallable(ef);
                    Future<ExpenseFactory> xeroFuture = executorService.submit(xeroCallable);
                    request.getSession().setAttribute("expenseFuture", xeroFuture);
                    break;

                default:
                    throw new IllegalArgumentException("No account type of " + token.getAccType() + " found");
            }

            // Set future into request session
            // Callable has been successfully created
            response.sendRedirect("ExpenseResults.jsp");

        } catch (NullPointerException npe) {
            messages.add("NullPointerException caught" + npe.getMessage());
        } catch (IllegalArgumentException iae) {
            messages.add("IllegalArgumentException caught" + iae.getMessage());
        } catch (IOException ioe) {
            messages.add("IOException caught" + ioe.getMessage());
        }

        request.setAttribute("messages", messages);
        request.getRequestDispatcher("upload.jsp").forward(request, response);
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
