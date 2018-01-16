/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author yemin
 */
public class ProfitGraph extends HttpServlet {

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

//        String selectedYear = "2017";
//        PrintWriter out = response.getWriter();
//        Double[] profitArray = new Double[12];
//
//        HashMap<String, Double> profitList = ProjectDAO.getProfit(selectedYear);
//        for (String month : profitList.keySet()) {
//            switch (month) {
//                case "01":
//                    profitArray[0] = profitList.get(month);
//                    break;
//                case "02":
//                    profitArray[1] = profitList.get(month);
//                    break;
//                case "03":
//                    profitArray[2] = profitList.get(month);
//                    break;
//                case "04":
//                    profitArray[3] = profitList.get(month);
//                    break;
//                case "05":
//                    profitArray[4] = profitList.get(month);
//                    break;
//                case "06":
//                    profitArray[5] = profitList.get(month);
//                    break;
//                case "07":
//                    profitArray[6] = profitList.get(month);
//                    break;
//                case "08":
//                    profitArray[7] = profitList.get(month);
//                    break;
//                case "09":
//                    profitArray[8] = profitList.get(month);
//                    break;
//                case "10":
//                    profitArray[9] = profitList.get(month);
//                    break;
//                case "11":
//                    profitArray[10] = profitList.get(month);
//                    break;
//                case "12":
//                    profitArray[11] = profitList.get(month);
//                    break;
//            }
//        }
//        String output = "[";
//        for (int i = 0; i < profitArray.length; i++) {
//            if (i == 0) {
//                if (profitArray[i] != null) {
//                    output += profitArray[i];
//                } else {
//                    output += "0.0";
//                }
//
//            } else {
//                if (profitArray[i] != null) {
//                    output += "," + profitArray[i];
//                } else {
//                    output += ",0.0";
//                }
//
//            }
//        }
//        output += "]";
//        out.print(output);
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
