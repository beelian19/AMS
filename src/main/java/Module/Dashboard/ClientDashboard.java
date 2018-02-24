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
        String clientID = request.getParameter("clientID");
        String year = request.getParameter("year");
//        System.out.println("Client Dashboard - Client ID: "+clientID);
//        System.out.println("Client Dashboard - Year: "+year);

        //take in clientID and year as parameters
        
        int[] overdueList = new int[12];
        overdueList = ProjectDAO.getClientOverdueProjectPerYear(clientID,year);
        int[] ontimeList = new int[12];
        ontimeList = ProjectDAO.getClientOnTimeProjectPerYear(clientID,year);
        
        ArrayList<ArrayList<Integer>> profitabilityList = profitabilityList = ProjectDAO.getCompanyMonthlyProfitability(clientID,year);
        ArrayList<Integer> yearProfitList = profitabilityList.get(0);
        ArrayList<Integer> yearLossList = profitabilityList.get(1);
        
        JsonArray events = new JsonArray();
        PrintWriter out = response.getWriter();
        //overdueList
        JsonObject outputRequest = new JsonObject();
        for (int i = 0; i < overdueList.length; i++) {
            outputRequest.add(""+i, convertObjectToElement(overdueList[i]));
        }
        events.add(outputRequest);
        
        //ontimeList
        JsonObject outputRequest1 = new JsonObject();
        for (int i = 0; i < ontimeList.length; i++) {
            outputRequest1.add(""+i, convertObjectToElement(ontimeList[i]));
        }
        events.add(outputRequest1);
        
        //yearProfitList
        JsonObject outputRequest2 = new JsonObject();
        for (int i = 0; i < yearProfitList.size(); i++) {
            outputRequest2.add(""+i, convertObjectToElement(yearProfitList.get(i)));
        }
        events.add(outputRequest2);
        
        //yearLossList
        JsonObject outputRequest3 = new JsonObject();
        for (int i = 0; i < yearLossList.size(); i++) {
            outputRequest3.add(""+i, convertObjectToElement(yearLossList.get(i)));
        }
        events.add(outputRequest3);
        
        request.getSession().setAttribute("clientID", clientID);
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
