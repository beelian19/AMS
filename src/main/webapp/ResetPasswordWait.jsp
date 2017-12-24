<%-- 
    Document   : ResetPasswordWait
    Created on : Dec 24, 2017, 5:12:43 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.EmployeeDAO"%>
<%@page import="entity.Employee"%>

<!DOCTYPE html>
<html>
    <html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Password Reset | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" style="width:100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; margin-top: <%=session.getAttribute("margin")%>" width="100%" height='100%'>
                    <i class="material-icons" style="font-size: 100px;">done</i>
                    <h3>Password email sent</h3>
                    <h4>Follow the directions in the email to reset password</h4>
                    <input type="button" onclick="location.href='Login.jsp';" value="Go Back to Login" />
                </div>
            </nav>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
