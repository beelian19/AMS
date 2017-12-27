/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import static Utility.JsonFormatter.convertObjectToElement;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
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
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Utility.ConnectionManager;

/**
 *
 * @author yemin
 */
@WebServlet(name = "DisplayProjectForAdminHome", urlPatterns = {"/DisplayProjectForAdminHome"})
public class DisplayProjectForAdminHome extends HttpServlet {

    //private static String viewAll = "select title, start, end, 'NA' as assignedEmployee1, 'NA' as assignedEmployee2, reviewer, remarks, companyName, 'NA' as taskStatus, reviewStatus from project union select taskTitle, start, end, assignedEmployee1, assignedEmployee2, 'NA' as reviewer, taskRemarks, companyName, taskStatus, 'NA' as reviewStatus from task";
    private static String viewAll = "select task.projectID,taskID,task.title,task.start,task.end,task.taskRemarks,project.assignedEmployee1, project.assignedEmployee2,taskStatus,reviewer,reviewStatus,uniqueTaskID, project.companyName, project.projectRemarks,project.projectStatus, project.projectType, project.projectReviewer, project.projectReviewStatus from task inner join project ON task.projectID = project.projectID where projectType = 'adhoc' Union select projectID,'NA' as taskID, title, start, end,'NA' as taskRemarks, assignedEmployee1, assignedEmployee2,'NA' as taskStatus, 'NA' as reviewer, 'NA' as reviewStatus, null as uniqueTaskID, companyName, projectRemarks, projectStatus, projectType, projectReviewer, projectReviewStatus from project where projectType <> 'adhoc'";

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
        try (Connection conn = ConnectionManager.getConnection();) {
            /* TODO output your page here. You may use following sample code. */

            JsonArray events = new JsonArray();
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

            PrintWriter out = response.getWriter();
            //String statement = "SELECT * FROM project ";
            PreparedStatement stmt = conn.prepareStatement(viewAll);

            ResultSet rs = stmt.executeQuery();
//            System.out.println("ResultSet Check: "+ rs.next());
            rs.next();
            ResultSetMetaData rsmd = rs.getMetaData();
            do {
                int numColumns = rsmd.getColumnCount();
                JsonObject outputRequest = new JsonObject();
                for (int i = 1; i <= numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);

                    if (column_name.equals("end")) {
                        Calendar c = Calendar.getInstance();
                        String hold = rs.getString(5);
                        //System.out.println("Hold: "+hold);
                        Date endDate = (Date) df.parse(hold);
                        c.setTime(endDate);
                        c.add(Calendar.DATE, 1);
                        endDate = c.getTime();
                        //System.out.println(endDate);
                        outputRequest.add(column_name, convertObjectToElement(endDate));
                    } else if (column_name.equals("start")) {
                        Calendar c = Calendar.getInstance();
                        String hold = rs.getString(5);
                        //System.out.println(hold);
                        Date startDate = (Date) df.parse(hold);
                        c.setTime(startDate);
//                        c.add(Calendar.DATE, -1);
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
            //System.out.println(events);
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
