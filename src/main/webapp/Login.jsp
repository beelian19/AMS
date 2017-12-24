<%-- 
    Document   : Login
    Created on : Dec 24, 2017, 5:00:43 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px; margin-bottom: 0%'>
            <div class="nav-bar-header-plain" width="100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div style="margin-top: <%=session.getAttribute("margin")%>">
                    <div class="card card-container">
                        <img id="profile-img" class="profile-img-card" src="images/Abundant Logo White.png"/>
                        <form class="form-signin" id ="formtype" role="form" action="loginServlet" method="post">
                            <span id="reauth-email" class="reauth-email"></span>
                            <input type="text" name='UserId' id="UserId" class="form-control" placeholder="Username" required autofocus>
                            <input type="password" name='Password' id="Password" class="form-control" placeholder="Password" required>
                            <button class="btn btn-lg btn-primary btn-block btn-signin" type="submit"><font color="#034C75">Sign in</font></button>
                            <center><a href="ForgotPassword.jsp"><font color="#F5C904">Forgot/Change Password?</font></a></center>
                        </form><!-- /form -->
                    </div><!-- /card-container -->
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
