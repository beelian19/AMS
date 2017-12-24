<%-- 
    Document   : Protect.jsp
    Created on : Dec 24, 2017, 3:49:11 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    // Ensures session variable is not cached! 
    // Always checks if user is logged in - Even if back button is clicked!
    response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
    response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
    response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
    response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility
    
    // Obtain user from session attribute: userId
    String userId = (String) session.getAttribute("userId");
    //Redirects user to Login page if user session is null
    if (userId == null) {
      response.sendRedirect("Login.jsp");
      return;
    }
%>
