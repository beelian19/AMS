/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.ProjectDAO;
import DAO.TokenDAO;
import Entity.Excel;
import Entity.Project;
import Entity.Token;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Lin
 */
public class ProcessExcelFile extends HttpServlet {

    private String clientId;
    private String projectId;
    private Excel excel;
    private FileItem fileItem;
    private Workbook workbook;
    private String initialize;
    private Project project;

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
        if (!ServletFileUpload.isMultipartContent(request)) {
            throwError("Multipart file not uploaded", request, response);
        }

        try {
            // Retreive data from request
            List<FileItem> fileItems = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);

            if (fileItems == null) {
                throwError("Request parsed from InvoiceManagement is null", request, response);
            } else if (fileItems.size() != 3) {
                throwError("Wrong number of request parsed from InvoiceManagement. Expected: 3, Received: " + fileItems.size(), request, response);
            } else {
                fileItem = fileItems.get(0);
                clientId = fileItems.get(1).getString();
                if (clientId == null || clientId.trim().equals("")) {
                    throwError("No client id parsed from InvoiceManagement", request, response);
                }
                projectId = fileItems.get(2).getString();
                if (projectId == null || projectId.trim().equals("")) {
                    throwError("No project id parsed from InvoiceManagement", request, response);
                }
                // Set project Id into session
                request.getSession().setAttribute("invoiceProjectId", projectId);

            }

            // Get token from database
            Token token = TokenDAO.getToken(clientId);
            if (token == null) {
                throwError("Error in getting token from database for client id: " + clientId, request, response);
            } else if (token.getInUse()) {
                throwError("Token with client id " + clientId + " is already in use", request, response);
            }

            // Get project object
            project = ProjectDAO.getProjectByID(projectId);
            if (project == null) {
                throwError("Project id: " + projectId + " was not found in the database", request, response);
            }

            // Ensure that the file is an excel file
            if (!fileItem.getName().endsWith("xlsx")) {
                throwError("Only xlsx files supported for this operation", request, response);
            }
            try (InputStream inputStream = fileItem.getInputStream()) {
                workbook = new XSSFWorkbook(inputStream);
                request.getSession().setAttribute("fileName", fileItem.getName().replaceAll(".xlsx", ""));
                excel = new Excel(workbook);
                // Check for workbook's validity
                excel.setIsValid(inspectWorkbook(workbook));
                if (!excel.getIsValid()) {
                    throwError("Excel file uploaded is not AMS standard file: \n Row 3 Column L-N not formula (date)", request, response);
                }

                // If successfully initialised Excel Object, initialized != "Success"
                initialize = excel.initialize();
                // Return variable "initialize" if excel object is not successfully initialized
                if (!excel.getInitialized()) {
                    throwError("Failed to initialize excel file: \n" + initialize, request, response);
                } else {
                    // Set excel object and project id for the invoice into session
                    request.getSession().setAttribute("excel", excel);
                    RequestDispatcher rd = request.getRequestDispatcher("process-invoice.jsp");
                    rd.forward(request, response);
                }

            }

        } catch (FileUploadException ex) {
            throwError("File upload exception thrown! Please contact the system administrator", request, response);
        }
    }

    
    private boolean inspectWorkbook(Workbook workbook) {
        Sheet sheet = workbook.getSheetAt(0);
        Boolean b = false;
        if (sheet != null && sheet.getRow(2) != null) {
            try {
                b = (sheet.getRow(2).getCell(11).getCellTypeEnum()
                        == CellType.FORMULA);
            } catch (NullPointerException e) {
                System.out.println("Error at ProcessExcelServlet thrown: " + e.getMessage());
                b = false;
            } finally {
                return b;
            }
        } else {
            return false;
        }
    }
    
    /**
     * Throws an error message to InvoiceManagement.jsp
     *
     * @param msg
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void throwError(String msg, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("UploadExcelResponse", msg);
        RequestDispatcher rd = request.getRequestDispatcher("InvoiceManagement.jsp");
        rd.forward(request, response);
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
