/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ProjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jagdishps.2014
 */
@WebServlet(name = "UpdateProjectDetailsfromModal", urlPatterns = {"/UpdateProjectDetailsfromModal"})
public class UpdateProjectDetailsfromModal extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String projectID = request.getParameter("projectID");
            String projectTitle = request.getParameter("projectTitle");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            String projectRemarks = request.getParameter("projectRemarks");
            String emp1 = request.getParameter("emp1");
            String emp2 = request.getParameter("emp2");

            String projectReviewer = request.getParameter("projectReviewer");
            
            String[] startTrim = startDate.split("-");
            String[] endTrim = endDate.split("-");
            
            String newStart = startTrim[2]+"/"+startTrim[1]+"/"+startTrim[0];
            String newEnd = endTrim[2]+"/"+endTrim[1]+"/"+endTrim[0];
            DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
            Date start = df.parse(newStart);
            Date end = df.parse(newEnd);
            //need company category to pass over
            boolean check = ProjectDAO.updateProject(projectID, projectTitle, start, end, projectRemarks, emp1, emp2, projectReviewer);
            if (check) {
                response.sendRedirect("ProjectProfile.jsp?projectID=" + projectID);
            } else {
                System.out.println("UpdateProject Servlet: Unexpected Error!!");
            }
        } catch(ParseException e) {
            System.out.println("Unexpected Error at UpdateProject Servlet: "+e.getMessage());
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
