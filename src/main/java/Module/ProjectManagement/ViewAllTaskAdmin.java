/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.TaskDAO;
import Entity.Task;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
public class ViewAllTaskAdmin extends HttpServlet {

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
        Calendar deadline;
        
        ArrayList<Task> overallTaskList = TaskDAO.viewAllTask(); 
        
        ArrayList<Task> incomTaskList = new ArrayList<>();
        ArrayList<Task> overdueTaskList = new ArrayList<>();
        ArrayList<Task> completeTaskList = new ArrayList<>();
        for (Task t : overallTaskList) {
            deadline = Calendar.getInstance();
            deadline.setTime(t.getEnd());
            if(t.getReviewStatus().equals("complete")){
                completeTaskList.add(t);
            } else if(Calendar.getInstance().before(deadline)) {
                incomTaskList.add(t);
            } else {
                overdueTaskList.add(t);
            }
        }
        

        request.setAttribute("overdueTask", overdueTaskList);
        request.setAttribute("incompleteTask", incomTaskList);
        request.setAttribute("completedTask", completeTaskList);
        RequestDispatcher rd = request.getRequestDispatcher("TaskAdminOverview.jsp");
        rd.forward(request, response);
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
