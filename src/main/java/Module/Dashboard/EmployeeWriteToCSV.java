/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import Entity.Project;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author yemin
 */
public class EmployeeWriteToCSV extends HttpServlet {

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
        ArrayList<Project> projectsList = (ArrayList<Project>) request.getSession().getAttribute("staffProjectList");
        String year = (String) request.getSession().getAttribute("yearEmployee");
        String name = (String) request.getSession().getAttribute("empNameSelected");
        FileWriter fileWriter = null;
        
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        DecimalFormat df = new DecimalFormat("#.00");

        String fileName = System.getProperty("user.home") + "/Desktop/"+ name +"ProductivityDataFor" + year + ".csv";
        System.out.println("Servlet: "+fileName);
        String FILE_HEADER = "companyName,projectName,hoursAssigned,hoursActual,difference(%),cost";
        String COMMA_DELIMITER = ",";
        String NEW_LINE_SEPARATOR = "\n";

        try {
            fileWriter = new FileWriter(fileName);

            fileWriter.append(FILE_HEADER.toString());
            fileWriter.append(NEW_LINE_SEPARATOR);

            for (Project p : projectsList) {
                double sales = ProjectDAO.getSales(p);
                double cost = ProjectDAO.getTotalActualCost(p);
                double profit = ProjectDAO.getProfit(p);
                String employees = "";
                if(!p.getEmployee2().toLowerCase().equals("na")) {
                    employees = p.getEmployee1() + " and "+p.getEmployee2();
                } else {
                    employees = p.getEmployee1();
                }
                
                fileWriter.append(p.getCompanyName());
                fileWriter.append(COMMA_DELIMITER);
                fileWriter.append(p.getProjectTitle());
                fileWriter.append(COMMA_DELIMITER);
                fileWriter.append(Double.toString(p.getPlannedHours()));
                fileWriter.append(COMMA_DELIMITER);
                fileWriter.append(Double.toString(p.getEmployee1Hours() + p.getEmployee2Hours()));
                fileWriter.append(COMMA_DELIMITER);
                fileWriter.append(df.format(p.getPlannedHours() - p.getEmployee1Hours() - p.getEmployee2Hours()));
                fileWriter.append(COMMA_DELIMITER);
                fileWriter.append(df.format(cost));
                fileWriter.append(NEW_LINE_SEPARATOR);
            }
        } catch (Exception e) {
            System.out.println("Exception at EmployeeWriteToCSV Servlet");
            e.printStackTrace();
        } finally {
            try {
                fileWriter.flush();
                fileWriter.close();
            } catch (IOException e) {
                System.out.println("IOException at EmployeeWriteToCSV Servlet");
                e.printStackTrace();
            }
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
