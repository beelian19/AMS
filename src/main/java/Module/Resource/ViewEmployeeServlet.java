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
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author yemin
 */
public class ViewEmployeeServlet extends HttpServlet {

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
        ArrayList<String> nameList = new ArrayList();
        ArrayList<String> emailList = new ArrayList();
        ArrayList<String> positionList = new ArrayList();
        ArrayList<String> isAdminList = new ArrayList();
        ArrayList<String> numberList = new ArrayList();
        ArrayList<String> idList = new ArrayList();
        

        ArrayList<String> returnNameList = new ArrayList();
        ArrayList<String> returnEmailList = new ArrayList();
        ArrayList<String> returnPositionList = new ArrayList();
        ArrayList<String> returnIsAdminList = new ArrayList();
        ArrayList<String> returnNumberList = new ArrayList();
        ArrayList<String> returnIdList = new ArrayList();

        try (PrintWriter out = response.getWriter()) {
            
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<Employee> empList = empDAO.getAllEmployees();

            for (int i = 0; i < empList.size(); i++) {
                Employee emp = empList.get(i);
                nameList.add(emp.getName());
                emailList.add(emp.getEmail());
                positionList.add(emp.getPosition());
                isAdminList.add(emp.getIsAdmin());
                numberList.add(emp.getNumber());
                idList.add(emp.getEmployeeID());
            }
            for (int i = 0; i < nameList.size(); i++) {
                returnNameList.add(nameList.get(i));
                returnEmailList.add(emailList.get(i));
                returnPositionList.add(positionList.get(i));
                returnNumberList.add(numberList.get(i));
                String isAdmin = isAdminList.get(i);
                returnIdList.add(idList.get(i));
                if (isAdmin.equals("no")) {
                    returnIsAdminList.add("No");
                } else {
                    returnIsAdminList.add("Yes");
                }
            }
          
            request.setAttribute("nameList", returnNameList);
            request.setAttribute("emailList", returnEmailList);
            request.setAttribute("positionList", returnPositionList);
            request.setAttribute("isAdminList", returnIsAdminList);
            request.setAttribute("numberList",returnNumberList);
            request.setAttribute("idList",returnIdList);
           

            RequestDispatcher rd = request.getRequestDispatcher("ViewEmployee.jsp");
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
