/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;

import Entity.Client;
import Entity.Payment;
import Entity.PaymentFactory;
import Entity.SampleData;
import java.io.IOException;
import java.io.InputStream;
import static java.lang.String.format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class saveResultsServlet extends HttpServlet {

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
        final String PROPS_FILENAME = "connection.properties";
        String eUser;
        String ePass;
        PaymentFactory pf = (request.getSession().getAttribute("paymentFactory") != null) ? (PaymentFactory) request.getSession().getAttribute("pfResult") : null;

        Client client = (request.getSession().getAttribute("paymentClient") != null) ? (Client) request.getSession().getAttribute("paymentClient") : null;

        List<Payment> post;
        String timeStamp = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        if (pf == null || client == null) {
            request.getSession().setAttribute("status", "Error: No data found");
            response.sendRedirect("UploadExpense.jsp");
            return;
        } else {
            try {
                post = pf.getPostPayments();
                if (post != null && !post.isEmpty()) {
                    InputStream is = null;
                    Properties props = new Properties();
                    is = saveResultsServlet.class.getResourceAsStream("/" + PROPS_FILENAME);
                    if (is == null) {
                        throw new IllegalArgumentException(format("Could not load '%s'. Missing File?", PROPS_FILENAME));
                    }
                    String fileName = pf.getExcelClientName() + timeStamp;
                    try {
                        props.load(is);
                        eUser = props.getProperty("email.user");
                        ePass = props.getProperty("email.password");
                        final String from = eUser;
                        final String pass = ePass;
                        if (eUser == null || ePass == null) {
                            throw new IllegalArgumentException(format("Could not load '%s'. Missing File?", PROPS_FILENAME));
                        }
                        Properties m_properties = new Properties();
                        m_properties.put("mail.transport.protocol", "smtp");
                        m_properties.put("mail.smtp.host", "smtp.gmail.com");
                        m_properties.put("mail.smtp.port", "25");
                        m_properties.put("mail.smtp.auth", "true");
                        m_properties.put("mail.smtp.starttls.enable", "true");
                        Authenticator authenticator;
                        authenticator = new Authenticator() {
                            @Override
                            protected PasswordAuthentication getPasswordAuthentication() {
                                return new PasswordAuthentication(from, pass);
                            }
                        };
                        Session session1 = Session.getDefaultInstance(m_properties, authenticator);
                        //String to = "pm@abaccounting.com.sg";
                        String to = "minoo.ye.2015@sis.smu.edu.sg";
                        MimeMessage message = new MimeMessage(session1);
                        message.setFrom(new InternetAddress(from));
                        message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                        message.setSubject("Results for " + client.getCompanyName() + ": " + fileName);
                        String msg = "Reference Number : Status \n";

                        for (Payment p : post) {
                            String temp = p.getReferenceNumber() + " : " + p.getStatus() + "\n";
                            msg += temp;
                        }
                        message.setText(msg);
                        Transport.send(message);
                        request.getSession().setAttribute("status", "Success: Results sent");
                    } catch (MessagingException ex) {
                        request.getSession().setAttribute("status", "Error: MessagingException " + ex.getMessage());
                    } finally {
                        if (request.getSession().getAttribute("expenseFuture") != null) {
                            request.getSession().removeAttribute("expenseFuture");
                        }
                        if (request.getSession().getAttribute("paymentClient") != null) {
                            request.getSession().removeAttribute("expenseFuture");
                        }
                        response.sendRedirect("UploadExpense.jsp");
                    }
                }
            } catch (IllegalArgumentException ex) {
                request.getSession().setAttribute("status", "Error: Critical error " + ex.getMessage());
                response.sendRedirect("UploadExpense.jsp");
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
