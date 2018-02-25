/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import static Utility.JsonFormatter.convertObjectToElement;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author yemin
 */
public class SalesGraph extends HttpServlet {

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
        String selectedYear = request.getParameter("year");
        Double[] salesList = ProjectDAO.getSales(selectedYear);
        Double[] costList = ProjectDAO.getActualCost(selectedYear);
        Double[] profitList = ProjectDAO.getProfit(selectedYear);
        
        int[] overdueList = ProjectDAO.getOverdueProjectPerYear(selectedYear);;
        int[] ontimeList = ProjectDAO.getOnTimeProjectPerYear(selectedYear);
        int[] completedList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        
        ArrayList<ArrayList<Integer>> profitabilityList = ProjectDAO.getCompletedProjectMonthlyProfitability(selectedYear);
        int[] completedProjectsList = ProjectDAO.getTotalCompletedProjectPerYear(selectedYear);
        ArrayList<Integer> yearProfitList = profitabilityList.get(0);
        ArrayList<Integer> yearLossList = profitabilityList.get(1);

        DecimalFormat decimal = new DecimalFormat("#.##");
        JsonArray events = new JsonArray();
        PrintWriter out = response.getWriter();
        
        JsonObject outputRequest = new JsonObject();
        for (int i = 0; i < salesList.length; i++) {
            outputRequest.add(""+i, convertObjectToElement(decimal.format(salesList[i])));
        }
        //outputRequest.add("sales", convertObjectToElement(salesMap));
        events.add(outputRequest);
        
        JsonObject outputRequest1 = new JsonObject();
        for (int i = 0; i < costList.length; i++) {
            outputRequest1.add(""+i, convertObjectToElement(decimal.format(costList[i])));
        }
        events.add(outputRequest1);
        
        JsonObject outputRequest2 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest2.add(""+i, convertObjectToElement(decimal.format(profitList[i])));
        }
        events.add(outputRequest2);
        
        //Overdue,Ontime, Completed Projects
        JsonObject outputRequest3 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest3.add(""+i, convertObjectToElement(overdueList[i]));
        }
        events.add(outputRequest3);
        
        JsonObject outputRequest4 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest4.add(""+i, convertObjectToElement(ontimeList[i]));
        }
        events.add(outputRequest4);
        
        JsonObject outputRequest5 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest5.add(""+i, convertObjectToElement(completedList[i]));
        }
        events.add(outputRequest5);
        
        //CompletedProjectMonthlyProfitability
        JsonObject outputRequest6 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest6.add(""+i, convertObjectToElement(completedProjectsList[i]));
        }
        events.add(outputRequest6);
        
        JsonObject outputRequest7 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest7.add(""+i, convertObjectToElement(yearProfitList.get(i)));
        }
        events.add(outputRequest7);
        
        JsonObject outputRequest8 = new JsonObject();
        for (int i = 0; i < profitList.length; i++) {
            outputRequest8.add(""+i, convertObjectToElement(yearLossList.get(i)));
        }
        events.add(outputRequest8);
        request.getSession().setAttribute("test","FK THIS SHIT");
        out.print(events);
        
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
