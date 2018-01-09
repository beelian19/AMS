<%-- 
    Document   : FinalDashboard
    Created on : Jan 3, 2018, 3:02:57 PM
    Author     : Bernitatowyg
--%>

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

        <%            ArrayList<Employee> employeeList = new ArrayList<>();
            employeeList = EmployeeDAO.getAllEmployees();
            ArrayList<Client> clientList = new ArrayList<>();
            clientList = ClientDAO.getAllClient();
        %>
        <script>
            $(document).ready(function () {
                $('#datatable').DataTable();
                $('#datatable2').DataTable();
                $('#datatable3').DataTable();
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
                        <div class="col-xs-6" style="margin-left: 0px; margin-right: 0px; margin-bottom: 0px;" onclick="hideAndShowTable();">
                            <h2>Revenue</h2>
                            <canvas id="RevenueChart" style="margin-left: 0px; margin-right: 0px; margin-bottom: 0px;"></canvas>
                        </div>
                        <div class="col-xs-6" style="margin-left: 0px; margin-right: 0px; margin-bottom: 0px;">
                            <h2>Project P&L</h2>
                            <canvas id="ProfitAndLossChart" style="padding-right: 0px; margin-right: 0px;"></canvas>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 0px; margin-right: 0px; margin-bottom: 0px;">
                        <div class="col-xs-6">
                            <h2>Project Overdue</h2>
                            <canvas id="ProjectsOverdue" style="padding-right: 0px; margin-right: 0px;"></canvas>
                        </div>
                        <div class="col-xs-6" style="margin-left: 0px; margin-right: 0px; margin-bottom: 0px;">
                            <h2>Number of Expenses</h2>
                            <canvas id="NumberofExpenses" style="padding-right: 0px; margin-right: 0px;"></canvas>
                        </div>
                    </div>
                    <script>
                        Chart.defaults.global.tooltipYPadding = 16;
                        Chart.defaults.global.tooltipCornerRadius = 0;
                        Chart.defaults.global.tooltipTitleFontStyle = "normal";
                        Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                        Chart.defaults.global.animationEasing = "easeInOutElastic";
                        Chart.defaults.global.responsive = true;
                        Chart.defaults.global.scaleLineColor = "black";
                        var ctx = document.getElementById("ProfitAndLossChart");
                        var ProfitAndLossChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                                datasets: [{
                                        label: '# of Projects',
                                        data: [12, 19, 3, 5, 2, 3],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '# of Overdue Projects',
                                        data: [1, 13, 5, 8, 9, 1],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                            ticks: {
                                                beginAtZero: true
                                            }
                                        }]
                                }
                            }
                        });
                    </script>
                    <script>
                        var lineChartData = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"],
                            datasets: [{
                                    label: 'Revenue',
                                    fillColor: "rgba(220,220,220,0)",
                                    strokeColor: "rgba(220,180,0,1)",
                                    pointColor: "rgba(220,180,0,1)",
                                    data: [20, -30, 80, 20, 40, 10, 60]
                                }, {
                                    label: 'Profit',
                                    fillColor: "rgba(66,66,66,0)",
                                    strokeColor: "rgba(66,180,0,1)",
                                    pointColor: "rgba(66,180,0,1)",
                                    data: [80, 80, 120, 50, 120, 40, 80]
                                }, {
                                    label: 'Cost',
                                    fillColor: "rgba(151,187,205,0)",
                                    strokeColor: "rgba(151,187,205,1)",
                                    pointColor: "rgba(151,187,205,1)",
                                    data: [60, 110, 40, 30, 80, 30, 20]
                                }]
                        }

                        Chart.defaults.global.tooltipYPadding = 16;
                        Chart.defaults.global.tooltipCornerRadius = 0;
                        Chart.defaults.global.tooltipTitleFontStyle = "normal";
                        Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                        Chart.defaults.global.animationEasing = "easeInOutElastic";
                        Chart.defaults.global.responsive = false;
                        Chart.defaults.global.scaleLineColor = "black";

                        var ctx = document.getElementById("RevenueChart").getContext("2d");
                        var RevenueChart = new Chart(ctx, {
                            type: 'line',
                            data: lineChartData,
                            pointDotRadius: 10,
                            bezierCurve: false,
                            scaleShowVerticalLines: false,
                            scaleGridLineColor: "black"
                        });

                    </script>
                    <script>
                        var ctx = document.getElementById("ProfitAndLossChart");
                        var ProfitAndLossChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                                datasets: [{
                                        label: '# of Projects',
                                        data: [12, 19, 3, 5, 2, 3],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '# of Overdue Projects',
                                        data: [1, 13, 5, 8, 9, 1],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                            ticks: {
                                                beginAtZero: true
                                            }
                                        }]
                                }
                            }
                        });
                    </script>
                    <script>
                        var ctx = document.getElementById("ProjectsOverdue");
                        var ProjectsOverdue = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                                datasets: [{
                                        label: '# of Projects',
                                        data: [12, 19, 3, 5, 2, 3],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '# of Overdue Projects',
                                        data: [1, 13, 5, 8, 9, 1],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                            ticks: {
                                                beginAtZero: true
                                            }
                                        }]
                                }
                            }
                        });
                    </script>
                    <script>
                        var ctx = document.getElementById("NumberofExpenses");
                        var NumberofExpenses = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                                datasets: [{
                                        label: '# of Projects',
                                        data: [12, 19, 3, 5, 2, 3],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '# of Overdue Projects',
                                        data: [1, 13, 5, 8, 9, 1],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.2)',
                                            'rgba(54, 162, 235, 0.2)',
                                            'rgba(255, 206, 86, 0.2)',
                                            'rgba(75, 192, 192, 0.2)',
                                            'rgba(153, 102, 255, 0.2)',
                                            'rgba(255, 159, 64, 0.2)'
                                        ],
                                        borderColor: [
                                            'rgba(255,99,132,1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 1
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                            ticks: {
                                                beginAtZero: true
                                            }
                                        }]
                                }
                            }
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
                        <form action="dashboardEmployeeServlet" method="post">
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

<jsp:include page="Footer.html"/>
</html>