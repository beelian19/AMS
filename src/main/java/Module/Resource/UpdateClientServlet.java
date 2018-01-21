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
@WebServlet(name = "UpdateClientServlet", urlPatterns = {"/UpdateClientServlet"})
public class UpdateClientServlet extends HttpServlet {

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
            
            //String clientId = request.getParameter("clientId");
            //String businessType = request.getParameter("businessType");
           // String companyName = request.getParameter("companyName");
           // String incorporation = request.getParameter("incorporation");
            String UenNumber = request.getParameter("uen");
            String officeContact = request.getParameter("officeContact");
            String emailAddress = request.getParameter("contactEmailAddress");
            String officeAddress = request.getParameter("officeAddress");
           // String financialYearEnd = request.getParameter("financialYearEnd");
            String gstSubmission = request.getParameter("gstSubmission");
            String director = request.getParameter("director");
            String secretary = request.getParameter("secretary");
            String accountant = request.getParameter("accountant");
            String realMid = request.getParameter("realmid");
            String mgmtFrequency = request.getParameter("mgmtFrequency");
            String mgmtNumber = request.getParameter("mgmtNumber");
            
            String mgmtAcc = mgmtFrequency + mgmtNumber;
          
            ClientDAO clientDAO = new ClientDAO();

            boolean status = clientDAO.updateClientProfile(UenNumber, officeContact,emailAddress, director, secretary,accountant,realMid,officeAddress,gstSubmission,mgmtAcc);
            if (status) {
                System.out.println("Successful");
                request.setAttribute("updateClientStatus", "Successful");
                RequestDispatcher rd = request.getRequestDispatcher("ClientProfile.jsp");
                rd.forward(request,response);
            } else {
                System.out.println("Unsuccessful");
                request.setAttribute("updateClientStatus", "Unsuccessful");
                RequestDispatcher rd2 = request.getRequestDispatcher("ClientProfile.jsp");
                rd2.forward(request,response);
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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