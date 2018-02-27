<%-- 
    Document   : ClientInsights
    Created on : Feb 27, 2018, 11:07:31 AM
    Author     : yemin
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>
<%@include file="AdminAccessOnly.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Clients Insights Page | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <script>
            $(document).ready(function () {
                $('#datatable4').DataTable();
            });
        </script>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <%
                        ArrayList<Project> projectList = new ArrayList();
                        projectList = (ArrayList<Project>) request.getSession().getAttribute("companyProjectList");

                        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                        DecimalFormat df = new DecimalFormat("#.00");
                        //System.out.println("Insights: " + projectList.size());
                    %>
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <h3><b><%=request.getSession().getAttribute("clientIDSelected")%> Projects for the year <%=request.getSession().getAttribute("yearClient")%></b></h3>
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
                                    <th width="10.00%">Cost</th>
                                    <th width="10.00%">Profit/Loss</th>
                                    <th width="10.00%">Staff</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (int i = 0; i < projectList.size(); i++) {
                                        Project p = projectList.get(i);
                                        double sales = ProjectDAO.getSales(p);
                                        //System.out.println("Insights Sales: " + sales);
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
                                        <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
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
                                %>

                            </tbody>
                        </table>
                        <br/>
                    </div>
                </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>

