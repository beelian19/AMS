<%-- 
    Document   : FinalDashboard
    Created on : Jan 3, 2018, 3:02:57 PM
    Author     : Bernitatowyg
--%>

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
            .tab button {
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 14px 16px;
                transition: 0.3s;
                font-size: 15px;
                font-weight: bold;
            }

            /* Change background color of buttons on hover */
            .tab button:hover {
                background-color: #ddd;
            }

            /* Create an active/current tablink class */
            .tab button.active {
                background-color: RGB(68, 114, 196);
                color: #ffffff;
                font-weight: bold;
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

            .dashboardSelect {
                display:flex;
                flex-direction: column;
                position:relative;
                width:250px;
                height:30px;
                white-space: nowrap;
                background-color: #666;
            }

            .clientDashboard{
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

            .clientDashboardOption{
                background-color: #666;
                color: white;
            }

            .dashboardSelect:focus .clientDashboardOption {
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
            .activePerformanceChart {
                border: 2px solid blue;
            }
            /* end of section */
        </style>
        <%            DecimalFormat df = new DecimalFormat("#.00");
            ArrayList<Employee> employeeList = new ArrayList<>();
            employeeList = EmployeeDAO.getAllEmployees();
            ArrayList<Client> clientList = new ArrayList<>();
            clientList = ClientDAO.getAllClient();
            ArrayList<Project> projectList = new ArrayList<>();
            projectList = ProjectDAO.getAllProjectsFiltered().get(0);
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";
            ArrayList<ArrayList<Project>> clientProjectList = new ArrayList<>();
            clientProjectList = ProjectDAO.getAllProjectsByCompanyName("");
            boolean displayClientGraph = true;
            boolean displayEmployeeGraph = true;
        %>
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
                $('#datatable9').DataTable();
                $('#datatable10').DataTable();
            })
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
                        <div class="tab wrap" style="width: 70%">
                            <div style="float: left; width: 33%">
                                <button class="tablinks btn-block" onclick="KPIs(event, 'Abundant')">Abundant Performance</button>
                            </div>
                            <div style="float: center; width: 33%">
                                <button class="tablinks btn-block" onclick="KPIs(event, 'Employee')">Abundant Employee Performance</button>
                            </div>
                            <div style="float: right; width: 33%">
                                <button class="tablinks btn-block" onclick="KPIs(event, 'Client')">Client Performance</button>
                            </div>
                        </div>
                    </center>
                </div>
                </center>
                <div id="Abundant" class="tabcontent container-fluid" style="text-align: center;">
                    <br/>
                    <div class="row">
                        <div class="col-xs-1">&nbsp;</div>
                        <div class="col-xs-5 displayChartsTable" data-target="#revenueTable" style="text-align: center;" align="center;">
                            <h2>Revenue</h2>
                            <canvas id="RevenueChart" style="width: 500px; height: 500px; text-align: center;" align="center"></canvas>
                        </div>
                        <div class="col-xs-1">&nbsp;</div>
                        <div class="col-xs-5 displayChartsTable" data-target="#ProfitAndLossTable" style="text-align: center;" align="center;">
                            <h2>Project P&L</h2>
                            <canvas id="ProfitAndLossChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                        </div>
                        <br/><br/>
                        <div class="col-xs-1">&nbsp;</div>
                        <div class="col-xs-5 displayChartsTable" data-target="#ProjectsOverdueChartTable" style="text-align: center;" align="center;">
                            <h2>Project Overdue</h2>
                            <canvas id="ProjectsOverdueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                        </div>
                    </div>
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
                                        <%
                                            if (projectList != null && !projectList.isEmpty()) {
                                                for (int i = 0; i < projectList.size(); i++) {
                                                    Project p = projectList.get(i);
                                                    double sales = ProjectDAO.getSales(p);
                                                    double totalActualCost = ProjectDAO.getTotalActualCost(p);
                                                    double profit = ProjectDAO.getProfit(p);
                                        %>
                                        <tr>
                                            <td>
                                                <%=p.getDateCompleted()%>
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
                                <h3>Profit and Loss</h3>
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
                                                <%=p.getDateCompleted()%>
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
                                <h3>Project Overdue</h3>
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
                                                <%=p.getDateCompleted()%>
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
                    <script>
                        $(document).ready(function () {
                            $.ajax({
                                url: 'SalesGraph',
                                method: 'POST',
                                success: function () {
                                    var salesData = "<%=request.getSession().getAttribute("sales")%>";
                                    var sales = salesData.split(",");
                                    sales[0] = sales[0].substring("1");
                                    sales[11] = sales[11].substring("0", sales[11].length - 1);
                                    var costData = "<%=request.getSession().getAttribute("cost")%>";
                                    var cost = costData.split(",");
                                    cost[0] = cost[0].substring("1");
                                    cost[11] = cost[11].substring("0", cost[11].length - 1);
                                    var profitData = "<%=request.getSession().getAttribute("profit")%>";
                                    var profit = profitData.split(",");
                                    profit[0] = profit[0].substring("1");
                                    profit[11] = profit[11].substring("0", profit[11].length - 1);
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
                                    };

                                    Chart.defaults.global.tooltipYPadding = 16;
                                    Chart.defaults.global.tooltipCornerRadius = 0;
                                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                                    Chart.defaults.global.responsive = false;
                                    var ctx = document.getElementById("RevenueChart").getContext("2d");
                                    //ctx.height = 500;
                                    var RevenueChart = new Chart(ctx, {
                                        type: 'line',
                                        data: lineChartData,
                                        pointDotRadius: 5,
                                        bezierCurve: false,
                                        scaleShowVerticalLines: false
                                    });
                                },
                                error: function (data) {
                                    console.log("Error: " + data);
                                }
                            });
                        });

                    </script>
                    <script>
                        $(document).ready(function () {
                            $.ajax({
                                url: 'CompletedProjectMonthlyProfitability',
                                method: 'POST',
                                success: function () {
                                    var profitableProjectsData = "<%=request.getSession().getAttribute("yearProfit")%>";
                                    var profitableProjects = profitableProjectsData.split(",");
                                    profitableProjects[0] = profitableProjects[0].substring("1");
                                    profitableProjects[11] = profitableProjects[11].substring("0", profitableProjects[11].length - 1);
                                    var lossProjectsData = "<%=request.getSession().getAttribute("yearLoss")%>";
                                    var lossProjects = lossProjectsData.split(",");
                                    lossProjects[0] = lossProjects[0].substring("1");
                                    lossProjects[11] = lossProjects[11].substring("0", lossProjects[11].length - 1);
                                    var totalCompletedList = "<%=request.getSession().getAttribute("totalCompletedList")%>";
                                    var totalCompletedProjects = totalCompletedList.split(",");
                                    totalCompletedProjects[0] = totalCompletedProjects[0].substring("1");
                                    totalCompletedProjects[11] = totalCompletedProjects[11].substring("0", totalCompletedProjects[11].length - 1);
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
                                                ],fillColor: [
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

                                    Chart.defaults.global.tooltipCornerRadius = 0;
                                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                                    Chart.defaults.global.responsive = false;
                                    var ctx = document.getElementById("ProfitAndLossChart").getContext("2d");
                                    var RevenueChart = new Chart(ctx, {
                                        type: 'bar',
                                        data: barChartData,
                                        scaleShowVerticalLines: false
                                    });
                                },
                                error: function (data) {
                                    console.log("Error: " + data);
                                }
                            });
                        });
                    </script>
                    <script>
                        $(document).ready(function () {
                            $.ajax({
                                url: 'OverdueProjectPerYear',
                                method: 'POST',
                                success: function () {
                                    var overdueProject = "<%=request.getSession().getAttribute("overdueProject")%>";
                                    var overdue = overdueProject.split(",");
                                    overdue[0] = overdue[0].substring("1");
                                    overdue[11] = overdue[11].substring("0", overdue[11].length - 1);
                                    var ontimeProject = "<%=request.getSession().getAttribute("ontimeProject")%>";
                                    var ontime = ontimeProject.split(",");
                                    ontime[0] = ontime[0].substring("1");
                                    ontime[11] = ontime[11].substring("0", ontime[11].length - 1);
                                    var completedProject = "<%=request.getSession().getAttribute("completedProject")%>";
                                    var completed = completedProject.split(",");
                                    completed[0] = completed[0].substring("1");
                                    completed[11] = completed[11].substring("0", completed[11].length - 1);
                                    var barChartData = {
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
                                                ],fillColor: [
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
                                    Chart.defaults.global.tooltipCornerRadius = 0;
                                    Chart.defaults.global.tooltipTitleFontStyle = "normal";
                                    Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                                    Chart.defaults.global.animationEasing = "easeInOutElastic";
                                    Chart.defaults.global.responsive = false;
                                    var ctx = document.getElementById("ProjectsOverdueChart").getContext("2d");
                                    var ProjectsOverdueChart = new Chart(ctx, {
                                        type: 'bar',
                                        data: barChartData,
                                        scaleShowVerticalLines: false
                                    });
                                },
                                error: function (data) {
                                    console.log("Error: " + data);
                                }
                            });
                        });

                    </script>
                </div>


                <!-- ############################################### THIS PORTION IS FOR CLIENT PERFORMANCE ######################################################################-->
                <div id="Client" class="tabcontent container-fluid" align='center' style="text-align: center;">
                    <% // this is to check if we're supposed to show the list of client or the graphs page 
                        if (!displayClientGraph) {
                            // Checks if clientlist is null or isempty
                            if (clientList != null && !clientList.isEmpty()) {
                    %>   
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <form>
                            <div class="row">
                                <br/>
                                <div class="col-xs-9">
                                </div>
                                <div class="col-xs-3">
                                    <div class="dashboardSelect">
                                        <select name="clientDashboardYear" class="clientDashboard" id="clientDashboardYear" required>
                                            <option class="clientDashboard" disabled selected value>-- Please Select Year --</option>
                                            <option class="clientDashboard" value="2014">2014</option>
                                            <option class="clientDashboard" value="2015">2015</option>
                                            <option class="clientDashboard" value="2016">2016</option>
                                            <option class="clientDashboard" value="2017">2017</option>
                                            <option class="clientDashboard" value="2018">2018</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <br/><br/>
                            <table id='datatable' align="center">
                                <thead>
                                    <tr>
                                        <th width="10.0%">Client ID</th>
                                        <th width="25.0%">Business Type</th>
                                        <th width="25.0%">Company Name</th>
                                        <th width="40.0%" align="right"></th>
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
                                </tbody>
                            </table>
                            <p style="text-align: left;"> *all data are updated as of this month</p>
                            <br/><br/><br/>
                            <table style="width: 100%" align="right">
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
                                        <button id="viewPerformance" class="btn btn-lg btn-primary btn-block btn-success" type="submit">View Performance</button>
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
                    } else {
                    %>
                    <div class="container-fluid" style="text-align: center;">
                        <br/>
                        <div class="row">
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-5" style="text-align: center;" align="center;">
                                <h2>Project P&L</h2>
                                <canvas id="clientProfitAndLossChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                            </div>
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-5" style="text-align: center;" align="center;">
                                <h2>Project Overdue</h2>
                                <canvas id="clientOverdueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                            </div>
                        </div>
                        <div class="row">
                            <br/><br/>
                            <table style="width: 100%; position: relative; bottom: 0px;">
                                <tr>
                                    <td style="width: 78.3%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <br/>
                                        <button class="btn btn-lg btn-primary btn-block" href="ClientProfile.jsp?profileId=">Go to Profile</button>
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
                <script>
                    $(document).ready(function () {
                        var year = "2017";//document.getElementById('clientDashboardYear');
                        var clientID = "1";//document.getElementById("client").value;
                        $.ajax({
                            url: 'ClientDashboard',
                            data: 'clientID=' + clientID + '&' + 'year=' + year,
                            type: 'POST',
                            success: function () {
                                var clientYearProfitData = "<%=request.getSession().getAttribute("clientYearProfit")%>";
                                var clientYearProfit = clientYearProfitData.split(",");
                                clientYearProfit[0] = clientYearProfit[0].substring("1");
                                clientYearProfit[11] = clientYearProfit[11].substring("0", clientYearProfit[11].length - 1);
                                //console.log(clientYearProfit[11]);
                                var clientYearLossData = "<%=request.getSession().getAttribute("clientYearLoss")%>";
                                var clientYearLoss = clientYearLossData.split(",");
                                clientYearLoss[0] = clientYearLoss[0].substring("1");
                                clientYearLoss[11] = clientYearLoss[11].substring("0", clientYearLoss[11].length - 1);
                                //console.log(clientYearLoss);
                                var clientOverdueProjectData = "<%=request.getSession().getAttribute("clientOverdueProject")%>";
                                var clientOverdueProject = clientOverdueProjectData.split(",");
                                clientOverdueProject[0] = clientOverdueProject[0].substring("1");
                                clientOverdueProject[11] = clientOverdueProject[11].substring("0", clientOverdueProject[11].length - 1);
                                //console.log(clientOverdueProject);
                                var clientOnTimeProjectData = "<%=request.getSession().getAttribute("clientOnTimeProject")%>";
                                var clientOnTimeProject = clientOnTimeProjectData.split(",");
                                clientOnTimeProject[0] = clientOnTimeProject[0].substring("1");
                                clientOnTimeProject[11] = clientOnTimeProject[11].substring("0", clientOnTimeProject[11].length - 1);
                                //console.log(clientOnTimeProject);
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
                                            data: clientOnTimeProject, //[12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
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
                                            data: clientOverdueProject, //[1, 13, 5, 2, 9, 1, 1, 13, 5, 2, 9, 1],
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

                            }
                        });
                    });
                </script>
                <!-- ############################################### END OF CLIENT PERFORMANCE SECTION ###############################################-->                    


                <!-- ############################################### START OF EMPLOYEE PERFORMANCE SECTION ###############################################-->
                <div id="Employee" class="tabcontent container-fluid" align='center' style="text-align: center;">
                    <% // this is to check if we're supposed to show the list of employees or the graphs page
                        if (!displayEmployeeGraph) {
                            // check if employeelist is null or empty
                            if (employeeList != null && !employeeList.isEmpty()) {
                                System.out.println("Employee List Size: " + employeeList.size());
                    %>
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <form>
                            <div class="row">
                                <br/>
                                <div class="col-xs-6">
                                </div>
                                <div class="col-xs-3">
                                    <div class="dashboardSelect">
                                        <select name="employeeDashboardMonth" class="clientDashboard" id="employeeDashboardMonth">
                                            <option class="clientDashboard" disabled selected value>-- Please Select Month --</option>
                                            <option class="clientDashboard" value="01">January</option>
                                            <option class="clientDashboard" value="02">February</option>
                                            <option class="clientDashboard" value="03">March</option>
                                            <option class="clientDashboard" value="04">April</option>
                                            <option class="clientDashboard" value="05">May</option>
                                            <option class="clientDashboard" value="06">June</option>
                                            <option class="clientDashboard" value="07">July</option>
                                            <option class="clientDashboard" value="08">August</option>
                                            <option class="clientDashboard" value="09">September</option>
                                            <option class="clientDashboard" value="10">October</option>
                                            <option class="clientDashboard" value="11">November</option>
                                            <option class="clientDashboard" value="12">December</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-xs-3">
                                    <div class="dashboardSelect">
                                        <select name="employeeDashboardYear" class="clientDashboard" id="employeeDashboardYear" required>
                                            <option class="clientDashboard" disabled selected value>-- Please Select Year --</option>
                                            <option class="clientDashboard" value="2014">2014</option>
                                            <option class="clientDashboard" value="2015">2015</option>
                                            <option class="clientDashboard" value="2016">2016</option>
                                            <option class="clientDashboard" value="2017">2017</option>
                                            <option class="clientDashboard" value="2018">2018</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <br/><br/>
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
                                            <input type="radio" name="employee" id='empName' value='<%=employeeList.get(i).getName()%>' required>
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
                                        <button id='btnViewPerformance' class="btn btn-lg btn-primary btn-block btn-success" type="submit">View Performance</button>
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
                    } else
                    %>
                    <div class="container-fluid" style="text-align: center;">
                        <br/>
                        <div class="row">
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-5" style="text-align: center;" align="center;">
                                <h2># of Projects</h2>
                                <canvas id="employeeRevenueChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                            </div>
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-5" style="text-align: center;" align="center;">
                                <h2>Project P&L</h2>
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
                                                if (request.getSession().getAttribute("employeeProjectList") != null) {
                                                    ArrayList<Project> employeeProjectList = (ArrayList<Project>) request.getSession().getAttribute("employeeProjectList");
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
                                                    <%=p.getProjectTitle()%>
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
                                    <td style="width: 78.3%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block" href="EmployeeProfile.jsp?profileId=">Go to Profile</button>
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
                        }
                    %>
                </div>
                <script>
                    $(document).ready(function () {

                        var employeeDashboardMonth = "08";//document.getElementById("employeeDashboardMonth").value;
                        var employeeDashboardYear = "2017";//document.getElementById("employeeDashboardYear").value;
                        var empName = "Jiayi";//document.getElementById("empName").value;
                        $.ajax({
                            url: 'StaffMonthlyReport',
                            data: 'employeeName=' + empName + '&' + 'Year=' + employeeDashboardYear + '&' + 'Month=' + employeeDashboardMonth,
                            type: 'POST',
                            success: function () {
                                var employeeOverdueData = "<%=request.getSession().getAttribute("employeeOverdue")%>";
                                var employeeOverdue = employeeOverdueData.split(",");
                                employeeOverdue[0] = employeeOverdue[0].substring("1");
                                employeeOverdue[11] = employeeOverdue[11].substring("0", employeeOverdue[11].length - 1);
                                //console.log(employeeOverdue);
                                var employeeTimeExceedData = "<%=request.getSession().getAttribute("employeeTimeExceed")%>";
                                var employeeTimeExceed = employeeTimeExceedData.split(",");
                                employeeTimeExceed[0] = employeeTimeExceed[0].substring("1");
                                employeeTimeExceed[11] = employeeTimeExceed[11].substring("0", employeeTimeExceed[11].length - 1);
                                //console.log(employeeTimeExceed);
                                var lineChartData = {
                                    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                                    datasets: [
                                        {
                                            label: 'Overdue Projects',
                                            fillColor: 'rgba(255, 99, 132, 0.3)',
                                            strokeColor: 'rgba(220,180,0,1)',
                                            pointColor: 'rgba(220,180,0,1)',
                                            data: employeeOverdue, //[80, 80, 120, 50, 120, 40, 80, 80, 120, 50, 120, 40, 80],
                                            backgroundColor: [
                                                'rgba(255, 99, 132, 0.3)'
                                            ],
                                            borderColor: [
                                                'rgba(255,99,132,1)'
                                            ],
                                            borderWidth: 1
                                        },
                                        {
                                            label: 'Time Exceeded Projects',
                                            fillColor: 'rgba(54, 162, 235, 0.3)',
                                            strokeColor: 'rgba(66,180,0,1)',
                                            pointColor: 'rgba(66,180,0,1)',
                                            data: employeeTimeExceed, //[20, -30, 80, 20, 40, 10, 60, -30, 80, 20, 40, 10, 60],
                                            backgroundColor: [
                                                'rgba(153, 102, 255, 0.3)'
                                            ],
                                            borderColor: [
                                                'rgba(153, 102, 255, 0.3)'
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
                                //ctx.height = 500;
                                var RevenueChart = new Chart(ctx, {
                                    type: 'line',
                                    data: lineChartData,
                                    pointDotRadius: 5,
                                    bezierCurve: false,
                                    scaleShowVerticalLines: false
                                });

                            },
                            error: function (data) {
                                console.log(data);
                            }
                        });
                    }
                    );
                </script>
            </div>
        </div>
    </nav>
</body>
<script>
    // this is for toggling between the 3 main pages
    function KPIs(evt, KPI) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(KPI).style.display = "block";
        evt.currentTarget.className += " active";
    }
</script>

<script>
    // this is for collapsing and hiding the tables
    $(function () {
        $('.displayChartsTable').on('click', function () {
            var $this = $(this);
            $('.displayChartsTable').removeClass("activePerformanceChart");
            $this.addClass("activePerformanceChart");
            // Use the id in the data-target attribute
            $target = $($this.data('target'));
            $(".target").not($target).fadeOut();
            $target.toggle();

            $('html,body').animate({
                scrollTop: $target.offset().top},
                    'fast');
        });
    });
</script>
<jsp:include page="Footer.html"/>
</html>