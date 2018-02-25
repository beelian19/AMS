<%-- 
    Document   : FinalDashboard
    Created on : Jan 3, 2018, 3:02:57 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Employee"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DAO.DashboardDAO"%>
<%@include file="Protect.jsp"%>
<%@include file="AdminAccessOnly.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <style>
            body {font-family: Arial;}


            /* Style the tab */
            .tab {
                overflow: hidden;
                border: 1px solid #F0F8FF;
                background-color: #f1f1f1;
            }

            /* Style the buttons inside the tab */
            .tablinks{
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 12px 14px;
                transition: 0.3s;
                font-size: 15px;
                font-weight: bold;
            }

            /* Change background color of buttons on hover */
            .tab a:hover {
                background-color: #ddd;
            }

            /* Create an active/current tablink class */
            .tab a:active {
                background-color: RGB(68, 114, 196);
                color: #ffffff;
            }

            .tab a:focus {
                background-color: RGB(68, 114, 196);
                color: #ffffff;
            }

            /* Style the tab content */
            .tabcontent {
                display: none;
                padding: auto;
                -webkit-animation: fadeEffect 1s;
                animation: fadeEffect 1s;
            }

            /* Fade in tabs */
            @-webkit-keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            @keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            /* Styling for month date fields in dashboard */
            .dashboardSelect{
                display:flex;
                flex-direction: column;
                position:relative;
                width:250px;
                height:30px;
                white-space: nowrap;
                color: #666;
            }

            .clientDashboard .employeeDashboard{
                padding:0 30px 0 10px;
                min-height:30px;
                display:flex;
                align-items:center;
                background:#333;
                position:absolute;
                top:0;
                width: 100%;
                transition:background .1s ease-in-out;
                box-sizing:border-box;
                overflow:hidden;
                white-space:nowrap;
                background-color: #666;
                color: white;
            }

            .clientDashboardOption .employeeDashboardOption{
                background-color: #666;
                color: white;
            }

            .dashboardSelect:focus .clientDashboardOption .employeeDashboardOption{
                position:relative;
                pointer-events:all;
            }
            /* end of styling for month date field in dashboard */

            /* this section is for the selecting charts and making the datatables appear*/
            #revenueTable {
                display:none;
                cursor:pointer;
            }
            #ProfitAndLossTable {
                display:none;
                cursor:pointer;
            }
            #ProjectsOverdueChartTable {
                display:none;
                cursor:pointer;
            }

            .activePerformanceChartAfter {
                box-shadow: 0px 0px 100px #000000;
                z-index: 2;
                -webkit-transition: all 100ms ease-in;
                -webkit-transform: scale(1.05);
                -ms-transition: all 100ms ease-in;
                -ms-transform: scale(1.05);   
                -moz-transition: all 100ms ease-in;
                -moz-transform: scale(1.05);
                transition: all 100ms ease-in;
                transform: scale(1.05);
            }

            .activePerformanceChartBefore {
                display:inline-block;
                border:0;
                position: relative;
                -webkit-transition: all 100ms ease-in;
                -webkit-transform: scale(1); 
                -ms-transition: all 100ms ease-in;
                -ms-transform: scale(1); 
                -moz-transition: all 100ms ease-in;
                -moz-transform: scale(1);
                transition: all 100ms ease-in;
                transform: scale(1);   
            }
            /* end of section */


            /* this section is to remove the underline from <a> */
            a:link{
                /* Applies to all unvisited links */
                text-decoration:  none !important;

            } 
            a:visited {
                /* Applies to all visited links */
                text-decoration:  none !important;
            } 
            a:hover   {
                /* Applies to links under the pointer */
                text-decoration:  none !important;
            } 
            a:active  {
                /* Applies to activated links */
                text-decoration:  none !important;
            } 
            /* end of section */
        </style>
        <%            DecimalFormat df = new DecimalFormat("#.00");
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        %>
        <script>

        </script>
    </head>
    <script src="js/Chart.min.js"></script>
    <script src="js/Chart.bundle.min.js"></script>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>Your Dashboard</h1><br/>
                    <center>
                        <div class="tab wrap" style="width: 80%">
                            <div class="nav nav-tabs" id="myTab">
                                <div style="float: right; width: 33.333%">
                                    <a class="tablinks btn-block button" href="#Client" onclick="onclickingheaders()" aria-controls="Client" role="tab" data-toggle="tab">Client</a>
                                </div>
                                <div style="float: right; width: 33.333%">
                                    <a class="tablinks btn-block button" href="#Employee" onclick="onclickingheaders()" aria-controls="Employee" role="tab" data-toggle="tab">Employee</a>
                                </div>
                                <div style="float: right; width: 33.333%">
                                    <a class="tablinks btn-block button" href="#Abundant" onclick="onclickingheaders()" aria-controls="Abundant" role="tab" data-toggle="tab">Abundant</a>
                                </div>
                            </div>
                        </div>
                    </center>
                </div>
                <div class="tab-content">
                    <div id="Abundant" class="tab-pane tabcontent container-fluid" style="text-align: center;">
                        <br/>
                        <div class="row">
                            <br/>
                            <div class="col-xs-9">
                            </div>
                            <div class="col-xs-3">
                                <div class="dashboardSelect">
                                    <select name="overallAbundantDashboardYear" class="clientDashboard" id="overallAbundantDashboardYear" onchange="overallAbundantDashboard()"required>
                                        <option class="clientDashboardOption" disabled selected value>-- Please Select Year --</option>
                                        <option class="clientDashboardOption" value="2014">2014</option>
                                        <option class="clientDashboardOption" value="2015">2015</option>
                                        <option class="clientDashboardOption" value="2016">2016</option>
                                        <option class="clientDashboardOption" value="2017">2017</option>
                                        <option class="clientDashboardOption" selected="selected" value="2018">2018</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-6">
                                <div class="row">
                                    <div class="col-xs-10 displayChartsTable" data-target="#revenueTable" style="text-align: center;" align="center;">
                                        <h2 align="center" style="text-align: center;">Revenue</h2>
                                        <canvas id="RevenueChart" align="center"></canvas>
                                    </div>
                                    <div class="col-xs-2">&nbsp;</div>
                                </div>
                            </div>
                            <div class="col-xs-4">
                                <div class="row">
                                    <div class="displayChartsTable" data-target="#ProfitAndLossTable" style="text-align: center;" align="center;">
                                        <h2>Profit & Loss</h2>
                                        <canvas id="ProfitAndLossChart" align="center"></canvas>
                                    </div>
                                    <br/><br/>
                                    <div class="displayChartsTable" data-target="#ProjectsOverdueChartTable" style="text-align: center;" align="center;">
                                        <h2>Project Undertaken</h2>
                                        <canvas id="ProjectsOverdueChart" align="center"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-1">&nbsp;</div>
                        </div>
                        <script>
                            $(document).ready(function () {
                                $('#datatable').DataTable();
                                $('#datatable2').DataTable();
                                $('#datatable3').DataTable();
                                $('#datatable4').DataTable();
                                $('#datatable5').DataTable();
                                $('#datatable6').DataTable();
                                $('#datatable7').DataTable();
                                $('#datatable8').DataTable();
                                overallAbundantDashboard();
                                showProjectTable();
                            });
                        </script>
                        <div class="row">
                            <br/>
                            <div class="col-xs-12 target" id="revenueTable" style="display:none">
                                <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                                    <h3>Revenue</h3>
                                    <table id='datatable4' align="center" style="text-align: left;">
                                        <thead>
                                            <tr>
                                                <th width="10.00%">Completion Date</th>
                                                <th width="10.00%">Company Name</th>
                                                <th width="10.00%">Project Name</th>
                                                <th width="10.00%">Hours Assigned</th>
                                                <th width="10.00%">Hours Actual</th>
                                                <th width="10.00%">Difference (%)</th>
                                                <th width="10.00%">Sales</th>
                                                <th width="10.00%">Total Actual Cost</th>
                                                <th width="10.00%">Profit/Loss</th>
                                                <th width="10.00%">Staff</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <script>
                                            function showProjectTable() {
                                                var yearChosen = document.getElementById('overallAbundantDashboardYear').value;
                                                if (yearChosen === null || yearChosen === "") {
                                                    now = new Date;
                                                    yearChosen = now.getYear();
                                                    if (yearChosen < 1900) {
                                                        yearChosen = yearChosen + 1900;
                                                    }
                                                }
                                                $.ajax({
                                                    url: 'GetOverAllAbundantProjectsTable',
                                                    data: 'year=' + yearChosen,
                                                    type: 'POST',
                                                    success: function (data) {
                                                        //console.log(data);
                                                    },
                                                    error: function () {
                                                        alert('Failed');
                                                    }
                                                });
                                            }
                                        </script>
                                        <%
                                            String test = "";
                                            if (request.getSession().getAttribute("test") == null) {
                                                test = "Hello";
                                            } else {
                                                test = (String) request.getSession().getAttribute("test");
                                            }

                                            System.out.println("Final Dashboard.jsp: " + test);

                                            ArrayList<Project> projectList = new ArrayList();
                                            if (request.getAttribute("projectsForTable") != null) {
                                                projectList = (ArrayList<Project>) request.getAttribute("projectsForTable");
                                            }
                                            if (projectList != null && !projectList.isEmpty()) {
                                                for (int i = 0; i < projectList.size(); i++) {
                                                    Project p = projectList.get(i);
                                                    double sales = ProjectDAO.getSales(p);
                                                    double totalActualCost = ProjectDAO.getTotalActualCost(p);
                                                    double profit = ProjectDAO.getProfit(p);
                                        %>
                                        <tr>
                                            <td>
                                                <%=sdf.format(p.getDateCompleted())%>
                                            </td>
                                            <td>
                                                <%=p.getCompanyName()%>
                                            </td>
                                            <td>
                                                <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                <a href=<%=profileUrl2%>>
                                                    <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                </a>
                                            </td>
                                            <td>
                                                <%=p.getPlannedHours()%>
                                            </td>
                                            <td>
                                                <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                            </td>
                                            <td>
                                                <%
                                                    out.println(df.format(((p.getEmployee1Hours() + p.getEmployee2Hours() - p.getPlannedHours()) / (p.getEmployee1Hours() + p.getEmployee2Hours())) * 100.00));
                                                %>  
                                            </td>
                                            <td>
                                                <%=sales%>
                                            </td>
                                            <td>
                                                <%=totalActualCost%>
                                            </td>
                                            <td>
                                                <% if (profit < 0) {
                                                %>
                                                <font color ="red"><%=profit%></font>
                                                <%} else {
                                                %>
                                                <%=profit%>
                                                <%
                                                    }
                                                %>
                                            </td>
                                            <td>
                                                <%=p.getEmployee1()%>
                                                <% if (!p.getEmployee2().toLowerCase().equals("na")) {
                                                        out.println(" and ");
                                                %>
                                                <%=p.getEmployee2()%>
                                                <%
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                        </tbody>
                                    </table>
                                    <br/>
                                </div>
                            </div>
                            <div class="col-xs-12 target" id="ProfitAndLossTable" style="display:none">
                                <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                                    <h3>Profit & Loss</h3>
                                    <table id='datatable5' align="center" style="text-align: left;">
                                        <thead>
                                            <tr>
                                                <th width="10.00%">Completion Date</th>
                                                <th width="10.00%">Company Name</th>
                                                <th width="10.00%">Project Name</th>
                                                <th width="10.00%">Hours Assigned</th>
                                                <th width="10.00%">Hours Actual</th>
                                                <th width="10.00%">Difference (%)</th>
                                                <th width="10.00%">Sales</th>
                                                <th width="10.00%">Total Actual Cost</th>
                                                <th width="10.00%">Profit/Loss</th>
                                                <th width="10.00%">Staff</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (projectList != null && !projectList.isEmpty()) {
                                                    for (int i = 0; i < projectList.size(); i++) {
                                                        Project p = projectList.get(i);
                                            %>
                                            <tr>
                                                <td>
                                                    <%=sdf.format(p.getDateCompleted())%>
                                                </td>
                                                <td>
                                                    <%=p.getCompanyName()%>
                                                </td>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href=<%=profileUrl2%>>
                                                        <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <%=p.getPlannedHours()%>
                                                </td>
                                                <td>
                                                    <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                </td>
                                                <td>
                                                    <%
                                                        out.println(df.format(((p.getEmployee1Hours() + p.getEmployee2Hours() - p.getPlannedHours()) / (p.getEmployee1Hours() + p.getEmployee2Hours())) * 100.00));
                                                    %>  
                                                </td>
                                                <td>
                                                    <%=ProjectDAO.getSales(p)%>
                                                </td>
                                                <td>
                                                    <%=ProjectDAO.getTotalActualCost(p)%>
                                                </td>
                                                <td>
                                                    <% if (ProjectDAO.getProfit(p) < 0) {
                                                    %>
                                                    <font color ="red"><%=ProjectDAO.getProfit(p)%></font>
                                                    <%} else {
                                                    %>
                                                    <%=ProjectDAO.getProfit(p)%>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                                <td>
                                                    <%=p.getEmployee1()%>
                                                    <% if (!p.getEmployee2().toLowerCase().equals("na")) {
                                                            out.println(" and ");
                                                    %>
                                                    <%=p.getEmployee2()%>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                    <br/>
                                </div>
                            </div>
                            <div class="col-xs-12 target" id="ProjectsOverdueChartTable" style="display:none">
                                <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                                    <h3>Projects Undertaken</h3>
                                    <table id='datatable6' align="center" style="text-align: left;">
                                        <thead>
                                            <tr>
                                                <th width="16.67%">Completion Date</th>
                                                <th width="16.67%">Company Name</th>
                                                <th width="16.67%">Project Name</th>
                                                <th width="16.67%">Hours Assigned</th>
                                                <th width="16.67%">Hours Actual</th>
                                                <th width="16.67%">Staff </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (projectList != null && !projectList.isEmpty()) {
                                                    for (int i = 0; i < projectList.size(); i++) {
                                                        Project p = projectList.get(i);
                                            %>
                                            <tr>
                                                <td>
                                                    <%=sdf.format(p.getDateCompleted())%>
                                                </td>
                                                <td>
                                                    <%=p.getCompanyName()%>
                                                </td>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href=<%=profileUrl2%>>
                                                        <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <%=p.getPlannedHours()%>
                                                </td>
                                                <td>
                                                    <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                </td>
                                                <td>
                                                    <%=p.getEmployee1()%>
                                                    <% if (!p.getEmployee2().toLowerCase().equals("na")) {
                                                            out.println(" and ");
                                                    %>
                                                    <%=p.getEmployee2()%>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                    <br/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ############################################### THIS PORTION IS FOR CLIENT PERFORMANCE ######################################################################-->
                    <div id="Client" class="tab-pane tabcontent container-fluid" style="text-align: center;">
                        <%
                            ArrayList<Client> clientList = new ArrayList<>();
                            clientList = ClientDAO.getAllClient();
                            // Checks if clientlist is null or isempty
                            if (clientList != null && !clientList.isEmpty()) {
                        %>   
                        <div class="container-fluid clientDatatableDiv" style="text-align: center; width:80%; height:80%;">
                            <form>
                                <div class="row">
                                    <br/>
                                    <div class="col-xs-9">
                                    </div>
                                    <div class="col-xs-3">
                                        <div class="dashboardSelect">
                                            <select name="clientDashboardYear" class="clientDashboard" id="clientDashboardYear" required>
                                                <option class="clientDashboardOption" disabled selected value>-- Please Select Year --</option>
                                                <option class="clientDashboardOption" value="2014">2014</option>
                                                <option class="clientDashboardOption" value="2015">2015</option>
                                                <option class="clientDashboardOption" value="2016">2016</option>
                                                <option class="clientDashboardOption" value="2017">2017</option>
                                                <option class="clientDashboardOption" value="2018">2018</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <table id='datatable' align="center">
                                    <thead>
                                        <tr>
                                            <th width="10.0%">Client ID</th>
                                            <th width="25.0%">Business Type</th>
                                            <th width="25.0%">Company Name</th>
                                            <th width="40.0%"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (int i = 0; i < clientList.size(); i++) {
                                        %>
                                        <tr style="text-align: left;">
                                            <td width="10.0%">
                                                <%=clientList.get(i).getClientID()%>
                                            </td>
                                            <td width="25.0%">
                                                <%=clientList.get(i).getBusinessType()%>
                                            </td>
                                            <td width="25.0%">
                                                <%=clientList.get(i).getCompanyName()%>
                                            </td>
                                            <td width="40.0%" align="right">
                                                <input type="radio" name="client" id="client" value='<%=clientList.get(i).getClientID()%>' required>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    <br/><br/>
                                    </tbody>
                                </table>
                                <p style="text-align: left;"> *all data are updated as of this month</p>
                                <table style="width: 100%" align="right">
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 61%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 16.167%">
                                            <button class="btn btn-lg btn-primary btn-block" type="reset">Reset</button>
                                        </td>
                                        <td style="width: 1%">
                                            &nbsp;
                                        </td>
                                        </form>
                                        <td style="width: 16.167%">
                                            <button id="btnViewClientPerformance" class="btn btn-lg btn-primary btn-block btn-success" type="button">View Performance</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                </table>
                        </div>
                        <%
                            }
                        %>
                        <div id="clientPerformance" class="clientChartsDiv container-fluid" style="text-align: center; display: none;">
                            <br/>
                            <div class="row">
                                <div class="col-xs-1">&nbsp;</div>
                                <div class="col-xs-5" style="text-align: center;" align="center;">
                                    <h2>Profit & Loss</h2>
                                    <canvas id="clientProfitAndLossChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                                </div>
                                <div class="col-xs-1">&nbsp;</div>
                                <div class="col-xs-5" style="text-align: center;" align="center;">
                                    <h2>Project Overview</h2>
                                    <canvas id="clientOverdueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                                </div>
                            </div>
                            <div class="row">
                                <br/><br/>
                                <table style="width: 100%; position: relative; bottom: 0px;">
                                    <tr>
                                        <td style="width: 61%">
                                            <br/>
                                        </td>
                                        <td style="width: 16.167%">
                                            <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="backToClientDatatable()">Back</button>
                                        </td>
                                        <td style="width: 1%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 16.167%">
                                            <%
                                                if (request.getSession().getAttribute("clientID") != null) {

                                                    String clientProfileUrl = "ClientProfile.jsp?profileId=" + (String) request.getSession().getAttribute("clientID");
                                            %>
                                            <button class="btn btn-lg btn-primary btn-block" onclick="window.location = '<%=clientProfileUrl%>';">Go to Profile</button>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td style="width: 5.666%">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- ############################################### END OF CLIENT PERFORMANCE SECTION ###################################################-->                    

                    <!-- ############################################### START OF EMPLOYEE PERFORMANCE SECTION ###############################################-->
                    <div id="Employee" class="tab-pane tabcontent container-fluid" style="text-align: center;">
                        <%
                            ArrayList<Employee> employeeList = EmployeeDAO.getAllEmployees();
                            // check if employeelist is null or empty
                            if (employeeList != null && !employeeList.isEmpty()) {
                        %>
                        <div class="employeeDatatableDiv container-fluid" style="text-align: center; width:80%; height:80%;">
                            <form>
                                <div class="row">
                                    <br/>
                                    <div class="col-xs-9">
                                    </div>
                                    <div class="col-xs-3">
                                        <div class="dashboardSelect">
                                            <select name="employeeDashboardYear" class="employeeDashboard" id="employeeDashboardYear" required>
                                                <option class="employeeDashboardOption" disabled selected value>-- Please Select Year --</option>
                                                <option class="employeeDashboardOption" value="2014">2014</option>
                                                <option class="employeeDashboardOption" value="2015">2015</option>
                                                <option class="employeeDashboardOption" value="2016">2016</option>
                                                <option class="employeeDashboardOption" value="2017">2017</option>
                                                <option class="employeeDashboardOption" value="2018">2018</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <table id='datatable2' align="center">
                                    <thead>
                                        <tr>
                                            <th width="16.67%">Name</th>
                                            <th width="16.67%">Position</th>
                                            <th width="16.67%">Email</th>
                                            <th width="16.67%">Number</th>
                                            <th width="16.67%">Admin Access</th>
                                            <th width="16.67%"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (int i = 0; i < employeeList.size(); i++) {
                                        %>
                                        <tr style="text-align: left;">
                                            <td width="16.67%">
                                                <%=employeeList.get(i).getName()%>
                                            </td>
                                            <td width="16.67%">
                                                <%=employeeList.get(i).getPosition()%>
                                            </td>
                                            <td width="16.67%">
                                                <%=employeeList.get(i).getEmail()%>
                                            </td>
                                            <td width="16.67%">
                                                <%=employeeList.get(i).getNumber()%>
                                            </td>
                                            <td width="16.67%">
                                                <%=employeeList.get(i).getIsAdmin()%>
                                            </td>
                                            <td width="16.67%" align="center">
                                                <input type="radio" name="empName" id='empName' value='<%=employeeList.get(i).getName()%>' required>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    <br/><br/>
                                    </tbody>
                                </table>
                                <table style="width: 100%; position: relative; bottom: 0px;">
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 61%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 16.167%">
                                            <button class="btn btn-lg btn-primary btn-block" type="reset">Reset</button>
                                        </td>
                                        <td style="width: 1%">
                                            &nbsp;
                                        </td>
                                        </form>
                                        <td style="width: 16.167%">
                                            <button id='btnViewEmpPerformance' class="btn btn-lg btn-primary btn-block btn-success" type="button">View Performance</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                </table>
                        </div>
                        <%
                            }
                        %>
                        <div class="container-fluid employeeChartsDiv" style="text-align: center; display: none;">
                            <br/>
                            <div class="row">
                                <div class="col-xs-1">&nbsp;</div>
                                <div class="col-xs-5" style="text-align: center;" align="center;">
                                    <h2>Projects Undertaken</h2>
                                    <canvas id="employeeRevenueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                                </div>
                                <div class="col-xs-1">&nbsp;</div>
                                <div class="col-xs-5" style="text-align: center;" align="center;">
                                    <h2>Hours Spent</h2>
                                    <canvas id="employeeProfitAndLossChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                                </div>
                            </div>
                            <div class="row">
                                <br/><br/>
                                <div class="col-xs-12" id="employeeProjectOverdueTable">
                                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                                        <table id='datatable8' align="center" style="text-align: left;">
                                            <thead>
                                                <tr>
                                                    <th width="16.66%">Company Name</th>
                                                    <th width="16.66%">Project Name</th>
                                                    <th width="16.66%">Hours Assigned</th>
                                                    <th width="16.66%">Hours Actual</th>
                                                    <th width="16.66%">Difference</th>
                                                    <th width="16.66%">Cost</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    ArrayList<Project> employeeProjectList = (ArrayList<Project>) request.getSession().getAttribute("staffProjectList");
                                                    //ArrayList<Project> employeeProjectList = new ArrayList();
                                                    if (employeeProjectList != null && !employeeProjectList.isEmpty()) {
                                                        for (int i = 0; i < employeeProjectList.size(); i++) {
                                                            Project p = employeeProjectList.get(i);
                                                %>
                                                <tr>
                                                    <td>
                                                        <%=p.getCompanyName()%>
                                                    </td>
                                                    <td>
                                                        <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                        <a href=<%=profileUrl2%>>
                                                            <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <%=p.getPlannedHours()%>
                                                    </td>
                                                    <td>
                                                        <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                    </td>
                                                    <td>
                                                        <%=p.getPlannedHours() - p.getEmployee1Hours() - p.getEmployee2Hours()%>
                                                    </td>
                                                    <td>
                                                        <%=ProjectDAO.getTotalActualCost(p)%>
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                        <br/>
                                    </div>
                                </div>
                                <br/><br/>
                            </div>
                            <div class="row">
                                <table style="width: 100%; position: relative; bottom: 0px;">
                                    <tr>
                                        <td style="width: 61%">
                                            <br/>
                                        </td>
                                        <td style="width: 16.167%">
                                            <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="backToEmployeeDatatable()">Back</button>
                                        </td>
                                        <td style="width: 1%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 16.167%">
                                            <%
                                                if (request.getSession().getAttribute("empName") != null) {
                                                    String employeeName = (String) request.getSession().getAttribute("empName");
                                                    String employeeProfileUrl = "EmployeeProfile.jsp?profileName=" + employeeName.toLowerCase();

                                            %>
                                            <button class="btn btn-lg btn-primary btn-block" onclick="window.location = '<%=employeeProfileUrl%>';">Go to Profile</button>
                                            <%
                                                }
                                            %>
                                        </td>
                                        <td style="width: 5.666%">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </div>

                    <!-- ############################################### END OF EMPLOYEE PERFORMANCE SECTION ###############################################-->
                </div>
            </div>
        </div>
    </nav>
    <script>
        Chart.defaults.global.tooltipYPadding = 16;
        Chart.defaults.global.tooltipCornerRadius = 0;
        Chart.defaults.global.tooltipTitleFontStyle = "normal";
        Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
        Chart.defaults.global.animationEasing = "easeInOutElastic";
        Chart.defaults.global.responsive = false;
        function overallAbundantDashboard() {
            var yearChosen = document.getElementById('overallAbundantDashboardYear').value;
            if (yearChosen === null || yearChosen === "") {
                now = new Date;
                yearChosen = now.getYear();
                if (yearChosen < 1900) {
                    yearChosen = yearChosen + 1900;
                }
            }

            var canvas = document.getElementsByTagName('canvas')[0];
            canvas.width = 550;
            canvas.height = 600;
            var canvas = document.getElementsByTagName('canvas')[1];
            canvas.width = 475;
            canvas.height = 250;
            var canvas = document.getElementsByTagName('canvas')[2];
            canvas.width = 475;
            canvas.height = 250;
            //console.log("Year Chosen: " + yearChosen);
            var sales = new Array(12);
            var cost = new Array(12);
            var profit = new Array(12);
            var overdue = new Array(12);
            var ontime = new Array(12);
            var completed = new Array(12);
            var totalCompletedProjects = new Array(12);
            var profitableProjects = new Array(12);
            var lossProjects = new Array(12);
            $.ajax({
                url: 'SalesGraph',
                data: 'year=' + yearChosen,
                type: 'POST',
                success: function (data) {
                    var jsonData = $.parseJSON(data);
                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[0][i];
                        sales[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[1][i];
                        cost[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[2][i];
                        profit[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[3][i];
                        overdue[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[4][i];
                        ontime[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[5][i];
                        completed[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[6][i];
                        totalCompletedProjects[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[7][i];
                        profitableProjects[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[8][i];
                        lossProjects[i] = data;
                    }
                    var lineChartData = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [
                            {
                                label: 'Revenue',
                                fillColor: 'rgba(153, 102, 255, 0.3)',
                                strokeColor: 'rgba(153, 102, 255, 1)',
                                pointColor: 'rgba(153, 102, 255, 1)',
                                data: sales,
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: 'Profit',
                                fillColor: 'rgba(255, 99, 132, 0.3)',
                                strokeColor: 'rgba(220,180,0,1)',
                                pointColor: 'rgba(220,180,0,1)',
                                data: profit,
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255,99,132,0.3)'
                                ],
                                borderWidth: 1
                            }, {
                                label: 'Cost',
                                fillColor: 'rgba(54, 162, 235, 0.3)',
                                strokeColor: 'rgba(54, 162, 235, 1)',
                                pointColor: 'rgba(54, 162, 235, 1)',
                                data: cost,
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                            }
                        ]
                    }
                    var barChartData = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Projects',
                                data: totalCompletedProjects,
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Profits',
                                data: profitableProjects,
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ], fillColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Losses',
                                data: lossProjects,
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    }
                    var barChartData1 = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Projects',
                                data: completed, //[12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Projects On Time',
                                data: ontime, //[1, 3, 4, 5, 2, 3, 1, 3, 4, 5, 2, 3],
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ], fillColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Overdue Projects',
                                data: overdue, //[12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    }
                    var ctx = document.getElementById("RevenueChart").getContext("2d");
                    var ctx1 = document.getElementById("ProfitAndLossChart").getContext("2d");
                    var ctx2 = document.getElementById("ProjectsOverdueChart").getContext("2d");

                    if (RevenueChart)
                        window.myChart.destroy();
                    if (ProfitAndLossChart)
                        window.myChart.destroy();
                    if (ProjectsOverdueChart)
                        window.myChart.destroy();

                    var RevenueChart = new Chart(ctx, {
                        type: 'line',
                        data: lineChartData,
                        pointDotRadius: 5,
                        bezierCurve: false,
                        scaleShowVerticalLines: false
                    });
                    var ProfitAndLossChart = new Chart(ctx1, {
                        type: 'bar',
                        data: barChartData,
                        scaleShowVerticalLines: false
                    });
                    var ProjectsOverdueChart = new Chart(ctx2, {
                        type: 'bar',
                        data: barChartData1,
                        scaleShowVerticalLines: false
                    });
                },
                error: function (data) {
                    console.log("Error: " + data);
                }
            });
        }
        $('#btnViewClientPerformance').click(function () {
            var year = document.getElementById('clientDashboardYear').value;
            var clientID = $('input[name=client]:checked').val();
            var clientYearProfit = new Array(12);
            var clientYearLoss = new Array(12);
            var clientOverdueProject = new Array(12);
            var clientOnTimeProject = new Array(12);
            var canvas = document.getElementsByTagName('canvas')[0];
            canvas.width = 500;
            canvas.height = 250;
            var canvas = document.getElementsByTagName('canvas')[1];
            canvas.width = 500;
            canvas.height = 250;
            $.ajax({
                url: 'ClientDashboard',
                data: 'clientID=' + clientID + '&' + 'year=' + year,
                type: 'POST',
                success: function (data) {
                    var jsonData = $.parseJSON(data);
                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[0][i];
                        clientOverdueProject[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[1][i];
                        clientOnTimeProject[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[2][i];
                        clientYearProfit[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[3][i];
                        clientYearLoss[i] = data;
                    }

                    //this is to tell if we should display the charts!!
                    var displayClientCharts = true;
                    var clientDatatable;
                    clientDatatable = document.getElementsByClassName("clientDatatableDiv");
                    clientDatatable[0].style.display = "none";
                    clientDatatable = document.getElementsByClassName("clientChartsDiv");
                    clientDatatable[0].style.display = "block";
                    var barChartData = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Profits',
                                data: clientYearProfit, //[12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Losses',
                                data: clientYearLoss, //[1, 13, 5, 2, 9, 1, 1, 13, 5, 2, 9, 1],
                                backgroundColor: [
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    }

                    Chart.defaults.global.tooltipCornerRadius = 0;
                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                    Chart.defaults.global.responsive = false;
                    var ctx = document.getElementById("clientProfitAndLossChart").getContext("2d");
                    var clientProfitAndLossChart = new Chart(ctx, {
                        type: 'bar',
                        data: barChartData,
                        scaleShowVerticalLines: false
                    });
                    var barChartData = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Punctual Projects',
                                data: clientOnTimeProject,
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Overdue Projects',
                                data: clientOverdueProject,
                                backgroundColor: [
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)',
                                    'rgba(255, 206, 86, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    }

                    Chart.defaults.global.tooltipCornerRadius = 0;
                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                    Chart.defaults.global.responsive = false;
                    var ctx = document.getElementById("clientOverdueChart").getContext("2d");
                    var clientProfitAndLossChart = new Chart(ctx, {
                        type: 'bar',
                        data: barChartData,
                        scaleShowVerticalLines: false
                    });
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(thrownError);
                }
            });
        });
        $('#btnViewEmpPerformance').click(function () {
            var employeeDashboardYear = document.getElementById('employeeDashboardYear').value;
            var empName = $('input[name=empName]:checked').val();
            var employeeOverdue = new Array(12);
            var employeeTimeExceed = new Array(12);
            var completedProjects = new Array(12);            
            var canvas = document.getElementsByTagName('canvas')[0];
            canvas.width = 500;
            canvas.height = 250;
            var canvas = document.getElementsByTagName('canvas')[1];
            canvas.width = 500;
            canvas.height = 250;
            $.ajax({
                url: 'StaffMonthlyReport',
                data: 'employeeName=' + empName + '&' + 'Year=' + employeeDashboardYear,
                type: 'POST',
                success: function (data) {
                    var jsonData = $.parseJSON(data);
                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[0][i];
                        employeeOverdue[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[1][i];
                        employeeTimeExceed[i] = data;
                    }

                    for (var i = 0; i < 12; i++) {
                        var data = jsonData[2][i];
                        completedProjects[i] = data;
                    }
                    var displayEmployeeCharts = true;
                    var employeeDatatable;
                    employeeDatatable = document.getElementsByClassName("employeeDatatableDiv");
                    employeeDatatable[0].style.display = "none";
                    employeeDatatable = document.getElementsByClassName("employeeChartsDiv");
                    employeeDatatable[0].style.display = "block";
                    var barChartData = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Projects',
                                data: completedProjects,
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Projects on TIme',
                                data: employeeTimeExceed,
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ], fillColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of projects Overdue',
                                data: employeeOverdue,
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    };
                    Chart.defaults.global.tooltipYPadding = 16;
                    Chart.defaults.global.tooltipCornerRadius = 0;
                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                    Chart.defaults.global.responsive = false;
                    var ctx = document.getElementById("employeeRevenueChart").getContext("2d");
                    var RevenueChart = new Chart(ctx, {
                        type: 'bar',
                        data: barChartData,
                        pointDotRadius: 5,
                        bezierCurve: false,
                        scaleShowVerticalLines: false
                    });
                    var barChartData2 = {
                        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                        datasets: [{
                                label: '# of Projects',
                                data: completedProjects,
                                backgroundColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)',
                                    'rgba(153, 102, 255, 0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of Projects on TIme',
                                data: employeeTimeExceed,
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ], fillColor: [
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)',
                                    'rgba(255, 99, 132, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)',
                                    'rgba(255,99,132,0.3)'
                                ],
                                borderWidth: 1
                            },
                            {
                                label: '# of projects Overdue',
                                data: employeeOverdue,
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                fillColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)',
                                    'rgba(54, 162, 235, 0.3)'
                                ],
                                borderWidth: 1
                            }
                        ]
                    };
                    Chart.defaults.global.tooltipYPadding = 16;
                    Chart.defaults.global.tooltipCornerRadius = 0;
                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                    Chart.defaults.global.responsive = false;
                    var ctx = document.getElementById("employeeProfitAndLossChart").getContext("2d");
                    var employeeProfitAndLossChart = new Chart(ctx, {
                        type: 'line',
                        data: barChartData2,
                        pointDotRadius: 5,
                        bezierCurve: false,
                        scaleShowVerticalLines: false
                    });
                },
                error: function () {
                    alert("Employee Error");
                }
            });
        });
        // this area is to remove and add data for each charts
        function removeData(chart) {
            chart.data.labels.pop();
            for (var i = 0; i < chart.data.datasets.length; i++) {
                dataset.data.pop();
            }
            chart.update();
        }

        function addData(chart, label, data) {
            chart.data.labels.push(label);
            for (var i = 0; i < chart.data.datasets.length; i++) {
                dataset.data.push(data);
            }
            chart.update();
        }
        // end of this section


        // this is for collapsing and hiding the tables
        $(function () {
            $('.displayChartsTable').on('click', function () {
                var $this = $(this);
                var thisDataTarget = $this.attr("data-target");
                var chartsDiv = document.getElementsByClassName("displayChartsTable");
                var dataTargetOfAllChart;
                for (var i = 0; i < chartsDiv.length; i++) {
                    currChart = document.getElementsByClassName("displayChartsTable")[i]
                    currDataTarget = currChart.getAttribute("data-target");
                    console.log(currDataTarget);
                    if (thisDataTarget === currDataTarget) {
                        if ($('.displayChartsTable').hasClass("activePerformanceChartBefore") || !$('.displayChartsTable').hasClass("activePerformanceChartAfter")) {
                            $('.displayChartsTable').removeClass("activePerformanceChartBefore");
                            $this.addClass("activePerformanceChartAfter");
                            // Use the id in the data-target attribute
                            $target = $($this.data('target'));
                            $(".target").not($target).fadeOut();
                            $target.toggle();
                            $('html,body').animate({
                                scrollTop: $target.offset().top},
                                    'fast');
                        } else {
                            $this.removeClass("activePerformanceChartAfter");
                            $this.addClass("activePerformanceChartBefore");
                            // Use the id in the data-target attribute
                            $target = $($this.data('target'));
                            $(".target").not($target).fadeOut();
                            $target.toggle();
                            $('html,body').animate({
                                scrollTop: $target.offset().top},
                                    'fast');
                        }
                    } else {
                        $currentElement = $(currChart)
                        if ($currentElement.hasClass("activePerformanceChartAfter") || $currentElement.hasClass("activePerformanceChartBefore")) {
                            $currentElement.removeClass("activePerformanceChartAfter");
                            $currentElement.addClass("activePerformanceChartBefore");
                        }
                    }
                }
            });
        });
        //this is for when user clicks on the 3 tabs, it'll straight away force the client and employee divs back to display datatable list
        function onclickingheaders() {
            var clientChartDiv, employeeChartDiv, clientDatatableDiv, employeeDatatableDiv;
            clientChartDiv = document.getElementsByClassName("clientChartsDiv");
            employeeChartDiv = document.getElementsByClassName("employeeChartsDiv");
            clientDatatableDiv = document.getElementsByClassName("clientDatatableDiv");
            employeeDatatableDiv = document.getElementsByClassName("employeeDatatableDiv");
            clientChartDiv[0].style.display = "none";
            employeeChartDiv[0].style.display = "none";
            clientDatatableDiv[0].style.display = "block";
            employeeDatatableDiv[0].style.display = "block";
        }
        //this is for hiding chart table and displaying datatable list when user clicks back button
        function backToClientDatatable() {
            var clientChartDiv, employeeChartDiv, clientDatatableDiv, employeeDatatableDiv;
            clientChartDiv = document.getElementsByClassName("clientChartsDiv");
            employeeChartDiv = document.getElementsByClassName("employeeChartsDiv");
            clientDatatableDiv = document.getElementsByClassName("clientDatatableDiv");
            employeeDatatableDiv = document.getElementsByClassName("employeeDatatableDiv");
            clientChartDiv[0].style.display = "none";
            employeeChartDiv[0].style.display = "none";
            clientDatatableDiv[0].style.display = "block";
            employeeDatatableDiv[0].style.display = "block";
        }
        //this is for hiding chart table and displaying datatable list when user clicks back button
        function backToEmployeeDatatable() {
            var clientChartDiv, employeeChartDiv, clientDatatableDiv, employeeDatatableDiv;
            clientChartDiv = document.getElementsByClassName("clientChartsDiv");
            employeeChartDiv = document.getElementsByClassName("employeeChartsDiv");
            clientDatatableDiv = document.getElementsByClassName("clientDatatableDiv");
            employeeDatatableDiv = document.getElementsByClassName("employeeDatatableDiv");
            clientChartDiv[0].style.display = "none";
            employeeChartDiv[0].style.display = "none";
            clientDatatableDiv[0].style.display = "block";
            employeeDatatableDiv[0].style.display = "block";
        }
        //this is for opening the tab that was opened before the page refreshed
        $(function () {
            $('a[data-toggle="tab"]').on("click", function (e) {
                window.localStorage.setItem("activeTab", $(e.target).attr("href"));
            });
            var activeTab = window.localStorage.getItem("activeTab");
            if (activeTab) {
                $('#myTab a[href="' + activeTab + '"]').tab("show");
                window.localStorage.removeItem("activeTab");
            }
        });
    </script>
</body>
<jsp:include page="Footer.html"/>
</html>