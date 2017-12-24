<%-- 
    Document   : ErrorPage
    Created on : Dec 24, 2017, 4:54:59 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error 404 | Abundant Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px; margin-bottom: 0%'>
            <div class="nav-bar-header-plain" width="100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div style="padding-top: 2%; text-align: center">
                <h1><font color="red"> Error 404: Page Not Found </font></h1>
                <br/>
                <div align="center" style="width: 30%; display: inline-block">
                    <input action="action" onclick="window.history.go(-1); return false;" type="button" value="Return to profile" class="btn btn-lg btn-primary btn-block"/>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
