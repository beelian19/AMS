/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.ClientDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "AddClientServlet", urlPatterns = {"/AddClientServlet"})
public class AddClientServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            

            String businessType = request.getParameter("businessType");
            String companyName = request.getParameter("companyName");
            String incorporation = request.getParameter("incorporationDate");
            String UenNumber = request.getParameter("UenNumber");
            String officeContact = request.getParameter("officeContact");
            String emailAddress = request.getParameter("emailAddress");
            String officeAddress = request.getParameter("officeAddress");
            String financialYearEnd = request.getParameter("financialYearEnd");
            String gst = request.getParameter("gstSubmission");
            String director = request.getParameter("director");
            String mgmtAcc = request.getParameter("mgmtAcc");
            
            String secretary = request.getParameter("secretaryName");
            String directorEmail = request.getParameter("secretaryEmail");
            String directorNumber = request.getParameter("secretaryNumber");
            String directorFinal = director + "," + directorEmail + "," + directorNumber; 
            
            //need to take in multiple fields and string together
            String accountant = request.getParameter("accountantName");
            String accountantEmail = request.getParameter("accountantEmail");
            String accountantNumber = request.getParameter("accountantNumber");
            String accountantFinal = accountant + "," + accountantEmail + "," + accountantNumber;
          

            ClientDAO clientDAO = new ClientDAO();
            boolean added = clientDAO.addNewClient(businessType, companyName, incorporation, UenNumber, officeContact, emailAddress, officeAddress, financialYearEnd, gst, directorFinal,secretary,accountantFinal,mgmtAcc);

            if (added) {
                request.setAttribute("createClientStatus", "Success");
                RequestDispatcher rd = request.getRequestDispatcher("ClientOverview.jsp");
                rd.forward(request, response);
                //response.sendRedirect("ViewAllClient.jsp");
                
            } else {
                request.setAttribute("createClientStatus", "Unsuccessful");
                RequestDispatcher rd = request.getRequestDispatcher("CreateClient.jsp");
                rd.forward(request, response);
                //response.sendRedirect("ViewAllClient.jsp");
            }

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
