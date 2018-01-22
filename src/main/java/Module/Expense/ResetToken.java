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
        if (request.getParameter("companyId") == null || request.getParameter("companyId").isEmpty()) {
            request.getSession().setAttribute("status", "Error: Missing client id");
            response.sendRedirect("TokenOverview.jsp");
            return;
        }
        
        String clientId = (String) request.getParameter("companyId");

        // Check if is for edit
        if (request.getParameter("edit") != null) {
            Token token = TokenDAO.getToken(clientId);
            if (token == null) {
                request.setAttribute("cliendId", "NA");
                request.setAttribute("clientSecret", "NA");
                request.setAttribute("redirectURI", "NA");
                request.setAttribute("taxEnabled", "NA");
                request.setAttribute("companyId", clientId);
            } else {
                request.setAttribute("clientId", token.getClientId());
                request.setAttribute("clientSecret", token.getClientSecret());
                request.setAttribute("redirectURI", token.getRedirectUri());
                request.setAttribute("taxEnabled", token.getTaxEnabled());
                request.setAttribute("companyId", clientId);
            }

            request.getRequestDispatcher("EditToken.jsp").forward(request, response);
            return;
        }

        // check if token exist for this client id
        Token token = TokenDAO.getToken(clientId);

        // check if token exist for the client
        if (token == null) {
            request.getSession().setAttribute("status", "Error: Company id " + clientId + " does not have a token. Please edit in a token for the company before resetting it.");
            response.sendRedirect("TokenOverview.jsp");
            // if token type is QBO
        } else if (token.getAccType().toUpperCase().equals("QBO")) {
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
                response.sendRedirect("TokenOverview.jsp");
            }
            // if token type is XERO
        } else if (token.getAccType().equals("XERO")) {
            /*
            request.getSession().setAttribute("tokenClientId", clientId);

            Config config = JsonConfig.getInstance();
            // set to clients data
            config.setAuthCallBackUrl(token.getRedirectUri());
            config.setConsumerKey(token.getClientId());
            config.setConsumerSecret(token.getClientSecret());

            OAuthRequestToken requestToken = new OAuthRequestToken(config);
            requestToken.execute();


            token.setXeroToken(requestToken.getTempToken());
            token.setXeroTokenSecret(requestToken.getTempTokenSecret());
            TokenDAO.updateToken(token);

            //Build the Authorization URL and redirect User
            OAuthAuthorizeToken authToken = new OAuthAuthorizeToken(config, requestToken.getTempToken());

            response.sendRedirect(authToken.getAuthUrl());
            */
            request.getSession().setAttribute("status", "Error: XERO not supported yet");
            response.sendRedirect("TokenOverview.jsp");
        } else {
            request.getSession().setAttribute("status", "Error: Token retreived has an unknown account type: " + token.getAccType());
            response.sendRedirect("TokenOverview.jsp");
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
