/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ClientDAO;
import DAO.ProjectDAO;
import Entity.Client;
import Entity.Project;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Utility.ConnectionManager;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "CreateNewProject", urlPatterns = {"/CreateNewProject"})
public class CreateNewProject extends HttpServlet {

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
        try {

            /* TODO output your page here. You may use following sample code. */
            String title = request.getParameter("title");
            String companyName = request.getParameter("companyName");
            String remarks = request.getParameter("remarks");
            String projectType = request.getParameter("projectType");
            String recommendedInternalDeadline = request.getParameter("recommendedInternal");
            String internalDeadline = request.getParameter("internal");
            String recommendedExternalDeadline = request.getParameter("recommendedExternal");
            String externalDeadline = request.getParameter("external");
            String assignedEmployee1 = request.getParameter("emp1");
            String assignedEmployee2 = request.getParameter("emp2");
            String reviewer = request.getParameter("reviewer");
            double assignedHours = Double.parseDouble(request.getParameter("assignedHours"));
            String frequency = "";
            HttpSession session = request.getSession();
            
            if(recommendedInternalDeadline.equals("na") || recommendedExternalDeadline.equals("na")) {
                session.setAttribute("status", "Error: Incorrect project type selected.");
                return;
            }
            Client client = ClientDAO.getClientByCompanyName(companyName);
            switch(projectType) {
                case "tax" : 
                    frequency = "y";
                    break;
                case "eci" :
                    frequency = "y";
                    break;
                case "gst" :
                    frequency = client.getGstSubmission().substring(0, 1);
                    break;
                case "management" :
                    frequency = client.getMgmtAcc().substring(0, 1);
                    break;
                case "final" :
                    frequency = "y";
                    break;
                default://Secretarial
                    frequency = "y";
                    break;
            }
            Calendar cal4 = Calendar.getInstance();
            Project project = new Project();
            project.setProjectTitle(title);
            project.setCompanyName(companyName);
            project.setBusinessType(client.getBusinessType());
            project.setProjectRemarks(remarks);
            project.setProjectType(projectType);
            project.setProjectStatus("incomplete");
            project.setProjectReviewStatus("incomplete");
            project.setEmployee1(assignedEmployee1);
            project.setEmployee2(assignedEmployee2);
            project.setEmployee1Hours(0.0);
            project.setEmployee2Hours(0.0);
            project.setProjectReviewer(reviewer);
            project.setFrequency(frequency);
            project.setDateCompleted(cal4.getTime());
            project.setMonthlyHours(Project.getYearMonth()+"=0.0-0.0");
            project.setPlannedHours(assignedHours);

            //this is the method to get start date....minus 1 day logic
            if (internalDeadline.length() == 0) {
                if (externalDeadline.length() == 0) {
                    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    Date endDate = df.parse(recommendedInternalDeadline);
                    Date externalEndDate = df.parse(recommendedExternalDeadline);
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, -1);
                    Date startDate = cal.getTime();

                    project.setEnd(endDate);
                    project.setStart(startDate);
                    project.setActualDeadline(externalEndDate);
                } else {
                    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    Date endDate = df.parse(recommendedInternalDeadline);
                    Date externalEndDate = df.parse(externalDeadline);
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, -1);
                    Date startDate = cal.getTime();

                    project.setEnd(endDate);
                    project.setStart(startDate);
                    project.setActualDeadline(externalEndDate);
                }

            } else {
                if (externalDeadline.length() == 0) {
                    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    Date endDate = df.parse(internalDeadline);
                    Date externalEndDate = df.parse(recommendedExternalDeadline);
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, -1);
                    Date startDate = cal.getTime();

                    project.setEnd(endDate);
                    project.setStart(startDate);
                    project.setActualDeadline(externalEndDate);
                } else {
                    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                    Date endDate = df.parse(internalDeadline);
                    Date externalEndDate = df.parse(externalDeadline);
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(endDate);
                    cal.add(Calendar.DATE, -1);
                    Date startDate = cal.getTime();

                    project.setEnd(endDate);
                    project.setStart(startDate);
                    project.setActualDeadline(externalEndDate);
                }
            }
            boolean check = ProjectDAO.createProject(project);
            if (check) {
                session.setAttribute("status", "Success: Project "+title+" Created.");
            } else {
                session.setAttribute("status", "Error: Failed to create project "+title);
            }

        } catch (ParseException e) {
            System.out.println("CreateNewProject: Error- " + e.getMessage());
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

    public int getCounter() throws SQLException {

        Connection conn = ConnectionManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement("Select max(id) from project");
        ResultSet rs = stmt.executeQuery();
        rs.last();
        int temp = rs.getInt("max(id)");
        //Integer tempCount = Integer.parseInt(temp);
        int counter = temp + 1;

        return counter;
    }

    public int getProjectID(String companyName) throws SQLException {
        Connection conn = ConnectionManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement("Select max(projectID) from project where companyName = ?");
        stmt.setString(1, companyName);
        ResultSet rs = stmt.executeQuery();
        rs.last();
        int temp = rs.getInt("max(projectID)");
        //Integer tempCount = Integer.parseInt(temp);
        int counter = temp + 1;

        return counter;
    }
}
