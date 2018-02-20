/**
 *
 * Returns a list of expenses that have been processed with a String status in each Object after execution
 * also returns a list of messages for run time status
 */
package Module.Expense;

import Entity.Payment;
import Entity.PaymentFactory;
import Entity.PaymentLine;
import Entity.Token;
import com.intuit.ipp.core.IEntity;
import com.intuit.ipp.data.Fault;
import com.intuit.ipp.data.OperationEnum;
import com.intuit.ipp.data.Purchase;
import com.intuit.ipp.exception.FMSException;
import com.intuit.ipp.services.BatchOperation;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
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

            if (pf.getPurchases() == null || pf.getDataService() == null) {
                throw new IllegalArgumentException("Purchases//Data Service not found");
            }
            List<Purchase> purchases = pf.getPurchases();
            List<Purchase> batchPurchases;
            // Init BatchOperations
            BatchOperation batchOperation;
            Map<String, Fault> faults = new HashMap<>();
            Map<String, IEntity> entities = new HashMap<>();
            int times = purchases.size() / 30;
            if (purchases.size() % 30 > 0) {
                times = times + 1;
            }
            // Add the purchase objects into BatchOperations
            int start = 0;
            int end = 30;
            for (int i = 1; i <= times; i++) {
                batchOperation = new BatchOperation();
                
                if (i == times) {
                    batchPurchases = purchases.subList(start, purchases.size());
                } else {
                    batchPurchases = purchases.subList(start, end);
                }
                
                for (Purchase p : batchPurchases) {
                    batchOperation.addEntity(p, OperationEnum.CREATE, p.getDocNumber());
                }
                
                pf.getDataService().executeBatch(batchOperation);
                // Add to map
                batchOperation.getFaultResult().forEach(faults::putIfAbsent);
                batchOperation.getEntityResult().forEach(entities::putIfAbsent);
                // Set next iteration 
                start = end;
                end = end + 30;
            }

            List<Payment> prePayments = pf.getPrePayments();
            List<Payment> resultPayments = new ArrayList<>();

            for (Payment pre : prePayments) {
                String ref = pre.getReferenceNumber();
                if (ref == null) {
                    pre.setStatus("error: not processed with no reference");
                } else if (faults.containsKey(ref)) {
                    String purError = "error: processed with fault: ";
                    Fault fault = faults.get(ref);
                    List<com.intuit.ipp.data.Error> errors = fault.getError();
                    for (com.intuit.ipp.data.Error e : errors) {
                        purError += "-" + e.getMessage() + "-";
                    }
                    pre.setStatus(purError);
                } else if (entities.containsKey(ref)) {
                    pre.setStatus("success");
                } else {
                    String notProcessedReason = "error: not processed ";
                    for (PaymentLine pl : pre.getLines()) {
                        notProcessedReason += pl.getInitStatus();
                    }
                    pre.setStatus(notProcessedReason);
                }
                resultPayments.add(pre);
            }

            pf.setPostPayments(resultPayments);
            request.getSession().setAttribute("pfResult", pf);
            /*
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            
            // Call QBO or XERO callable and redirect
            switch (token.getAccType().toLowerCase()) {
                // QBO
                case "qbo":
                    QBOCallable qboCallable = new QBOCallable(pf);
                    //request.getSession().removeAttribute("paymentFactory");
                    PaymentFactory pfR = executorService.submit(qboCallable).get();
                    request.getSession().setAttribute("pfResult", pfR);
                    break;
                // XERO
                case "xero":
                    /*
                    XEROCallable xeroCallable = new XEROCallable(pf);
                    Future<ExpenseFactory> xeroFuture = executorService.submit(xeroCallable);
                    request.getSession().setAttribute("expenseFuture", xeroFuture);
                    break;
                    
                    throw new IllegalArgumentException("XERO not supported yet");

                default:
                    throw new IllegalArgumentException("No account type of " + token.getAccType() + " found");
            }

             */
            // Set future into request session
            // Callable has been successfully created
            response.sendRedirect("ExpenseResult.jsp");
            return;

        } catch (NullPointerException npe) {
            npe.printStackTrace();
            messages.add("NullPointerException caught" + npe.getMessage());
        } catch (IllegalArgumentException iae) {
            messages.add("IllegalArgumentException caught" + iae.getMessage());
        } catch (IOException ioe) {
            messages.add("IOException caught" + ioe.getMessage());
        } catch (FMSException ex) {
            List<com.intuit.ipp.data.Error> erlist = ex.getErrorList();
            if (erlist != null && !erlist.isEmpty()) {
                messages.add("FMSException {");
                erlist.stream().forEach((er) -> {
                    messages.add(er.getMessage());
                });
                messages.add("}");
            }

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
