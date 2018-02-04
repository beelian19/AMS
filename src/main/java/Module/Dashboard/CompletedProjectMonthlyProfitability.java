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
public class CompletedProjectMonthlyProfitability extends HttpServlet {

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
        System.out.println("CompletedProjectMonthlyProfitability servlet: "+selectedYear);
        ArrayList<ArrayList<Integer>> profitabilityList = new ArrayList();

        profitabilityList = ProjectDAO.getCompletedProjectMonthlyProfitability(selectedYear);
        int[] completedList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        
        ArrayList<Integer> completed = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = completedList[i];
            completed.add(value);
        }
        
        ArrayList<Integer> yearProfitList = profitabilityList.get(0);
        ArrayList<Integer> yearLossList = profitabilityList.get(1);
        
        System.out.println("YearProfit size: "+yearProfitList.size());
        System.out.println("YearLoss size: "+yearLossList.size());
        System.out.println("TotalCompleted size: "+completed.size());
        
        request.getSession().setAttribute("yearProfit", yearProfitList);
        request.getSession().setAttribute("yearLoss", yearLossList);
        request.getSession().setAttribute("totalCompletedList", completed);
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
