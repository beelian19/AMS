/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ProjectDAO;
import Entity.Project;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Utility.ConnectionManager;
import java.util.Calendar;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "CreateAdHocProjectAdmin", urlPatterns = {"/CreateAdHocProjectAdmin"})
public class CreateAdHocProjectAdmin extends HttpServlet {

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
        try (Connection conn = ConnectionManager.getConnection()) {
            /* TODO output your page here. You may use following sample code. */

            //common fields in task and adhoc project
            String companyName = request.getParameter("companyProjectCreate");
            String title = request.getParameter("titleProjectCreate");
            String start = request.getParameter("startDateProjectCreate");
            String end = request.getParameter("endDateProjectCreate");
            String remarks = request.getParameter("remarkProjectCreate");
            String reviewer = request.getParameter("reviewerProjectCreate");
            //common fields in task and adhoc project

            //convert String to date
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = df.parse(start);
            Date endDate = df.parse(end);

            String assignedEmployee1 = request.getParameter("assignEmployeeProjectCreate");
            String assignedEmployee2 = request.getParameter("assignEmployee1ProjectCreate");
            
            Calendar cal4 = Calendar.getInstance();

            ProjectDAO projectDAO = new ProjectDAO();
            int projectId = projectDAO.getTotalNumberOfProjects() + 1;
            Project addProject = new Project(projectId, title, companyName, "NA", startDate, endDate, remarks, "incomplete", endDate, "NA", "adhoc", assignedEmployee1, assignedEmployee2, 0.0, 0.0, reviewer, "incomplete",cal4.getTime(), "NA", 0.0);
            boolean check = ProjectDAO.createProject(addProject);
            if (check) {
                request.getSession().setAttribute("status", "Success: AdHoc Project " + title + " Created.");
//                request.setAttribute("projectID", projectId);
//                RequestDispatcher rd = request.getRequestDispatcher("ClientOverview.jsp");
//                rd.forward(request, response);
                response.sendRedirect("ClientOverview.jsp");
            } else {
                request.getSession().setAttribute("status", "Error: Failed to create adhoc project " + title);
                response.sendRedirect("CreateAdHocProject.jsp");
            }

            //response.sendRedirect("ProjectView.jsp");
        } catch (SQLException | ParseException e) {
            e.printStackTrace();
        }
    }

//    public int getCounter(int projectID) throws SQLException {
//
//        Connection conn = ConnectionManager.getConnection();
//        PreparedStatement stmt = conn.prepareStatement("Select max(taskID) from task where projectID = ?");
//        stmt.setInt(1, projectID);
//        ResultSet rs = stmt.executeQuery();
//        rs.last();
//        int temp = rs.getInt("max(taskID)");
//        //Integer tempCount = Integer.parseInt(temp);
//        int counter = temp + 1;
//
//        return counter;
//    }
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
