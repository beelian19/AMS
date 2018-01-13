/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.TokenDAO;
import Entity.Token;
import com.intuit.oauth2.config.OAuth2Config;
import com.intuit.oauth2.config.Scope;
import com.intuit.oauth2.exception.InvalidRequestException;
import com.xero.api.Config;
import com.xero.api.JsonConfig;
import com.xero.api.OAuthAuthorizeToken;
import com.xero.api.OAuthRequestToken;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class ResetToken extends HttpServlet {

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
        // get clientId from request parameter
        if (request.getParameter("ClientId") == null || request.getParameter("ClientId").isEmpty()) {
            request.getSession().setAttribute("status", "Error: Missing client id");
            response.sendRedirect("viewAllTokens.jsp");
        }

        // check if token exist for this client id
        String clientId = (String) request.getParameter("ClientId");
        Token token = TokenDAO.getToken(clientId);

        // check if token exist for the client
        if (token == null) {
            request.getSession().setAttribute("status", "Error: Company id " + clientId + " does not have a token.");
            response.sendRedirect("viewAllTokens.jsp");
            // if token type is QBO
        } else if (token.getAccType().equals("QBO")) {
            List<Scope> scopes = new ArrayList<>();
            scopes.add(Scope.Accounting);
            QBOoauth2ClientFactory factory = new QBOoauth2ClientFactory(token);
            OAuth2Config oauth2Config = factory.getOAuth2Config();
            String redirectUri = factory.getRedirectUri();
            String csrf = oauth2Config.generateCSRFToken();
            try {
                request.getSession().setAttribute("tokenClientId", clientId);
                String url = oauth2Config.prepareUrl(scopes, redirectUri, csrf);
                response.sendRedirect(url);
            } catch (InvalidRequestException ex) {
                request.setAttribute("status", "Error: Failure at ResetToken: Invalid Request: " + ex.getErrorMessage());
                response.sendRedirect("viewAllTokens.jsp");
            }
            // if token type is XERO
        } else if (token.getAccType().equals("XERO")) {
            
            request.getSession().setAttribute("tokenClientId", clientId);
            
            Config config = JsonConfig.getInstance();
            // set to clients data
            config.setAuthCallBackUrl(token.getRedirectUri());
            config.setConsumerKey(token.getClientId());
            config.setConsumerSecret(token.getClientSecret());

            OAuthRequestToken requestToken = new OAuthRequestToken(config);
            requestToken.execute();
            
            /**
             *  TokenStorage storage = new TokenStorage();
             *  storage.save(response,requestToken.getAll());
             */
            token.setXeroToken(requestToken.getTempToken());
            token.setXeroTokenSecret(requestToken.getTempTokenSecret());
            TokenDAO.updateToken(token);

            //Build the Authorization URL and redirect User
            OAuthAuthorizeToken authToken = new OAuthAuthorizeToken(config, requestToken.getTempToken());

            response.sendRedirect(authToken.getAuthUrl());
        } else {
            request.getSession().setAttribute("status", "Error: Token retreived has an unknown account type: " + token.getAccType());
            response.sendRedirect("viewAllTokens.jsp");
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
