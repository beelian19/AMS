<%-- 
    Document   : ForgotPassword
    Created on : Dec 24, 2017, 5:14:49 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Password Reset | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px; margin-bottom: 0%'>
            <div class="nav-bar-header-plain" width="100%">
                <jsp:include page="Header-Plain.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; margin-top:0%" width="100%" height='100%'>
                    <h1>Password Reset</h1>
                    <h5>To reset password, please enter your email which the reset link will be sent to.</h5>
                    <br/>
                    <div class="container-fluid"> 
                        <form class="form-signin" id ="formtype" role="form" action="emailCheckServlet" method="post">
                            <table width='60%' class="cellpadding" align="center">
                                <tr>
                                    <td colspan='4'>
                                        <span id="reauth-email" class="reauth-email"></span>
                                        <input type="text" name='Email' id="Email" class="form-control" placeholder="Email" required autofocus>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="60%">                  
                                        &emsp;
                                    </td>
                                    <td style="float">
                                        <button class="btn btn-lg btn-primary btn-block" onclick="window.location.href='Login.jsp'">Cancel</button>
                                    </td>
                                    <td width="1%">                  
                                    </td>
                                    <td>
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">Submit</button>
                                    </td>
                                </tr>   
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>

