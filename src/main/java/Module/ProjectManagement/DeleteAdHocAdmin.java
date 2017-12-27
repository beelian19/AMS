/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ProjectDAO;
import DAO.TaskDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "DeleteAdHocAdmin", urlPatterns = {"/DeleteAdHocAdmin"})
public class DeleteAdHocAdmin extends HttpServlet {

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
      
            /* TODO output your page here. You may use following sample code. */
            String projectID = request.getParameter("projectID");
            String taskID = request.getParameter("taskID");
                
            System.out.println("Task ID: "+taskID);
            if(taskID.equals("NA")) {
                ProjectDAO projectDAO = new ProjectDAO();
                boolean check = projectDAO.deleteProject(projectID);
                System.out.println("DeleteTaskOrAdhoc Ad hoc Project Check: "+check);
            } else {
                TaskDAO taskDAO = new TaskDAO();
                boolean check = taskDAO.deleteTask(Integer.parseInt(projectID), Integer.parseInt(taskID));
                System.out.println("DeleteTaskOrAdhoc Task Check: "+check);
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
