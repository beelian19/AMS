<%-- 
    Document   : Header-Plain
    Created on : Oct 23, 2017, 1:56:06 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style type="text/css">
            .table, .tr, .td, .a, .font{
                font-family: Arial;
                padding-right: 0px;
                margin-right: 0px;
            }
            
            .white{
                color: #fff !important;
                font-family: Arial;
            }
            
            .dashboard-header, .dashboard-header:hover{
                color: white;
                text-decoration: none;
                font-family: Arial;
                align-items: left;
            }
            
            .a{
                text-decoration: none;
                color: white;
            }
            
            .navbar-head{
                background-color : #034C75;
                font-family: Arial;
            }
            
            .navbar-neck{
                background-color: #F5C904;
                font-family: Arial;
                width: 100%;
            }
            
            .neck-button{
                border-radius: 0 !important;
                background-color: #F5C904 !important;
                border-color: #F5C904 !important;
                border-width: 0 !important;
            }
            
            <!--main stuff-->
            
            html, body{
                top:0;
                bottom:0;
                left:0;
                right:0;
                width: 100%;
                margin-left: 0;
                margin-right: 0;
                padding: 0;
            }
            
            container-fluid-div{
                margin-left: 0;
                margin-right: 0;
                padding-left: 0;
                padding-right: 0;
                padding-top: 0;
                padding-bottom: 0;
            }
            
            .body {
                overflow: scroll;
                margin: 0;
                padding: 0;
                height: 75%;
            }
            
            footer{
                position: absolute;
                bottom:0;
                left:0;
                right:0;
                height: 12%;
            }
            
            div{
                padding-left: 0px;
                padding-right: 0px;
                padding-top: 0px;
                padding-bottom: 0px;
            }
            
            nav{
                padding-left: 0px;
                padding-right: 0px;
                padding-top: 0px;
                padding-bottom: 0px;
                width: 100%;
                height: 100%;
            }
            
            .dropdown-toggle:active, .open .dropdown-toggle {
                background-color:#034C75 !important;
            }
            
            .body {
                overflow: scroll;
                margin: 0;
                padding: 0;
            }
            
            .card {
                background-color: #034C75;
                /* just in case there no content*/
                padding: 20px 20px 20px;
                margin: 0 auto 25px;
                margin-top: 50px;
                /* shadows and rounded borders */
                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                border-radius: 30px;
                -moz-box-shadow: 0px 5px 5px rgba(0, 0, 0, 0.3);
                -webkit-box-shadow: 0px 5px 5px rgba(0, 0, 0, 0.3);
                box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
            }

            .profile-img-card {
                width: 120px;
                height: 120px;
                margin: 0 auto 0px;
                display: block;
                -moz-border-radius: 50%;
                -webkit-border-radius: 50%;
                border-radius: 50%;
            }

            /*
             * Form styles
             */
            .profile-name-card {
                font-size: 16px;
                font-weight: bold;
                text-align: center;
                margin: 10px 0 0;
                min-height: 1em;
            }

            .reauth-email {
                display: block;
                color: #F5C904;/*#404040;*/
                line-height: 2;
                margin-bottom: 10px;
                font-size: 14px;
                text-align: center;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                -moz-box-sizing: border-box;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
            }

            .form-signin #inputUsername,
            .form-signin #inputPassword {
                direction: ltr;
                height: 44px;
                font-size: 16px;
            }

            .form-signin input[type=text],
            .form-signin input[type=password],
            .form-signin input[type=text],
            .form-signin button {
                width: 100%;
                display: block;
                margin-bottom: 10px;
                z-index: 1;
                position: relative;
                -moz-box-sizing: border-box;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
            }

            .form-signin .form-control:focus {
                border-color: #F5C904; /*rgb(104, 145, 162)*/
                outline: 0;
                -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgb(104, 145, 162);
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgb(104, 145, 162);
            }

            .btn.btn-signin {
                /*background-color: #4d90fe; */
                background-color: #F5C904; 
                /* background-color: linear-gradient(rgb(104, 145, 162), rgb(12, 97, 33));*/
                padding: 0px;
                font-weight: 700;
                font-size: 14px;
                height: 36px;
                -moz-border-radius: 3px;
                -webkit-border-radius: 3px;
                border-radius: 3px;
                border: none;
                -o-transition: all 0.218s;
                -moz-transition: all 0.218s;
                -webkit-transition: all 0.218s;
                transition: all 0.218s;
            }
            
            .container-fluid-div{
                margin-left: 0;
                margin-right: 0;
                padding-left: 0;
                padding-right: 0;
                padding-top: 0;
                padding-bottom: 0;
            }
            
            .card-container.card {
                max-width: 350px;
                padding: 40px 40px;
            }
            
            .nav-bar-header-plain{
                width: 100% !important;
            }
            
            a:link{
                padding: 0px;
                text-decoration: none;
                color: white;
            }
            
            a:visited {
                /* Applies to all visited links */
                padding: 0px;
                text-decoration: none;
                color: white;
            } 
            
            a:hover   {
                /* Applies to links under the pointer */
                padding: 0px;
                text-decoration: none;
                color: white;
            }
            
            a:active  {
                /* Applies to activated links */
                padding: 0px;
                text-decoration: none;
                color: white;
            } 
            
            .reset-submit{
                width: 60% !important;
            }
        </style>
    </head>
    <body>
        <!-- start of header -->
        <div class="navbar-head container-fluid" width="100%">
            <table width="100%">
                <tr width="100%">
                    <br/>
                    <td align="left bottom" width="100%">
                        <br/>
                        <a href="http://www.abaccounting.com.sg/" class="dashboard-header" width="100%" cellpadding="0%">
                            <font size="13px" color="white">
                                &ensp;Abundant Accounting Pte Ltd
                            </font>
                        </a>
                        <br/>
                    </td>
                </tr>
            </table>
        </div>
        <!-- end of head -->
    </body>
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script src="js/jquery.min.js"></script>
    <script src='css/bootstrap.min.css' rel="stylesheet" type="text/css"/>
    <script src="js/bootstrap.min.js"></script>
</html>
