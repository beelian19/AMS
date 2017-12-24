<%-- 
    Document   : ResetPassword
    Created on : Dec 24, 2017, 5:06:07 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html height="100%">
    <head>
        <title>Password Reset | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px; margin-bottom: 0%'>
            <div class="nav-bar-header-plain" width="100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center;" width="100%" height='100%'>
                    <h2>Password Reset</h2>
                    <div id="main">
                        <form id ="formtype" role="form" action="resetPasswordServlet" method="post">
                            <span id="reauth-email" class="reauth-email"></span>
                            <div class="row pass">
                                <input type="password" id="password1" name="password1" placeholder="Enter New Password" />
                            </div>
                            <div class="row pass">
                                <input type="password" id="password2" name="password2" placeholder="Confirm New Password"  />
                            </div>
                            <div class="arrowCap"></div>
                            <div class="arrow"></div>
                            <center><button class="btn btn-sm btn-primary btn-block btn-signin reset-submit" type="submit">Submit</button><center>
                            <div style="text-align: center">
                                <div style="text-align: center"> 
                                    <font size="1px" color="blue">1. Password should be at least 8 characters in length.</br></font>
                                    <font size="1px" color="blue">2. Contain at least 1 lowercase/uppercase & 1 special character.</br></font>
                                </div>
                            </div>
                        </form><!-- /form -->
                    </div>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
    <script src="lib/jquery.min.js" type="text/javascript"></script>
    <script src="lib/jquery-ui.min.js" type="text/javascript"></script>
    <script src="lib/bootstrap.min.js" type="text/javascript"></script>
    <script src="lib/jquery.complexify.js"></script>
    <script src="lib/script.js"></script>
    <link href='css/bootstrap.min.css' rel="stylesheet"/>
    <link rel="stylesheet" href="css/styles.css" />
</html>