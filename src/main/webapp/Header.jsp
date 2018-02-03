<%-- 
    Document   : HeaderTest
    Created on : Oct 27, 2017, 2:54:45 PM
    Author     : Bernitatowyg
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                color: black;
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

            .body{
                padding-bottom: 20% !important;
            }

            footer{
                position: relative;
                bottom:0;
                left:0;
                right:0;
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

            .profile-img-card {
                width: 96px;
                height: 96px;
                margin: 0 auto 10px;
                display: block;
                -moz-border-radius: 50%;
                -webkit-border-radius: 50%;
                border-radius: 50%;
            }

            .body {
                overflow: scroll;
                margin: 0;
                padding: 0;
            }

            .navbar-profile-page{
                width: 60%;
                overflow: scroll;
            }

            #myTable {
                border-collapse: collapse;
                width: 80%;
                border-bottom: 1px solid #ddd;
                border-top: 1px solid #ddd;
                font-size: 18px;
                text-align: center;
                position: relative;
                margin: auto;
            }

            #myTable th, #myTable td {
                text-align: left;
                padding: 5px;
            }

            #myTable tr {
                border-bottom: 1px solid #ddd;
            }

            #myTable tr.header, #myTable tr:hover {
                background-color: #f1f1f1;
            }

            input[placeholder]{
                border-left: 10px;
            }

            label, input { display:block;}
            input.text { margin-bottom:12px; width:95%; padding: .4em; }
            fieldset { padding:0; border:0; margin-top:25px; }
            h1 { font-size: 1.2em; margin: .6em 0; }
            div#users-contain { width: 350px; margin: 20px 0; }
            div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
            div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
            .ui-dialog .ui-state-error { padding: .3em; }
            .validateTips { border: 1px solid transparent; padding: 0.3em; }
            .vertical-alignment-helper {
                display:table;
                height: 100%;
                width: 100%;
                pointer-events:none; /* This makes sure that we can still click outside of the modal to close it */
            }
            .vertical-align-center {
                /* To center vertically */
                display: table-cell;
                vertical-align: middle;
                pointer-events:none;
            }
            modal-content {
                /* Bootstrap sets the size of the modal in the modal-dialog class, we need to inherit it */
                width:inherit;
                max-width:inherit; /* For Bootstrap 4 - to avoid the modal window stretching full width */
                height:inherit;
                /* To center horizontally */
                margin: 0 auto;
                pointer-events: all;
            }

            #topBtn {
                display: none;
                position: fixed;
                bottom: 20px;
                right: 30px;
                z-index: 99;
                border: none;
                outline: none;
                background-color: grey;
                color: white;
                cursor: pointer;
                padding: 15px;
            }

            #topBtn:hover {
                background-color: #555;
            }

            #topBtn:hover span {display:none}

            #topBtn:hover:before {
                content:"Back To Top"
            }
        </style>

        <script type="text/javascript">
            function numbersonly(e) {
                var unicode = e.charCode ? e.charCode : e.keyCode;
                if (unicode !== 8) {
                    //if the key isn't the backspace key (which we should allow)
                    if (unicode < 48 || unicode > 57) { //if not a number
                        return false //disable key press
                    }
                }
            }

            function limitlength(obj, length) {
                var maxlength = length;
                if (obj.value.length > maxlength) {
                    obj.value = obj.value.substring(0, maxlength);
                }
            }
        </script>
        <link href="css/bootstrap-theme.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link href="css/fullcalendar.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

        <script src="js/jquery.min.js"></script>
        <script src='css/bootstrap.min.css' rel="stylesheet" type="text/css"></script>
        <script src="js/bootstrap.min.js"></script>

        <script src='js/moment.min.js'></script>
        <script src='js/fullcalendar.min.js'></script>

    </head>
    <body width="100%" cellpadding="0%">
        <%
            String empId = (String) session.getAttribute("userId");
            String employeeName = (String) session.getAttribute("employeeName");
            String sessionUserIsAdmin = (String) session.getAttribute("sessionUserIsAdmin");
            if (empId == null) {
                empId = "0";
            }
            if (employeeName == null) {
                employeeName = "no user";
            }
            if (sessionUserIsAdmin == null) {
                sessionUserIsAdmin = "no";
            }
        %>
        <!-- start of header -->
        <button onclick="backToTopFunction()" id="topBtn">
            <span>Top</span>
        </button>
        <div class="navbar-head container-fluid" width="100%">
            <table width="100%">
                <tr width="100%">
                <br/>
                <td align="left bottom" width="100%">
                    <br/>
                    <a href="http://www.abaccounting.com.sg/" class="dashboard-header" width="100%" cellpadding="0%">
                        <font size="13px" color="white">
                        &emsp;Abundant Accounting Pte Ltd
                        </font>
                    </a>
                    <br/>
                </td>
                <td align="right bottom">
                    <table width="100%">
                        <br/>
                        <br/>
                        <tr>
                            <td align="right bottom">
                                <% if (sessionUserIsAdmin.equals("no")) {
                                %>
                                <a href="EmployeeHome.jsp" class="dashboard-header">
                                    <table>
                                        <tr>
                                            <td>
                                                <i class="material-icons white">home</i>
                                            </td>
                                            <td>
                                                <font color="white" size="4.5px">Home&ensp;</font> 
                                            </td>
                                        </tr>
                                    </table>
                                </a>
                                <%} else {%>
                                <a href="AdminHome.jsp" class="dashboard-header">
                                    <table>
                                        <tr>
                                            <td>
                                                <i class="material-icons white">home</i>
                                            </td>
                                            <td>
                                                <font color="white" size="4.5px">Home&ensp;</font> 
                                            </td>
                                        </tr>
                                    </table>
                                </a>
                                <%}%>
                            </td>
                            <td>
                                <a href="EmployeeProfile.jsp" class="dashboard-header">
                                    <table>
                                        <tr>
                                            <td>
                                                <i class="material-icons white">person</i>
                                            </td>
                                            <td style="white-space: nowrap">
                                                <font color="white" size="4.5px"><%=employeeName%>&ensp;</font> 
                                            </td>
                                        </tr>
                                    </table>
                                </a>
                            </td>
                            <td>
                                <a href="LogoutProcess" class="dashboard-header">
                                    <table>
                                        <tr>
                                            <td>
                                                <i class="material-icons white">exit_to_app</i>
                                            </td>
                                            <td nowrap>
                                                <font color="white" size="4.5px">Log Out&ensp;</font> 
                                            </td>
                                        </tr>
                                    </table>
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                </tr>
            </table>
        </div>
        <!-- end of head -->
        <!-- start of neck -->
        <div class="navbar-neck container-fluid" width="100%">
            <table align="right" class="container-fluid">
                <tr>
                    <td>
                        <%
                            if (sessionUserIsAdmin.equals("yes")) {
                        %> 
                        <a href="FinalDashboard.jsp" class="btn btn-default btn-lg neck-button black">Dashboard &emsp;</a>
                        <%} else {
                        %>
                        <a href="Dashboard.jsp" class="btn btn-default btn-lg neck-button black">Dashboard &emsp;</a>
                        <%}%>
                    </td>
                    <td>
                        <div class="dropdown">
                            <button class="btn btn-default btn-lg dropdown-toggle neck-button black" type="button" data-toggle="dropdown" data-hover="dropdown">
                                Upload Expense &emsp;
                                <i class="fa fa-caret-down" style='color: black;'></i>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="UploadExpense.jsp">QuickBooks</a></li>
                                <li><a href="TokenOverview.jsp">Tokens</a></li>
                            </ul>
                        </div>
                    </td>
                    <%
                        if (sessionUserIsAdmin.equals("yes")) {
                    %>
                    <td>
                        <div class="dropdown">
                            <button class="btn btn-default btn-lg dropdown-toggle neck-button black" type="button" data-toggle="dropdown" data-hover="dropdown">
                                Manage Projects &emsp;
                                <i class="fa fa-caret-down" style='color: black;'></i>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="ProjectAdminOverview.jsp">View All Projects</a></li>
                                    <%
                                        if (sessionUserIsAdmin.equals("yes")) {
                                    %> 
                                <li><a href="CreateAdHocProject.jsp">Create Ad Hoc Project</a></li>
                                    <%
                                        }
                                    %>
                            </ul>
                        </div>
                    </td>
                    <%
                        }
                    %>
                    <td>
                        <div class="dropdown">
                            <button class="btn btn-default btn-lg dropdown-toggle neck-button black" type="button" data-toggle="dropdown" data-hover="dropdown">
                                Manage Resources &emsp;
                                <i class="fa fa-caret-down" style='color: black;'></i>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="CreateClient.jsp">Add New Client</a></li>
                                <li><a href="ClientOverview.jsp">View All Clients</a></li>
                                    <%
                                        if (sessionUserIsAdmin.equals("yes")) {
                                    %> 
                                <li><a href="CreateUser.jsp">Add New Employee</a></li>
                                <li><a href="EmployeeOverview.jsp">View All Employees</a></li>
                                    <%
                                        }
                                    %>
                            </ul>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <br/>
        <!-- end of neck -->
    </body>
    <jsp:include page="Footer.html"/>
</html>