<%-- 
    Document   : AdminAccessOnly
    Created on : Dec 24, 2017, 3:20:19 PM
    Author     : Bernitatowyg
--%>

<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Employee"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
        // Admin Access Only checks if the user is admin, if not, redirect to homepage
        
        // Ensures session variable is not cached. Always checks if user is logged in - Even if back button is clicked!
        response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
        response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
        response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
        response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility

        // Obtain user from session attribute: userId
        String userId2 = (String) session.getAttribute("userId");
        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee emp = employeeDAO.getEmployeeByID(userId2);
        String isAdmin = emp.getIsAdmin();
        
        if(isAdmin.equals("no")){
            //it is not an admin, redirect to homepage
            session.setAttribute("status", "Error: You do not have authorisation to access this page"); 
            response.sendRedirect("EmployeeHome.jsp");
        }
    %>
    </head>
</html>
