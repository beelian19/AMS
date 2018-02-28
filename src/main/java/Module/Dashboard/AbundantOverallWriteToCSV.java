/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import Entity.Project;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import static java.lang.String.format;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

/**
 *
 * @author yemin
 */
public class AbundantOverallWriteToCSV extends HttpServlet {

    private static final String PROPS_FILENAME = "connection.properties";
    private static String eUser;
    private static String ePass;

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
        ArrayList<Project> projectsList = (ArrayList<Project>) request.getSession().getAttribute("projectData");
        String year = (String) request.getSession().getAttribute("yearAbundant");
        
        Workbook xlsFile = new HSSFWorkbook();
        CreationHelper helper = xlsFile.getCreationHelper();
        Sheet sheet1 = xlsFile.createSheet("Data");

        for (int i = 0; i < projectsList.size(); i++) {
            Row row = sheet1.createRow(i);
            Project p = projectsList.get(i);
            double sales = ProjectDAO.getSales(p);
            double cost = ProjectDAO.getTotalActualCost(p);
            double profit = ProjectDAO.getProfit(p);
            String employees = "";
            if (!p.getEmployee2().toLowerCase().equals("na")) {
                employees = p.getEmployee1() + " and " + p.getEmployee2();
            } else {
                employees = p.getEmployee1();
            }

            row.createCell(0).setCellValue(p.getDateCompleted().toString());
            row.createCell(1).setCellValue(p.getCompanyName());
            row.createCell(2).setCellValue(p.getProjectTitle());
            row.createCell(3).setCellValue(p.getPlannedHours());
            row.createCell(4).setCellValue(p.getEmployee1Hours() + p.getEmployee2Hours());
            row.createCell(5).setCellValue(((p.getEmployee1Hours() + p.getEmployee2Hours() - p.getPlannedHours()) / (p.getEmployee1Hours() + p.getEmployee2Hours()) * 100.00));
            row.createCell(6).setCellValue(sales);
            row.createCell(7).setCellValue(cost);
            row.createCell(8).setCellValue(profit);
            row.createCell(9).setCellValue(employees);
        }


        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        xlsFile.write(bos);


        DataSource fds = new ByteArrayDataSource(bos.toByteArray(), "application/vnd.ms-excel");

        InputStream is = null;
        Properties props = new Properties();
        is = AbundantOverallWriteToCSV.class.getResourceAsStream("/" + PROPS_FILENAME);
        if (is == null) {
            throw new IllegalArgumentException(format("Could not load '%s'. Missing File?", PROPS_FILENAME));
        }

        // Load email to send to
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
            MimeMessage message = new MimeMessage(session1);
            String to = "abundantms2017@gmail.com";
            String msg = "Projects: \n";
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject("Project data from AMS");
            Calendar c = Calendar.getInstance();
            String time = c.getTime().toString();
            
            MimeBodyPart mbp1 = new MimeBodyPart();
            mbp1.setText(time);
            
            MimeBodyPart mbp2 = new MimeBodyPart();
            mbp2.setDataHandler(new DataHandler(fds));
            mbp2.setFileName("AbundantProjectDataFor"+year+".xls");
            
            
            Multipart mp = new MimeMultipart();
            mp.addBodyPart(mbp1);
            mp.addBodyPart(mbp2);
            message.setContent(mp);
            message.saveChanges();
            
            message.setSentDate(new java.util.Date());
            Transport.send(message);

        } catch (MessagingException mex) {
            System.out.println(mex.getMessage());
        } finally {
            try {
                is.close();
            } catch (IOException ex) {
                System.out.println("IO exception");
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
