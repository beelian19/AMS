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
import java.util.Calendar;
import java.util.Date;
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
        double[] actualHours = new double[12];
        double[] plannedHours = new double[12];

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
                Date end = p.getEnd();
                Calendar cal = Calendar.getInstance();
                cal.setTime(end);
                int month = cal.get(Calendar.MONTH);
//                System.out.println(month);
//                Jan = 0; Feb = 1; Mar = 2; ..... Dec = 11
                switch (month) {
                    case 0:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[0] = p.getPlannedHours();
                            }
                            actualHours[0] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[0] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[0] = p.getEmployee2Hours();
                        }
                        break;
                    case 1:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[1] = p.getPlannedHours();
                            }
                            actualHours[1] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[1] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[1] = p.getEmployee2Hours();
                        }
                        break;
                    case 2:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[2] = p.getPlannedHours();
                            }
                            actualHours[2] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[2] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[2] = p.getEmployee2Hours();
                        }
                        break;
                    case 3:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[3] = p.getPlannedHours();
                            }
                            actualHours[3] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[3] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[3] = p.getEmployee2Hours();
                        }
                        break;
                    case 4:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[4] = p.getPlannedHours();
                            }
                            actualHours[4] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[4] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[4] = p.getEmployee2Hours();
                        }
                        break;
                    case 5:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[5] = p.getPlannedHours();
                            }
                            actualHours[5] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[5] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[5] = p.getEmployee2Hours();
                        }
                        break;
                    case 6:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[6] = p.getPlannedHours();
                            }
                            actualHours[6] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[6] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[6] = p.getEmployee2Hours();
                        }
                        break;
                    case 7:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[7] = p.getPlannedHours();
                            }
                            actualHours[7] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[7] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[7] = p.getEmployee2Hours();
                        }
                        break;
                    case 8:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[8] = p.getPlannedHours();
                            }
                            actualHours[8] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[8] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[8] = p.getEmployee2Hours();
                        }
                        break;
                    case 9:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[9] = p.getPlannedHours();
                            }
                            actualHours[9] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[9] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[9] = p.getEmployee2Hours();
                        }
                        break;
                    case 10:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[10] = p.getPlannedHours();
                            }
                            actualHours[10] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[10] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[10] = p.getEmployee2Hours();
                        }
                        break;
                    case 11:
                        if (p.getEmployee1().equals(employeeName)) {
                            if (p.getEmployee2().equals("NA")) {
                                actualHours[11] = p.getPlannedHours();
                            }
                            actualHours[11] = p.getPlannedHours() / 2.0;
                        }

                        if (p.getEmployee1().equals(employeeName)) {
                            plannedHours[11] = p.getEmployee1Hours();
                        }
                        if (p.getEmployee2().equals(employeeName)) {
                            plannedHours[11] = p.getEmployee2Hours();
                        }
                        break;
                }
            }
        }

        JsonArray events = new JsonArray();
        PrintWriter out = response.getWriter();
        //overdue
        JsonObject outputRequest = new JsonObject();
        for (int i = 0; i < overdueList.length; i++) {
            outputRequest.add("" + i, convertObjectToElement(overdueList[i]));
        }
        events.add(outputRequest);

        //exceed
        JsonObject outputRequest1 = new JsonObject();
        for (int i = 0; i < exceededList.length; i++) {
            outputRequest1.add("" + i, convertObjectToElement(exceededList[i]));
        }
        events.add(outputRequest1);

        //completed
        JsonObject outputRequest2 = new JsonObject();
        for (int i = 0; i < completedList.length; i++) {
            outputRequest2.add("" + i, convertObjectToElement(completedList[i]));
        }
        events.add(outputRequest2);

        //actualHours
        JsonObject outputRequest3 = new JsonObject();
        for (int i = 0; i < actualHours.length; i++) {
            outputRequest3.add("" + i, convertObjectToElement(actualHours[i]));
        }
        events.add(outputRequest3);

        //plannedHours
        JsonObject outputRequest4 = new JsonObject();
        for (int i = 0; i < plannedHours.length; i++) {
            outputRequest4.add("" + i, convertObjectToElement(plannedHours[i]));
        }
        events.add(outputRequest4);

        //inTime
        JsonObject outputRequest5 = new JsonObject();
        for (int i = 0; i < inTimeList.length; i++) {
            outputRequest5.add("" + i, convertObjectToElement(inTimeList[i]));
        }
        events.add(outputRequest5);
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
