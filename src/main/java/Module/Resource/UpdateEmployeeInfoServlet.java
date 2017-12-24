/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.EmployeeDAO;
import Entity.Employee;
import java.io.IOException;
import java.io.PrintWriter;
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

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "UpdateEmployeeInfoServlet", urlPatterns = {"/UpdateEmployeeInfoServlet"})
public class UpdateEmployeeInfoServlet extends HttpServlet {

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
            String employeeID = request.getParameter("employeeID");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String isAdmin = request.getParameter("isAdmin");
            String currentSalary = request.getParameter("currentSalary");
            String position = request.getParameter("position");
            String supervisor = request.getParameter("supervisor");
            String bankAcct = request.getParameter("bankAccount");
            String nric = request.getParameter("NRIC");
            String name = request.getParameter("name");
            String number = request.getParameter("number");
            String date1 = request.getParameter("dateJoined");
            Date dateJoined=new SimpleDateFormat("yyyy-MM-dd").parse(date1);
            String date2 = request.getParameter("dob");
            Date dateOfBirth =new SimpleDateFormat("yyyy-MM-dd").parse(date2);
            String nationality = request.getParameter("nationality");
            
            EmployeeDAO employeeDao = new EmployeeDAO();
            Employee toUpdate = new Employee(employeeID, password, email,isAdmin,currentSalary,position,supervisor,bankAcct,nric,name,number,dateJoined,dateOfBirth,nationality);
            
            boolean status = employeeDao.updateEmployeeDetails(toUpdate);
            if (status == true) {
                System.out.println("UPDATE IS SUCCESSFUL");
                request.setAttribute("updateStatus", "Successful");
            } else {
                System.out.println("UPDATE IS UNSUCCESSFUL");
                request.setAttribute("updateStatus", "Unsuccessful");
            }

//            RequestDispatcher rd = request.getRequestDispatcher("ViewEmployee.jsp");
//            request.setAttribute("status", status);
//            rd.forward(request, response);
            // will forward status of "true" or "false", if false means there's some sort of error
            RequestDispatcher rd = request.getRequestDispatcher("ViewEmployee.jsp");
            rd.forward(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(UpdateEmployeeInfoServlet.class.getName()).log(Level.SEVERE, null, ex);
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
