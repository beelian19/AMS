/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.ClientDAO;
import DAO.TokenDAO;
import Entity.Client;
import Entity.Token;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class EditTokenServlet extends HttpServlet {

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
        String status = "";
        try {
            String clientKey = request.getParameter("clientId");
            String clientSecret = request.getParameter("clientSecret");
            String redirectURI = request.getParameter("redirectURI");
            String companyId = request.getParameter("companyId");

            Client client = ClientDAO.getClientById(companyId);
            if (client == null) {
                throw new IllegalArgumentException(companyId);
            }
            Integer companyIdInt = Integer.parseInt(companyId);
            Token token = TokenDAO.getToken(companyId);
            if (token == null) {
                token = new Token("QBO", clientKey, clientSecret, redirectURI, "na", "0", companyIdInt);
                if (TokenDAO.createToken(token)) {
                    request.getSession().setAttribute("status", "Token created for " + client.getCompanyName());
                } else {
                    request.getSession().setAttribute("status", "Error: Create token for " + client.getCompanyName() + " failed");
                }
            } else {
                token.setClientId(clientKey);
                token.setClientSecret(clientSecret);
                token.setRedirectUri(redirectURI);
                token.setInUse("0");
                if (TokenDAO.updateToken(token)) {
                    request.getSession().setAttribute("status", "Token updated for " + client.getCompanyName());
                } else {
                    request.getSession().setAttribute("status", "Error: Update token for " + client.getCompanyName() + " failed");
                }
            }

            response.sendRedirect("TokenOverview.jsp");
            return;
        } catch (IllegalArgumentException iae) {
            status = "No company with id " + iae.getMessage();
        } catch (NullPointerException | IOException npe) {
            status = npe.getMessage();
        }

        request.getSession().setAttribute("status", "Error: " + status);
        response.sendRedirect("TokenOverview.jsp");
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
