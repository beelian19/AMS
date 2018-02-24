/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Dashboard;

import DAO.ProjectDAO;
import Entity.Employee;
import Entity.Project;
import static Utility.JsonFormatter.convertObjectToElement;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
public class StaffMonthlyReport extends HttpServlet {

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

        Employee employee = null;
        ArrayList<Project> projectList = new ArrayList();
        int[] overdueList = new int[12];
        int[] exceededList = new int[12];
        int[] completedList = new int[12];
        int[] inTimeList = new int[12];
        ArrayList<Double> actualHours = new ArrayList();
        ArrayList<Double> plannedHours = new ArrayList();

        if (request.getParameter("employeeName") == null || request.getParameter("Year") == null) {
            request.setAttribute("employee", employee);
        } else {
            String employeeName = (String) request.getParameter("employeeName");
            String year = (String) request.getParameter("Year");
            request.getSession().setAttribute("empName", employeeName);
//            System.out.println("Year: "+year);
            projectList = ProjectDAO.getStaffMonthlyReport(employeeName, year);
            overdueList = ProjectDAO.getOverdueProjectPerStaff(year, employeeName);
            exceededList = ProjectDAO.getTimeExceededPerStaff(year, employeeName);
            completedList = ProjectDAO.getCompletedProjectPerYear(year, employeeName);
            inTimeList = ProjectDAO.getOnTimeCompletedProjectEmployee(employeeName, year);
            for (Project p : projectList) {

                if (p.getEmployee1().equals(employeeName)) {
                    if (p.getEmployee2().equals("NA")) {
                        actualHours.add(p.getPlannedHours());
                    }
                    actualHours.add(p.getPlannedHours() / 2.0);
                }

                if (p.getEmployee1().equals(employeeName)) {
                    plannedHours.add(p.getEmployee1Hours());
                }
                if (p.getEmployee2().equals(employeeName)) {
                    plannedHours.add(p.getEmployee2Hours());
                }
            }
        }
        
        JsonArray events = new JsonArray();
        PrintWriter out = response.getWriter();
        //overdue
        JsonObject outputRequest = new JsonObject();
        for (int i = 0; i < overdueList.length; i++) {
            outputRequest.add(""+i, convertObjectToElement(overdueList[i]));
        }
        events.add(outputRequest);
        
        //exceed
        JsonObject outputRequest1 = new JsonObject();
        for (int i = 0; i < exceededList.length; i++) {
            outputRequest1.add(""+i, convertObjectToElement(exceededList[i]));
        }
        events.add(outputRequest1);
        
        //completed
        JsonObject outputRequest2 = new JsonObject();
        for (int i = 0; i < completedList.length; i++) {
            outputRequest2.add(""+i, convertObjectToElement(completedList[i]));
        }
        events.add(outputRequest2);
        
        //actualHours
        JsonObject outputRequest3 = new JsonObject();
        for (int i = 0; i < actualHours.size(); i++) {
            outputRequest3.add(""+i, convertObjectToElement(actualHours.get(i)));
        }
        events.add(outputRequest3);
        
        //plannedHours
        JsonObject outputRequest4 = new JsonObject();
        for (int i = 0; i < plannedHours.size(); i++) {
            outputRequest4.add(""+i, convertObjectToElement(plannedHours.get(i)));
        }
        events.add(outputRequest4);
        
        //inTime
        JsonObject outputRequest5 = new JsonObject();
        for (int i = 0; i < inTimeList.length; i++) {
            outputRequest5.add(""+i, convertObjectToElement(inTimeList[i]));
        }
        events.add(outputRequest5);
        out.print(events);
        request.getSession().setAttribute("staffProjectList", projectList);
//        request.getSession().setAttribute("employeeOverdue", overdue);
//        request.getSession().setAttribute("employeeTimeExceed", exceed);
//        request.getSession().setAttribute("completedList", completed);
//        request.getSession().setAttribute("actualHours", actualHours);
//        request.getSession().setAttribute("plannedHours", plannedHours);
//        request.getSession().setAttribute("inTime", inTime);
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
