<%-- 
    Document   : ExpenseWaiting
    Created on : Jan 18, 2018, 6:49:13 PM
    Author     : Bernitatowyg
--%>
<%@include file="Protect.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Waiting Reset | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" style="width:100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; margin-top: <%=session.getAttribute("margin")%>" width="100%" height='100%'>
                    <h4>Expense is still processing please wait</h4>
                    <input type="button" onclick="location.href='ExpenseResult.jsp';" value="Go Back to Expense Result" />
                </div>
            </nav>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
