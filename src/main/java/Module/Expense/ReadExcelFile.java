package Module.Expense;

import DAO.ClientDAO;
import DAO.TokenDAO;
import Entity.Client;
import Entity.PaymentFactory;
import Entity.Token;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author icon
 */
public class ReadExcelFile extends HttpServlet {

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
        List<String> servletMessages = new ArrayList<>();
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                List<FileItem> fileItems = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                if (fileItems == null) {
                    throw new IllegalArgumentException("No file uploaded");
                } else if (fileItems.size() != 1) {
                    throw new IllegalArgumentException("Invalid parameters. Request file item count > 1");
                }

                // Get the excel file
                FileItem excelFileItem = fileItems.get(0);
                if (!excelFileItem.getName().endsWith("xlsx")) {
                    throw new IllegalArgumentException("Only xlsx file type is accepted. " + excelFileItem.getName() + " uploaded");
                }

                try (InputStream excelStream = excelFileItem.getInputStream()) {
                    Workbook excelWorkbook = new XSSFWorkbook(excelStream);

                    // Initialize Paymont Factory 
                    PaymentFactory pf = new PaymentFactory(excelWorkbook);

                    // Ensure that data is correctly initialized
                    if (!pf.init()) {
                        List<String> initMessages = pf.getInitMessages();
                        servletMessages.addAll(initMessages);
                        throw new IllegalArgumentException("Excel file was not initialized correctly");
                    }

                    // Get client associated with the UEN number
                    Client client = ClientDAO.getClientByUEN(pf.getUEN().trim());

                    if (client == null) {
                        throw new IllegalArgumentException("No client in database with UEN: " + pf.getUEN());
                    } else if (client.getRealmid() != null && client.getRealmid().length() >= 5) {
                        pf.setRealmid(client.getRealmid().trim());
                    } else {
                        throw new IllegalArgumentException("Invalid realmid: " + client.getRealmid() + ". Please update for " + client.getCompanyName());
                    }

                    // Get token associated with the client id
                    Token token = TokenDAO.getToken(client.getClientID());
                    if (token == null) {
                        throw new IllegalArgumentException("No token in database with company id " + client.getClientID() + ". Please edit accordingly for " + client.getCompanyName());
                    } else if (token.isComplete()) {
                        pf.setToken(token);
                    } else {
                        throw new IllegalArgumentException("Invalid " + token.toString());
                    }

                    // Convert Payment into respective accounting objects
                    switch (token.getAccType().toLowerCase()) {
                        // QBO
                        case "qbo":
                            QBOCallable qboCallable = new QBOCallable(pf);
                            //request.getSession().removeAttribute("paymentFactory");
                            //PaymentFactory pfR = executorService.submit(qboCallable).get();
                            //request.getSession().setAttribute("pfResult", pfR);
                            break;
                        case "xero":
                            throw new IllegalArgumentException("XERO not supported yet");
                        default:
                            throw new IllegalArgumentException("No account type of " + token.getAccType() + " found. QBO or XERO expected.");
                    }

                    request.getSession().setAttribute("paymentFactory", pf);
                    request.getSession().setAttribute("paymentClient", client);
                    response.sendRedirect("ProcessExpense.jsp");
                    return;
                    //request.getRequestDispatcher("XERORedirect").forward(request, response);
                }

            } catch (FileUploadException fue) {
                servletMessages.add("FileUploadException: " + fue.getMessage());
            } catch (IllegalArgumentException iae) {
                servletMessages.add("IllegalArgumentException: " + iae.getMessage());
            } catch (RuntimeException re) {
                servletMessages.add("RuntimeException found: " + re.getMessage());
            }
        } else {
            servletMessages.add("Request parameter is not multipart");
        }
        request.setAttribute("messages", servletMessages);
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
