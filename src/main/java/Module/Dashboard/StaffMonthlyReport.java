/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;


import DAO.ProjectDAO;
import Entity.Employee;
import Entity.Project;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
public class StaffMonthlyReport extends HttpServlet {

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
        
       Employee employee = null;
       ArrayList<Project> projectList = new ArrayList(); 
       ArrayList<String> overdueList = new ArrayList();
       ArrayList<String> exceededList = new ArrayList();
       
       if (request.getParameter("employeeName") == null || request.getParameter("Year") == null || request.getParameter("Month") == null ) {
            request.setAttribute("employee", employee);
        } else {
            String employeeName = (String) request.getParameter("employeeName");
            String year = (String) request.getParameter("Year");
            String month = (String) request.getParameter("Month");
            projectList = ProjectDAO.getStaffMonthlyReport(employeeName,month,year);
            overdueList = ProjectDAO.getOverdueProjectPerStaff(year, employeeName);
            exceededList = ProjectDAO.getTimeExceededPerStaff(year, employeeName);
            
        }
        request.setAttribute("employeeProjectList", projectList);
        request.setAttribute("employeeOverdue", overdueList);
        request.setAttribute("employeeTimeExceed", exceededList);
        RequestDispatcher rd = request.getRequestDispatcher("Dashboard.jsp");
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
