/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Resource;

import DAO.ClientDAO;
import DAO.ProjectDAO;
import Entity.Client;
import Entity.Project;
import java.io.IOException;
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
public class ViewClientServlet extends HttpServlet {

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

        Client client = null;
        ArrayList<Project> incompleteProjList = new ArrayList<>();
        ArrayList<Project> completeProjList = new ArrayList<>();
        ArrayList<ArrayList<Project>> all;
        //Ensure that attribute is there and of instance String

        if (request.getAttribute("clientID") == null) {
            request.setAttribute("client", client);
        } else {
            String client_id = (String) request.getAttribute("clientID");
            client = ClientDAO.getClientById(client_id);
            request.setAttribute("client", client);
        }
        if (client == null) {
            // add status message
            RequestDispatcher rd = request.getRequestDispatcher("ClientOverview.jsp");
            rd.forward(request, response);
        } else {
            all = ClientDAO.getAllClientProjectFiltered(client.getCompanyName());

            if (all != null && all.size() == 2) {
                completeProjList = all.get(0);

                incompleteProjList = all.get(1);

            }
        }
        Double sum_hours = 0.0;
        if (completeProjList != null) {
            sum_hours = ProjectDAO.getTotalHours(completeProjList);
        }
        request.setAttribute("incompletedProject", incompleteProjList);
        request.setAttribute("completedProject", completeProjList);
        request.setAttribute("total_complete_hours", sum_hours);
        RequestDispatcher rd = request.getRequestDispatcher("ClientProfile.jsp");
        rd.forward(request, response);

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
