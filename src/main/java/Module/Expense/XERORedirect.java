/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import DAO.TokenDAO;
import Entity.Payment;
import Entity.PaymentFactory;
import Entity.SampleData;
import Entity.Token;
//import com.xero.api.Config;
//import com.xero.api.JsonConfig;
//import com.xero.api.OAuthAccessToken;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class XERORedirect extends HttpServlet {

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
        PaymentFactory pf = (PaymentFactory) request.getSession().getAttribute("paymentFactory");
        
        List<Payment> pre = pf.getPrePayments();

        System.out.println("Printing Pre Payments");
        pre.stream().forEach((p) -> {
            System.out.println(p.toString());
            System.out.println("Payment success: " + p.checkPayment());
            p.getLines().forEach(
                    (li) -> {
                        System.out.println("Line: " + li.toString());
                        System.out.println("Payment Status: " + li.getInitStatus());
                        System.out.println("PaymentLine success: " + li.checkPaymentLine());
                    }
            );
        });
        
        request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
    }
    
    protected void processRequest2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the client's token
        String clientId = (String) request.getSession().getAttribute("tokenClientId");
        request.getSession().removeAttribute("tokenClientId");
        Token token = TokenDAO.getToken(clientId);

        if (token == null) {
            request.setAttribute("status", "No client id " + clientId + " found in the DB");
            RequestDispatcher rd = request.getRequestDispatcher("ResetToken.jsp");
            rd.forward(request, response);
        }
        /*
        String verifier = request.getParameter("oauth_verifier");
        Config config = JsonConfig.getInstance();
        config.setAuthCallBackUrl(token.getRedirectUri());
        config.setConsumerKey(token.getClientId());
        config.setConsumerSecret(token.getClientSecret());
        OAuthAccessToken accessToken = new OAuthAccessToken(config);
        accessToken.build(verifier, token.getXeroToken(), token.getXeroTokenSecret()).execute();
        */
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
