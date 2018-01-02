/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.EmployeeDAO;
import Entity.Employee;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author yemin
 */
@WebServlet(name = "loginServlet", urlPatterns = {"/loginServlet"})
public class loginServlet extends HttpServlet {

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
        String userId = request.getParameter("UserId");
        String password = request.getParameter("Password");

        Employee employee = EmployeeDAO.getEmployeebyIDandPassword(userId, password);

        HttpSession session = request.getSession();

        if (employee == null) {
            session.setAttribute("status", "Error: Login failed! Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
            rd.forward(request, response);
        } else if (employee.getPassword().equals(password) && !employee.getPosition().equals("Ex-Employee")) {
            //this means that the user is not an admin
            //standardized the session attributes
            session.setAttribute("employeeName", employee.getName());
            if (employee.getIsAdmin().equals("no")) {
                session.setAttribute("userId", employee.getEmployeeID());
                session.setAttribute("sessionUserIsAdmin", "no");
                response.sendRedirect("EmployeeHome.jsp");
                return;
            } else {
                //if user is an admin
                session.setAttribute("userId", employee.getEmployeeID());
                session.setAttribute("sessionUserIsAdmin", "yes");
                response.sendRedirect("AdminHome.jsp");
                return;
            }

        } else if (employee.getPosition().equals("Ex-Employee")) {
            session.setAttribute("status", "Error: User Access Denied");
            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
            rd.forward(request, response);
        } else if (!employee.getPassword().equals(password) && !employee.getPosition().equals("Former Staff")) {
            session.setAttribute("status", "Error: Username/Password is invalid");
            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
            rd.forward(request, response);
        } else {
            session.setAttribute("status", "Error: Username/Password is invalid*");
            RequestDispatcher rd = request.getRequestDispatcher("Login.jsp");
            rd.forward(request, response);
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
