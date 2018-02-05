/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.ProjectManagement;

import DAO.ClientDAO;
import DAO.ProjectDAO;
import Entity.Client;
import Entity.Project;
import Entity.Timeline;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;

/**
 *
 * @author yemin
 */
@WebServlet(name = "GetClientObject", urlPatterns = {"/GetClientObject"})
public class GetClientObject extends HttpServlet {

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

        /* TODO output your page here. You may use following sample code. */
        String companyName = request.getParameter("companyName");
        if (companyName == null) {
            companyName = (String) request.getSession().getAttribute("CreateProjectCompanyName");
            if (companyName == null) {
                request.getSession().setAttribute("status", "Error: No company name parsed for creating a project");
                response.sendRedirect("ViewAllClient.jsp");
            }
        } else {
            request.getSession().setAttribute("CreateProjectCompanyName", companyName);
        }

        Client client = ClientDAO.getClientByCompanyName(companyName);

        Timeline timeline = new Timeline(client);
        boolean check = timeline.initAll();
        String errors = timeline.getErrors();
        HashMap<String, String> allTimeLines = timeline.getAllTimelines();
        ArrayList<Project> onGoingProjectList = ProjectDAO.getAllIncompleteProjectsByCompanyName(client.getCompanyName());
        HashMap<String, String> ongoingMap = ProjectDAO.getProjectTypeAsKeyAndURLAsValue(onGoingProjectList);
        JSONObject json = timeline.getAllTimelinesJSONObject();

        request.getSession().setAttribute("json", json);
        request.getSession().setAttribute("client", client);
        request.getSession().setAttribute("allTimeLines", allTimeLines);
        request.getSession().setAttribute("timelineInitErrors", errors);
        request.getSession().setAttribute("clientOnGoingUrlMap", ongoingMap);
        response.sendRedirect("CreateProject.jsp");

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
