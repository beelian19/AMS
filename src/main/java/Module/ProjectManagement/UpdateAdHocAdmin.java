/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ProjectDAO;
import DAO.TaskDAO;
import Entity.Task;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "UpdateAdHocAdmin", urlPatterns = {"/UpdateAdHocAdmin"})
public class UpdateAdHocAdmin extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String projectID = request.getParameter("projectID");
            String taskID = request.getParameter("taskID");
            String uniqueTaskID = request.getParameter("uniqueTaskID");
            String title = request.getParameter("title");
            String start = request.getParameter("start");
            String end = request.getParameter("end");
            String assignEmployee = request.getParameter("assignEmployee");
            String assignEmployee1 = request.getParameter("assignEmployee1");
            String remarks = request.getParameter("remarks");
            String taskStatus = request.getParameter("taskStatus");
            String reviewer = request.getParameter("reviewer");
            String reviewStatus = request.getParameter("reviewStatus");
            String companyName = request.getParameter("companyName");
            
            DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
            Date startDate = df.parse(start);
            //System.out.println("Start: "+startDate);
            Date endDate = df.parse(end);
            
            if (taskID.equals("NA")) {
                //System.out.println("Check: "+taskID);
                boolean check = ProjectDAO.updateAdHocProject(Integer.parseInt(projectID), title, companyName, startDate, endDate, remarks, assignEmployee, assignEmployee1, reviewer);
                //System.out.println("UpdateTaskOrAdhoc Check Ad Hoc Project: "+check);
            } else {
                TaskDAO taskDAO = new TaskDAO();
                Task task = new Task(Integer.parseInt(projectID), Integer.parseInt(taskID), title, startDate, endDate, remarks, taskStatus, Integer.parseInt(uniqueTaskID), reviewer, reviewStatus);
                boolean check = taskDAO.updateTask(task);
                //System.out.println("UpdateTaskOrAdhoc Check Task: "+check);
            }
        } catch (ParseException e) {
            System.out.println("UpdateTaskOrAdhoc: You screwed up. Go check now." + e.getMessage());
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
