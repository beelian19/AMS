<%-- 
    Document   : Dashboard
    Created on : Dec 24, 2017, 4:53:37 PM
    Author     : Bernitatowyg
--%>

<%@page import="DAO.DashboardDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@include file="Protect.jsp"%>--%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>Your Dashboard</h1>
                    <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow:auto">
                        <div class="container-fluid" style="text-align: left">
                            <div class="container-fluid">
                                <table width="100%">
                                    <tr>
                                        <td align="left">
                                            <h3>Monthly Resource Allocation</h3>
                                        </td>
                                        <td align="right">
                                            <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#currentjobcollapsible"></button>
                                        </td>
                                    </tr>
                                </table>    
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <div id="currentjobcollapsible" class="collapse in">
                                                <table width="100%" style="cellpadding: 2%" id="datatable">
                                                    <thead>
                                                        <tr>
                                                            <th width="16.6666%">Company Name</th>
                                                            <th width="16.6666%">Project Name</th>
                                                            <th width="16.6666%">Planned Hours</th>
                                                            <th width="16.6666%">Actual Hours</th>
                                                            <th width="16.6666%">Difference</th>
                                                            <th width="16.6666%">Actual Total Cost</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
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
                                                                test
                                                            </td>
                                                            <td>
                                                                test
                                                            </td>
                                                            <td>
                                                                test
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <br/>
                        </div>
                    </nav>
                    <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow:auto">
                        <div class="container-fluid" style="text-align: left">
                            <div class="container-fluid">
                                <table width="100%">
                                    <tr>
                                        <td align="left">
                                            <h3>Monthly Report for Completed Projects</h3>
                                        </td>
                                        <td align="right">
                                            <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#monthlyReport"></button>
                                        </td>
                                    </tr>
                                </table>    
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <div id="monthlyReport" class="collapse in">
                                                <table width="100%" style="cellpadding: 2%" id="datatable">
                                                    <thead>
                                                        <tr>
                                                            <th width="11.1111%">Company Name</th>
                                                            <th width="11.1111%">Project Name</th>
                                                            <th width="11.1111%">Planned Hours</th>
                                                            <th width="11.1111%">Actual Hours</th>
                                                            <th width="11.1111%">Difference</th>
                                                            <th width="11.1111%">Sales</th>
                                                            <th width="11.1111%">Actual Total Cost</th>
                                                            <th width="11.1111%">P&L</th>
                                                            <th width="11.1111%">Employee Assigned</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
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
                                                                test
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
                                                                test
                                                            </td>
                                                            <td>
                                                                test
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <br/>
                        </div>
                    </nav>
                    <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow:auto">
                        <div class="container-fluid" style="text-align: left">
                            <div class="container-fluid">
                                <table width="100%">
                                    <tr>
                                        <td align="left">
                                            <h3>Monthly Report for Completed Projects</h3>
                                        </td>
                                        <td align="right">
                                            <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#yearlyReport"></button>
                                        </td>
                                    </tr>
                                </table>    
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <div id="yearlyReport" class="collapse in">
                                                <table width="100%" style="cellpadding: 2%" id="datatable">
                                                    <thead>
                                                        <tr>
                                                            <th width="14.2857%">Company Name</th>
                                                            <th width="14.2857%">Projects Completed</th>
                                                            <th width="14.2857%">Planned Hours</th>
                                                            <th width="14.2857%">Actual Hours</th>
                                                            <th width="14.2857%">Sales</th>
                                                            <th width="14.2857%">Actual Total Cost</th>
                                                            <th width="14.2857%">P&L</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
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
                                                                test
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
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <br/>
                        </div>
                    </nav>
                </div>
            </div>
        </nav>
        <br/>
    </body>
    <jsp:include page="Footer.html"/>
</html>
