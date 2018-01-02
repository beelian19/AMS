/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import DAO.EmployeeDAO;
import DAO.ProjectDAO;
import Entity.Employee;
import Entity.Project;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lin
 */
public class UpdateProjectHours extends HttpServlet {

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
        //System.out.println("TEST" + request.getParameter("projectIden"));
        Employee e = EmployeeDAO.getEmployeeByID((String) request.getSession().getAttribute("userId"));
        String name = e.getName();
        String pID;
        Project p;
        Double emp1;
        Double emp2;
        if (request.getParameter("projectIden") != null) {
            pID = (String) request.getParameter("projectIden");
            p = ProjectDAO.getProjectByID(pID);
            if (request.getParameter("employee1Hours").equals("")) {
                emp1 = 0.0;
            } else {
                emp1 = Double.parseDouble(request.getParameter("employee1Hours"));
            }
            if (request.getParameter("employee2Hours") == null || request.getParameter("employee2Hours").equals("") ) {
                emp2 = 0.0;
            } else {
                emp2 = Double.parseDouble(request.getParameter("employee2Hours"));
            }
            
            if (p.getEmployee1().equals(name)) {
                p.setEmployee1Hours(emp1);
            } else if (p.getEmployee2().equals(name)) {
                p.setEmployee2Hours(emp2);
            } else if (e.getIsAdmin().equals("yes")) {
                p.setEmployee1Hours(emp1);
                p.setEmployee2Hours(emp2);
            }

            if (ProjectDAO.updateProject(p)) {
                request.getSession().setAttribute("status", "Success: Hours successfully updated!");
                String url = "ProjectProfile.jsp?projectID=" + p.getProjectID();
                response.sendRedirect(url);
            } else {
                request.getSession().setAttribute("status", "Error: Hours failed to update!");
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
