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
        %>
        <script>
            $(document).ready(function () {
                $('#datatable1').DataTable();
            })
        </script>
        <%
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";
        %>
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
                </div>

                <!-- ############################################### START OF EMPLOYEE PERFORMANCE SECTION ###############################################-->
                <div class="container-fluid" style="text-align: center;">
                    <div class="row">
                        <br/>
                        <div class="col-xs-9">
                        </div>
                        <div class="col-xs-3">
                            <div class="dashboardSelect">
                                <select name="employeePerformanceChart" class="clientDashboard" id="employeePerformanceChart" onchange="employeePerformanceChart()" required>
                                    <option class="clientDashboardOption" disabled selected value>-- Please Select Year --</option>
                                    <option class="clientDashboardOption" value="2014">2014</option>
                                    <option class="clientDashboardOption" value="2015">2015</option>
                                    <option class="clientDashboardOption" value="2016">2016</option>
                                    <option class="clientDashboardOption" value="2017">2017</option>
                                    <option class="clientDashboardOption" selected="selected" value="2018">2018</option>
                                </select>
                            </div>
                            <div>
                                <button id='btnViewEmpInsights' class="btn btn-lg btn-primary btn-block" type="button">More Insights</button>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-1">&nbsp;</div>
                            <div class="col-xs-5" style="text-align: center;" align="right;">
                                <h2>Projects Undertaken</h2>
                                <canvas id="employeeProjectNumbersChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                            </div>
                            <div class="col-xs-5" style="text-align: center;" align="center;">
                                <h2>Project Hours</h2>
                                <canvas id="employeeProjectHoursChart" style="width: 500px; height: 250px; text-align: center;" align="center"></canvas>
                            </div>
                            <div class="col-xs-1">&nbsp;</div>
                        </div>
                    </div>
                </div>
                <br/><br/>
        </nav>
        <script>
            $(document).ready(function () {
                employeePerformanceChart();
                var canvas = document.getElementsByTagName('canvas')[0];
                canvas.width = 500;
                canvas.height = 250;
                var canvas = document.getElementsByTagName('canvas')[1];
                canvas.width = 500;
                canvas.height = 250;
            });
            $('#btnViewEmpInsights').click(function () {
                viewEmployeeInsights();
            });
            function employeePerformanceChart() {
//$("canvas#employeeProjectNumbersChart").remove();
//$("canvas#employeeProjectHoursChart").remove();
//$("div.chartreport").append('<canvas id="chartreport" class="animated fadeIn" height="150"></canvas>');
                var yearChosen = document.getElementById('employeePerformanceChart').value;
                if (yearChosen === null || yearChosen === "") {
                    now = new Date;
                    yearChosen = now.getYear();
                    if (yearChosen < 1900) {
                        yearChosen = yearChosen + 1900;
                    }
                }
                var empName = "<%=request.getSession().getAttribute("employeeName")%>";

                console.log("Name: " + empName);
                console.log("Year: " + yearChosen);
                var employeeOverdue = new Array(12);
                var inTime = new Array(12);
                var completedProjects = new Array(12);
                var actualHours = new Array(12);
                var plannedHours = new Array(12);
                $.ajax({
                    url: 'StaffMonthlyReport',
                    type: 'POST',
                    data: 'employeeName=' + empName + '&' + 'Year=' + yearChosen,
                    success: function (data) {
                        var jsonData = $.parseJSON(data);

                        for (var i = 0; i < 12; i++) {
                            var data = jsonData[0][i];
                            employeeOverdue[i] = data;
                        }

                        for (var i = 0; i < 12; i++) {
                            var data = jsonData[2][i];
                            completedProjects[i] = data;
                        }

                        for (var i = 0; i < 12; i++) {
                            var data = jsonData[3][i];
                            actualHours[i] = data;
                        }

                        for (var i = 0; i < 12; i++) {
                            var data = jsonData[4][i];
                            plannedHours[i] = data;
                        }

                        for (var i = 0; i < 12; i++) {
                            var data = jsonData[5][i];
                            inTime[i] = data;
                        }
                        var barChartData = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [
                                {
                                    label: '# of Completed Projects',
                                    fillColor: 'rgba(255, 99, 132, 0.2)',
                                    strokeColor: 'rgba(220,180,0,1)',
                                    pointColor: 'rgba(220,180,0,1)',
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
                                    label: '# of Overdue Projects',
                                    fillColor: 'rgba(54, 162, 235, 0.2)',
                                    strokeColor: 'rgba(66,180,0,1)',
                                    pointColor: 'rgba(66,180,0,1)',
                                    data: employeeOverdue, //[20, -30, 80, 20, 40, 10, 60, -30, 80, 20, 40, 10, 60],
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
                                }, {
                                    label: '# of Projects on Time',
                                    fillColor: 'rgba(54, 162, 235, 0.2)',
                                    strokeColor: 'rgba(54, 162, 235, 0.2)',
                                    pointColor: 'rgba(54, 162, 235, 0.2)',
                                    data: inTime, //[60, 110, 40, 30, 80, 30, 20, 110, 40, 30, 80, 30, 20],
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
                        var barChartData1 = {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [{
                                    label: 'Planned Hours',
                                    data: plannedHours,
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
                                    label: 'Acutal Hours',
                                    data: actualHours,
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
                                }
                            ]
                        }
                        Chart.defaults.global.tooltipYPadding = 16;
                        Chart.defaults.global.tooltipCornerRadius = 0;
                        Chart.defaults.global.tooltipTitleFontStyle = "normal";
                        Chart.defaults.global.tooltipFillColor = "rgba(0,160,0,0.8)";
                        Chart.defaults.global.animationEasing = "easeInOutElastic";
                        Chart.defaults.global.responsive = false;
                        var ctx = document.getElementById("employeeProjectNumbersChart").getContext("2d");
                        var ctx1 = document.getElementById("employeeProjectHoursChart").getContext("2d");
                        //ctx.height = 500;
                        var employeeProjectNumbersChart = new Chart(ctx, {
                            type: 'bar',
                            data: barChartData,
                            pointDotRadius: 5,
                            bezierCurve: false,
                            scaleShowVerticalLines: false
                        });
                        var employeeProjectHoursChart = new Chart(ctx1, {
                            type: 'bar',
                            data: barChartData1,
                            pointDotRadius: 5,
                            bezierCurve: false,
                            scaleShowVerticalLines: false
                        });
                    },
                    error: function (data) {
                        console.log("Error: " + data);
                    }
                });
            }

            //go to Insights for Employee page with project data 
            function viewEmployeeInsights() {
                var employeeDashboardYear = document.getElementById('employeePerformanceChart').value;
                var empName = "<%=request.getSession().getAttribute("employeeName")%>";
                //console.log("This was called and the year is " + yearChosen);
                console.log(employeeDashboardYear);
                console.log(empName);
                $.ajax({
                    url: 'GetEmployeeDataforTable',
                    data: 'employeeName=' + empName + '&' + 'year=' + employeeDashboardYear,
                    type: 'POST',
                    success: function () {
                        window.location.assign("EmployeeInsights.jsp");
                    }
                });
            }
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>