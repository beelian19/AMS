<%-- 
    Document   : Dashboard
    Created on : Dec 24, 2017, 4:53:37 PM
    Author     : Bernitatowyg
--%>

<%@page import="DAO.DashboardDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="Protect.jsp"%>
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
                    <table align="center">
                        <tr>
                            <td align="left">
                                <h3>1. total no. of projects</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalProject()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>2. total no. of ongoing projects</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalOngoingProject()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>3. total no. of overdue projects</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalOverdueProject()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>4. total no. of completed projects</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalCompleteProject()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>5. total no. of tasks</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalTask()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>6. total no. of ongoing tasks</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalOngoingTask()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>7. total no. of overdue tasks</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalOverdueTask()%></h3>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <h3>8. total no. of completed tasks</h3>
                            </td>
                            <td width="3%">
                                &nbsp;
                            </td>
                            <td>
                                <h3><%=DashboardDAO.countTotalCompleteTask()%></h3>
                            </td>
                        </tr>
                    </table>
                    <img src="images/inprogress.png" style="width: 50%; height: 50%"/>
                </div>
            </div>
        </nav>
        <br/>
    </body>
    <jsp:include page="Footer.html"/>
</html>
