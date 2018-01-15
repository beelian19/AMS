/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.ClientDAO;
import DAO.TokenDAO;
import Entity.Token;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class CreateToken extends HttpServlet {

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
        String message = "";
        boolean success = false;
        try {
            String ClientId = (String) request.getParameter("ClientId");
            String ClientSecret = (String) request.getParameter("ClientSecret");
            String redirectUri = (String) request.getParameter("redirectUri");
            Integer companyId = Integer.valueOf(request.getParameter("companyId"));
            Token token = new Token("QBO", ClientId, ClientSecret, redirectUri, "NA", "0", companyId);
            success = TokenDAO.createToken(token);
            message = ClientDAO.getClientById(""+companyId).getCompanyName();
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            if (success) {
                System.out.println("successful");
                request.getSession().setAttribute("status", "Token created. Please reset the token for " + message);
                response.sendRedirect("TokenOverview.jsp");
            } else {
                request.getSession().setAttribute("status", "Error: Failed to create token " + message);
                response.sendRedirect("TokenOverview.jsp");
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
