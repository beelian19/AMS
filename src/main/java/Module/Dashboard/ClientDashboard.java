/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
public class ClientDashboard extends HttpServlet {

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
        
        ArrayList<ArrayList<Integer>> profitabilityList = new ArrayList();
        
        String clientID = request.getParameter("clientID");
        String year = request.getParameter("year");
        //take in clientID and year as parameters
        profitabilityList = ProjectDAO.getCompanyMonthlyProfitability(clientID,year);
        int[] overdueList = new int[12];
        overdueList = ProjectDAO.getClientOverdueProjectPerYear(clientID,year);
        int[] ontimeList = new int[12];
        ontimeList = ProjectDAO.getClientOnTimeProjectPerYear(clientID,year);
        
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
        
        ArrayList<Integer> yearProfitList = profitabilityList.get(0);
        ArrayList<Integer> yearLossList = profitabilityList.get(1);
        
        request.getSession().setAttribute("clientYearProfit", yearProfitList);
        request.getSession().setAttribute("clientYearLoss", yearLossList);
        
        request.getSession().setAttribute("clientOverdueProject", overdue);
        request.getSession().setAttribute("clientOnTimeProject", ontime);
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
