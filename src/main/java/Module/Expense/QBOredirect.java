/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.TokenDAO;
import Entity.Token;
import com.intuit.oauth2.client.OAuth2PlatformClient;
import com.intuit.oauth2.data.BearerTokenResponse;
import com.intuit.oauth2.exception.OAuthException;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class QBOredirect extends HttpServlet {

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
        String auth_code = "";
        String realmId;
        String access_token;
        String refresh_token;
        Boolean updateSuccess;
        // Ensure that redirect is valid
        if (request.getParameterMap().containsKey("code")
                && request.getParameterMap().containsKey("realmId")) {
            auth_code = request.getParameter("code");
            realmId = request.getParameter("realmId");
        } else {
            request.getSession().setAttribute("status", "Error: Invalid redirect at QBOredirect");
            response.sendRedirect("TokenOverview.jsp");
            return;
        }

        // Get the client's token
        if (request.getSession().getAttribute("tokenClientId") == null) {
            request.getSession().setAttribute("status", "Error: No Client id found at QBOredirect");
            response.sendRedirect("TokenOverview.jsp");
            return;
        }
        String clientId = (String) request.getSession().getAttribute("tokenClientId");
        request.getSession().removeAttribute("tokenClientId");
        Token token = TokenDAO.getToken(clientId);

        if (token == null) {
            request.getSession().setAttribute("status", "Error: No token for company id " + clientId + " found in the DB");
            response.sendRedirect("TokenOverview.jsp");
            return;
        }

        QBOoauth2ClientFactory factory = new QBOoauth2ClientFactory(token);
        OAuth2PlatformClient client = factory.getOAuth2PlatformClient();
        String redirectUri = factory.getRedirectUri();

        try {
            BearerTokenResponse bearerTokenResponse = client.retrieveBearerTokens(auth_code, redirectUri);
            access_token = bearerTokenResponse.getAccessToken();
            refresh_token = bearerTokenResponse.getRefreshToken();
            if (refresh_token == null) {
                refresh_token = "NA";
            }
            token.setRefreshToken(refresh_token);
            updateSuccess = TokenDAO.updateToken(token);
            if (updateSuccess) {
                request.getSession().setAttribute("status", "Updated token for client id: " + clientId);
                response.sendRedirect("TokenOverview.jsp");
                return;
            }
            request.getSession().setAttribute("status", "Token update failed. SQL update query failure.");
        } catch (OAuthException | NullPointerException ex) {
            request.getSession().setAttribute("stats", "Error: " + ex.getMessage());
        }
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
