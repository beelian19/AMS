/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import static Utility.JsonFormatter.convertObjectToElement;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import DAO.EmployeeDAO;
import Entity.Employee;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Utility.ConnectionManager;

/**
 *
 * @author yemin
 */
@WebServlet(name = "DisplayProjectForEmpHome", urlPatterns = {"/DisplayProjectForEmpHome"})
public class DisplayProjectForEmpHome extends HttpServlet {

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
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            HttpSession session = request.getSession();

            String empId = (String) session.getAttribute("userId");
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee employee = empDAO.getEmployeeByID(empId);
            String name = employee.getName();

            JsonArray events = new JsonArray();
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            ArrayList<String> list = new ArrayList<String>();

            Connection conn = ConnectionManager.getConnection();
            String statement = "select \n"
                    + "task.projectID,taskID,task.title,task.start,task.end,task.taskRemarks,project.employee1, project.employee2,taskStatus,reviewer,reviewStatus,uniqueTaskID, project.companyName, project.projectRemarks,project.projectStatus, project.projectType, project.projectReviewer, project.projectReviewStatus, project.actualDeadline \n"
                    + "from task \n"
                    + "inner join project \n"
                    + "ON task.projectID = project.projectID and "
                    + "(employee1= ? OR employee2= ? OR reviewer= ?) and projectType = 'adhoc' \n"
                    + "Union \n"
                    + "select \n"
                    + "projectID,'NA' as taskID, title, start, end,'NA' as taskRemarks, employee1, employee2,'NA' as taskStatus, 'NA' as reviewer, 'NA' as reviewStatus, null as uniqueTaskID, companyName, projectRemarks, projectStatus, projectType, projectReviewer, projectReviewStatus, actualDeadline \n"
                    + "from project \n"
                    + "where projectType <>'adhoc' AND (employee1= ? OR employee2= ? OR project.projectReviewer= ?)";
            PreparedStatement stmt = conn.prepareStatement(statement);
            stmt.setString(1, name);
            stmt.setString(2, name);
            stmt.setString(3, name);
            stmt.setString(4, name);
            stmt.setString(5, name);
            stmt.setString(6, name);

            ResultSet rs = stmt.executeQuery();

            ResultSetMetaData rsmd = rs.getMetaData();
            int numColumns = rsmd.getColumnCount();
//            System.out.println("Check number of columns: " + numColumns);
            if (!rs.next()) {
                //outputRequest.add("status", convertObjectToElement("error"));
                list.add("error");
            } else {
                do {

                    JsonObject outputRequest = new JsonObject();
                    for (int i = 1; i <= numColumns; i++) {
                        String column_name = rsmd.getColumnName(i);
                        if (column_name.equals("end")) {
                            Calendar c = Calendar.getInstance();
                            String hold = rs.getString(5);

                            Date endDate = (Date) df.parse(hold);
                            c.setTime(endDate);
                            c.add(Calendar.DATE, 1);
                            endDate = (Date) c.getTime();
//                            System.out.println(endDate);
                            outputRequest.add(column_name, convertObjectToElement(endDate));
                        } else if (column_name.equals("start")) {
                            Calendar c = Calendar.getInstance();
                            String hold = rs.getString(5);
                            //System.out.println(hold);
                            Date startDate = (Date) df.parse(hold);
                            c.setTime(startDate);
                            //c.add(Calendar.DATE, -1);
                            startDate = c.getTime();
                            //System.out.println(startDate);
                            outputRequest.add(column_name, convertObjectToElement(startDate));
                        } else {
                            outputRequest.add(column_name, convertObjectToElement(rs.getObject(column_name)));
                        }
                    }
                    events.add(outputRequest);
                } while (rs.next());
                out.print(events);
            }
            //out.print(events);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
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
