/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
public class OverdueProjectPerYear extends HttpServlet {

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
        
        String selectedYear = request.getParameter("year");
        System.out.println("OverdueProjectPerYear servlet: "+selectedYear);
        int[] overdueList = new int[12];
        int[] ontimeList = ProjectDAO.getOnTimeProjectPerYear(selectedYear);
        int[] completedList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        overdueList = ProjectDAO.getOverdueProjectPerYear(selectedYear);
        
        ArrayList<Integer> overdue = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = overdueList[i];
            overdue.add(value);
        }
        
         ArrayList<Integer> ontime = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = ontimeList[i];
            ontime.add(value);
        }
        
         ArrayList<Integer> completed = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = completedList[i];
            completed.add(value);
        }
        System.out.println("Overdue size: "+overdue.size());
        System.out.println("Ontime size: "+ontime.size());
        System.out.println("Completed size: "+completed.size());
        request.getSession().setAttribute("overdueProject", overdue);
        request.getSession().setAttribute("ontimeProject", ontime);
        request.getSession().setAttribute("completedProject", completed);
        
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
