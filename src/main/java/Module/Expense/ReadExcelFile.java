package Module.Expense;

import DAO.ClientDAO;
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
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> messages = new ArrayList<>();
        if (!ServletFileUpload.isMultipartContent(request)) {
            messages.add("Request parameter not multipart");
        } else {
            try {
                List<FileItem> fileItems = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);

                // Ensure that fileItems is not null
                if (fileItems == null) {
                    throw new IllegalArgumentException("No file uploaded");
                } else if (fileItems.size() != 1) {
                    throw new IllegalArgumentException("Multiple file uploaded");
                }

                // Get the excel file
                FileItem excelFileItem = fileItems.get(0);
                if (!excelFileItem.getName().endsWith("xlsx")) {
                    throw new IllegalArgumentException("Only xlsx file type is accepted");
                }

                try (InputStream excelStream = excelFileItem.getInputStream()) {
                    Workbook excelWorkbook = new XSSFWorkbook(excelStream);

                    // Initialize ExpenseFactory object
                    ExpenseFactory ef = new ExpenseFactory(excelWorkbook);

                    // Ensure that data is correctly initialized
                    if (!ef.init()) {
                        throw new IllegalArgumentException("Excel file was not initialized correctly");
                    }

                    // Ensure that a client exist with the UEN number
                    if (!ClientDAO.clientExist(ef.getUEN().trim())) {
                        throw new IllegalArgumentException("No client in database with UEN: " + ef.getUEN());
                    }

                    request.getSession().setAttribute("ExpenseFactory", ef);
                    request.setAttribute("messages", messages);
                    request.getRequestDispatcher("process-invoice.jsp").forward(request, response);

                }

            } catch (FileUploadException fue) {
                messages.add("FileUploadException found: " + fue.getMessage());
            } catch (IllegalArgumentException iae) {
                messages.add("IllegalArgumentException: " + iae.getMessage());
            } catch (RuntimeException re) {
                messages.add("RuntimeException found: " + re.getMessage());
            }
            
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("upload.jsp").forward(request, response);
            
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

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
        processRequest(request, response);
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
