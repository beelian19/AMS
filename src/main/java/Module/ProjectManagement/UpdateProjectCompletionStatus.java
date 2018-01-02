/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

/**
 *
 * @author yemin
 */

import DAO.EmployeeDAO;
import DAO.ProjectDAO;
import Entity.Employee;
import Entity.Project;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class UpdateProjectCompletionStatus extends HttpServlet {

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
        Employee e = EmployeeDAO.getEmployeeByID((String) request.getSession().getAttribute("userId"));
        String name = e.getName();
        Boolean isAssignedEmp = false;
        Boolean isAssignedRev = false;
        if (e.getIsAdmin().equals("yes")) {
            isAssignedEmp = true;
            isAssignedRev = true;
        }
        String pID;
        Project p;
        if (request.getParameter("projectIden") != null) {
            pID = (String) request.getParameter("projectIden");
            p = ProjectDAO.getProjectByID(pID);

            if (p.getEmployee1().equals(name) || p.getEmployee2().equals(name)) {
                isAssignedEmp = true;
            }
            if (p.getProjectReviewer().equals(name)) {
                isAssignedRev = true;
            }

            if (request.getParameter("review") != null && isAssignedRev
                    && p.getProjectReviewStatus().equals("incomplete")) {
                p.setProjectReviewStatus("complete");
                //call method to do recurring 
                ProjectDAO.performRecur(pID);
                
            } else if (request.getParameter("complete") != null && isAssignedEmp
                    && p.getProjectStatus().equals("incomplete")) {
                p.setProjectStatus("complete");
            } else {
                request.getSession().setAttribute("status", "Error: No change to project statuses");
                String url = "ProjectProfile.jsp?projectID=" + p.getProjectID();
                response.sendRedirect(url);
            }

            if (ProjectDAO.updateProject(p)) {
                request.getSession().setAttribute("status", "Success: Status successfully updated!");
                String url = "ProjectProfile.jsp?projectID=" + p.getProjectID();
                response.sendRedirect(url);
            } else {
                request.getSession().setAttribute("status", "Error: Status failed to update!");
                String url = "ProjectProfile.jsp?projectID=" + p.getProjectID();
                response.sendRedirect(url);
            }
        } else {
            request.getSession().setAttribute("status", "Error: No projectID parsed at update project servlet");
            response.sendRedirect("EmployeeProfile.jsp");
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
