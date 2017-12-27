/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ProjectDAO;
import DAO.TaskDAO;
import Entity.Project;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

/**
 *
 * @author yemin
 */
@WebServlet(name = "CreateTaskAdmin", urlPatterns = {"/CreateTaskAdmin"})
public class CreateTaskAdmin extends HttpServlet {

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
            String companyName = request.getParameter("companyName");
            String title = request.getParameter("title");
            String start = request.getParameter("start");
            String end = request.getParameter("end");
            String remarks = request.getParameter("remarks");
            String reviewer = request.getParameter("reviewer");

            //convert String to date
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = df.parse(start);
            Date endDate = df.parse(end);

            //convert String to date
            String project = request.getParameter("project");
            Project thisProject = ProjectDAO.getProjectByTitleAndCompanyName(project, companyName);
            int projectID = thisProject.getProjectID();
            TaskDAO taskDAO = new TaskDAO();
            taskDAO.addTask(projectID, (getCounter(projectID)), title, startDate, endDate, remarks, reviewer);
        } catch (SQLException | ParseException e) {
            e.printStackTrace();
        }
    }

    public int getCounter(int projectID) throws SQLException {

        Connection conn = ConnectionManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement("Select max(taskID) from task where projectID = ?");
        stmt.setInt(1, projectID);
        ResultSet rs = stmt.executeQuery();
        rs.last();
        int temp = rs.getInt("max(taskID)");
        //Integer tempCount = Integer.parseInt(temp);
        int counter = temp + 1;

        return counter;
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
