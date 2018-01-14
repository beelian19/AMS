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
                transition: 0.2s;
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
        </style>
        <%            DecimalFormat df = new DecimalFormat("#.00");
            ArrayList<Employee> employeeList = new ArrayList<>();
            employeeList = EmployeeDAO.getAllEmployees();
            ArrayList<Client> clientList = new ArrayList<>();
            clientList = ClientDAO.getAllClient();
            ArrayList<Project> projectList = new ArrayList<>();
            projectList = ProjectDAO.getAllProjects();
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";
            String clientProfileUrl = "ClientProfile.jsp?profileId=";
            String clientProfileUrl2 = "";
            String employee1ProfileUrl = "EmployeeProfile.jsp?profileId=";
            String employee1ProfileUrl2 = "";
            String employee2ProfileUrl = "EmployeeProfile.jsp?profileId=";
            String employee2ProfileUrl2 = "";
            ArrayList<ArrayList<Project>> clientProjectList = new ArrayList<>();
            clientProjectList = ProjectDAO.getAllProjectsByCompanyName("");
            ArrayList<ArrayList<Project>> employeeProjectList = new ArrayList<>();
            employeeProjectList = ProjectDAO.getAllProjectsByEmployee("");
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
                        <div class="col-xs-4 nav-toggle" href="#revenueTable">
                            <h2>Revenue</h2>
                            <canvas id="RevenueChart" style="width: 100%; height: 150%;"></canvas>
                        </div>
                        <div class="col-xs-4 nav-toggle" href="#ProfitAndLossTable">
                            <h2>Project P&L</h2>
                            <canvas id="ProfitAndLossChart" style="width: 100%; height: 150%;"></canvas>
                        </div>
                        <div class="col-xs-4 nav-toggle" href="#ProjectsOverdueChartTable">
                            <h2>Project Overdue</h2>
                            <canvas id="ProjectsOverdueChart" style="width: 100%; height: 150%;"></canvas>
                        </div>
                    </div>
                    <div class="row">
                        <br/>
                        <div class="col-xs-12" id="revenueTable" style="display:none">
                            <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
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
                                        %>
                                        <tr>
                                            <td>
                                                <%=p.getDateCompleted()%>
                                            </td>
                                            <td>
                                                <%
                                                    Client c = ClientDAO.getClientByCompanyName(p.getCompanyName());

                                                    if (c != null && !(p.getCompanyName()).isEmpty()) {
                                                        clientProfileUrl2 = clientProfileUrl + c.getClientID();
                                                %>
                                                <a href='<%=clientProfileUrl2%>'>
                                                    <%=p.getCompanyName()%>
                                                </a>
                                                <%
                                                } else {
                                                %>
                                                <%=p.getCompanyName()%>
                                                <%
                                                    }
                                                %>
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
                                                test
                                            </td>
                                            <td>
                                                test
                                            </td>
                                            <td>
                                                test
                                            </td>
                                            <td>
                                                <% 
                                                    employee1ProfileUrl2 = employee1ProfileUrl + p.getEmployee1().toLowerCase();
                                                    employee2ProfileUrl2 = employee2ProfileUrl + p.getEmployee2().toLowerCase();
                                                %>
                                                <a href=<%=employee1ProfileUrl2%>>
                                                    <%=p.getEmployee1()%>
                                                </a>
                                                <% if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(" and ");
                                                %>
                                                    <a href=<%=employee2ProfileUrl2%>>
                                                        <%=p.getEmployee2()%>
                                                    </a>
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
                        <div class="col-xs-12" id="ProfitAndLossTable" style="display:none">
                            <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
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
                                                <%
                                                    Client c = ClientDAO.getClientByCompanyName(p.getCompanyName());

                                                    if (c != null && !(p.getCompanyName()).isEmpty()) {
                                                        clientProfileUrl2 = clientProfileUrl + c.getClientID();
                                                %>
                                                <a href='<%=clientProfileUrl2%>'>
                                                    <%=p.getCompanyName()%>
                                                </a>
                                                <%
                                                } else {
                                                %>
                                                <%=p.getCompanyName()%>
                                                <%
                                                    }
                                                %>
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
                                                test
                                            </td>
                                            <td>
                                                test
                                            </td>
                                            <td>
                                                test
                                            </td>
                                            <td>
                                                <% 
                                                    employee1ProfileUrl2 = employee1ProfileUrl + p.getEmployee1().toLowerCase();
                                                    employee2ProfileUrl2 = employee2ProfileUrl + p.getEmployee2().toLowerCase();
                                                %>
                                                <a href=<%=employee1ProfileUrl2%>>
                                                    <%=p.getEmployee1()%>
                                                </a>
                                                <% if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(" and ");
                                                %>
                                                    <a href=<%=employee2ProfileUrl2%>>
                                                        <%=p.getEmployee2()%>
                                                    </a>
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
                        <div class="col-xs-12" id="ProjectsOverdueChartTable" style="display:none">
                            <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
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
                                                <%
                                                    Client c = ClientDAO.getClientByCompanyName(p.getCompanyName());

                                                    if (c != null && !(p.getCompanyName()).isEmpty()) {
                                                        clientProfileUrl2 = clientProfileUrl + c.getClientID();
                                                %>
                                                <a href='<%=clientProfileUrl2%>'>
                                                    <%=p.getCompanyName()%>
                                                </a>
                                                <%
                                                } else {
                                                %>
                                                <%=p.getCompanyName()%>
                                                <%
                                                    }
                                                %>
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
                                                    employee1ProfileUrl2 = employee1ProfileUrl + p.getEmployee1().toLowerCase();
                                                    employee2ProfileUrl2 = employee2ProfileUrl + p.getEmployee2().toLowerCase();
                                                %>
                                                <a href=<%=employee1ProfileUrl2%>>
                                                    <%=p.getEmployee1()%>
                                                </a>
                                                <% if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(" and ");
                                                %>
                                                    <a href=<%=employee2ProfileUrl2%>>
                                                        <%=p.getEmployee2()%>
                                                    </a>
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
                        var data = [-1.8612224E10,-7.8065322164220416E16,-2.558044476677102E21,-4.50015943435954E34,-2.4160046996700103E43,1337.5,0.0,16250.0,15312.5,3050.0,0.0,-7.444934436875E10];
                        console.log(data);
                        var lineChartData = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [{
                                    label: 'Revenue',
                                    fillColor: 'rgba(255, 99, 132, 0.2)',
                                    strokeColor: 'rgba(220,180,0,1)',
                                    pointColor: 'rgba(220,180,0,1)',
<<<<<<< HEAD
                                    data: data,//[80, 80, 120, 50, 120, 40, 80, 80, 120, 50, 120, 40, 80], //"SalesGraph",
=======
                                    data: [80, 80, 120, 50, 120, 40, 80, 80, 120, 50, 120, 40], //"SalesGraph", //[80, 80, 120, 50, 120, 40, 80, 80, 120, 50, 120, 40, 80],
>>>>>>> 667a73ba9da6d4333841a759483336f1b1c2ff67
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(255,99,132,1)'
                                    ],
                                    borderWidth: 1
                                },
                                {
                                    label: 'Profit',
                                    fillColor: 'rgba(54, 162, 235, 0.2)',
                                    strokeColor: 'rgba(66,180,0,1)',
                                    pointColor: 'rgba(66,180,0,1)',
<<<<<<< HEAD
                                    data: [20, -30, 80, 20, 40, 10, 60, -30, 80, 20, 40, 10, 60],
=======
                                    data: [20, -30, 80, 20, 40, 10, 60, -30, 80, 20, 40, 10], //"ProfitGraph", //[20, -30, 80, 20, 40, 10, 60, -30, 80, 20, 40, 10, 60],
>>>>>>> 667a73ba9da6d4333841a759483336f1b1c2ff67
                                    backgroundColor: [
                                        'rgba(153, 102, 255, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(153, 102, 255, 0.2)'
                                    ],
                                    borderWidth: 1
                                }, {
                                    label: 'Cost',
                                    fillColor: 'rgba(54, 162, 235, 0.2)',
                                    strokeColor: 'rgba(54, 162, 235, 0.2)',
                                    pointColor: 'rgba(54, 162, 235, 0.2)',
<<<<<<< HEAD
                                    data: [60, 110.0, 40, 30, 80, 30, 20, 110, 40, 30, 80, 30, 20],
=======
                                    data: [60, 110, 40, 30, 80, 30, 20, 110, 40, 30, 80, 30], //"CostGraph", //[60, 110, 40, 30, 80, 30, 20, 110, 40, 30, 80, 30, 20],
>>>>>>> 667a73ba9da6d4333841a759483336f1b1c2ff67
                                    backgroundColor: [
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                }]
                        }

                        Chart.defaults.global.tooltipYPadding = 16;
                        Chart.defaults.global.tooltipCornerRadius = 0;
                        Chart.defaults.global.tooltipTitleFontStyle = "normal";
                        Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                        Chart.defaults.global.animationEasing = "easeInOutElastic";
                        Chart.defaults.global.responsive = false;

                        var ctx = document.getElementById("RevenueChart").getContext("2d");
                        var RevenueChart = new Chart(ctx, {
                            type: 'line',
                            data: lineChartData,
                            pointDotRadius: 5,
                            bezierCurve: false,
                            scaleShowVerticalLines: false
                        });
                    </script>
                    <script>
                        var barChartData = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [{
                                    label: '# of Projects',
                                    data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)'
                                    ],
                                    borderWidth: 1
                                },
                                {
                                    label: '# of Profits',
                                    data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                    backgroundColor: [
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                    borderWidth: 1
                                },
                                {
                                    label: '# of Losses',
                                    data: [1, 13, 5, 2, 9, 1, 1, 13, 5, 2, 9, 1],
                                    backgroundColor: [
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)'
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
                    </script>
                    <script>
                        var barChartData = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [{
                                    label: '# of Projects',
                                    data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)',
                                        'rgba(255, 99, 132, 0.2)'
                                    ],
                                    borderWidth: 1
                                },
                                {
                                    label: '# of Projects On Time',
                                    data: [1, 3, 4, 5, 2, 3, 1, 3, 4, 5, 2, 3],
                                    backgroundColor: [
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)',
                                        'rgba(54, 162, 235, 0.2)'
                                    ],
                                    borderWidth: 1
                                },
                                {
                                    label: '# of Overdue Projects',
                                    data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                                    backgroundColor: [
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)'
                                    ],
                                    borderColor: [
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)',
                                        'rgba(255, 206, 86, 0.2)'
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
                    </script>
                </div>
                <div id="Client" class="tabcontent container-fluid" align='center' style="text-align: center;">
                    <br/><br/>
                    <%
                        if (employeeList != null && !employeeList.isEmpty()) {
                    %>   
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <form action="dashboardClientServlet" method="post">
                            <table id='datatable' align="center">
                                <thead>
                                    <tr>
                                        <th width="16.67%">Client ID</th>
                                        <th width="16.67%">Company Name</th>
                                        <th width="16.67%">Business Type</th>
                                        <th width="16.67%"># Ongoing Projects</th>
                                        <th width="16.67%"># Completed Projects</th>
                                        <th width="16.67%"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (int i = 0; i < clientList.size(); i++) {
                                    %>
                                    <tr style="text-align: left;">
                                        <td width="16.67%">
                                            <%=clientList.get(i).getClientID()%>
                                        </td>
                                        <td width="16.67%">
                                            <%=clientList.get(i).getBusinessType()%>
                                        </td>
                                        <td width="16.67%">
                                            <%=clientList.get(i).getCompanyName()%>
                                        </td>
                                        <td width="16.67%">

                                        </td>
                                        <td width="16.67%">

                                        </td>
                                        <td width="16.67%" align="center">
                                            <input type="radio" name="client" value='<%=clientList.get(i)%>' required>
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
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">View Performance</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/><br/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <%
                        }
                    %>
                </div>
                <div id="Employee" class="tabcontent container-fluid" align='center' style="text-align: center;">
                    <br/><br/>
                    <%
                        if (employeeList != null && !employeeList.isEmpty()) {
                    %>   
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <form action = "refreshTokenServlet" method = "post">
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
                                            <input type="radio" name="employee" value='<%=employeeList.get(i)%>' required>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
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
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">View Performance</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/><br/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <%
                        }
                    %>
                </div>
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
    $(document).ready(function () {
        $('.nav-toggle').click(function () {
            //get collapse content selector
            var collapse_content_selector = $(this).attr('href');

            $(collapse_content_selector).slideToggle("fast", function () {

            });
        });

    });
</script>
<jsp:include page="Footer.html"/>
</html>