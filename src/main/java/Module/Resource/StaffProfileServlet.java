/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.EmployeeDAO;
import DAO.ProjectDAO;
import Entity.Employee;
import Entity.Project;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
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
@WebServlet(name = "StaffProfileServlet", urlPatterns = {"/StaffProfileServlet"})
public class StaffProfileServlet extends HttpServlet {

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
        Calendar deadline;
        try (PrintWriter out = response.getWriter()) {
            
            HttpSession session = request.getSession();
            
            //String employeeID = (String)session.getAttribute("userId");
            String employeeID = (String) request.getAttribute("id");
        
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee emp = empDAO.getEmployeeByID(employeeID);
            String checkingName = emp.getName();
            //System.out.println("Name check: "+checkingName);
            ArrayList<ArrayList<Project>> both = ProjectDAO.getAllProjectsByEmployee(checkingName);
            ArrayList<Project> incompleteProjList = both.get(1);
            ArrayList<Project> incomProjList = new ArrayList<>();
            ArrayList<Project> overdueProjList = new ArrayList<>();
            for (Project p: incompleteProjList){
                deadline = Calendar.getInstance();
                deadline.setTime(p.getEnd());
                if(Calendar.getInstance().before(deadline)){
                    incomProjList.add(p);
                } else {
                    overdueProjList.add(p);
                }
            }
            ArrayList<Project> completeProjList = both.get(0);
            request.setAttribute("name", emp.getName());
            request.setAttribute("email", emp.getEmail());
            request.setAttribute("id", emp.getEmployeeID());
            request.setAttribute("number", emp.getNumber());
            request.setAttribute("position", emp.getPosition());
            request.setAttribute("dateJoined", emp.getDateJoined());
            request.setAttribute("overdueProject", overdueProjList);
            request.setAttribute("incompletedProject", incomProjList);
            request.setAttribute("completedProject", completeProjList);
            request.setAttribute("dob",emp.getDob());
            //request.setAttribute("nationality", emp.getNationality());
            //request.setAttribute("nric",emp.getNric());
            //request.setAttribute("bankAccount",emp.getBankAccount());
            
            RequestDispatcher rd = request.getRequestDispatcher("EmployeeProfile.jsp");
            rd.forward(request, response);
//            response.sendRedirect("StaffProfile.jsp");
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
