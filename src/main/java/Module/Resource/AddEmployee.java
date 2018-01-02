/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.EmployeeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
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
@WebServlet(name = "AddEmployee", urlPatterns = {"/AddEmployee"})
public class AddEmployee extends HttpServlet {

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
            
            String employeeName = request.getParameter("employeeName");
            String employeeNRIC = request.getParameter("employeeNRIC");
            String employeeEmail = request.getParameter("employeeEmail");
            String employeeNumber = request.getParameter("employeeNumber");
            String employeeBankAccount = request.getParameter("employeeBankAccount");
            
            String employeePosition = request.getParameter("employeePosition");
            String supervisor = request.getParameter("supervisor");
            String employeeSalary = request.getParameter("employeeSalary");
            String isAdminValue = request.getParameter("isAdmin");
            
            String date1 = request.getParameter("dateJoined");
            Date dateJoined=new SimpleDateFormat("yyyy-MM-dd").parse(date1);
            java.sql.Date dJoined = new java.sql.Date(dateJoined.getTime());
            
            String date2 = request.getParameter("dob");
            Date dateOfBirth=new SimpleDateFormat("yyyy-MM-dd").parse(date2);
            java.sql.Date dOfBirth = new java.sql.Date(dateOfBirth.getTime());
            
            String nationality = request.getParameter("nationality");
            String tempPassword = request.getParameter("tempPassword");
            String employeeID = employeeEmail.substring(0, employeeEmail.indexOf("@"));
            
            EmployeeDAO empDAO= new EmployeeDAO();
            HttpSession session = request.getSession();
            if(empDAO.createEmployee(employeeID, tempPassword, employeeEmail, isAdminValue, employeeSalary, employeePosition, supervisor, employeeBankAccount, employeeNRIC, employeeName, employeeNumber,dJoined,dOfBirth, nationality)) {
                session.setAttribute("status", "Success: Employee added");
                response.sendRedirect("EmployeeOverview.jsp");
            } else {
                session.setAttribute("status", "Error: Unable to add employee. Please try again.");
                response.sendRedirect("CreateUser.jsp");
            }
        } catch (ParseException ex) {
            Logger.getLogger(AddEmployee.class.getName()).log(Level.SEVERE, null, ex);
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
