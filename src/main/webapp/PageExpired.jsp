<%-- 
    Document   : PageExpired
    Created on : Dec 24, 2017, 5:04:25 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Page Expired | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" width="100%" height='100%' align="center">
                    <h1>&nbsp;</h1>
                    <h1>Page Expired</h1>
                    <br/>
                    <h4>The page you have requested has expired</h4>
                    <br/>
                    <input type="button" onclick="location.href='Login.jsp';" value="Go Back to Login" />
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>