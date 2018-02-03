<%-- 
    Document   : ProjectAdminOverview
    Created on : Dec 24, 2017, 5:03:11 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="Entity.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page import="DAO.ProjectDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="AdminAccessOnly.jsp"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <title>View All Projects | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
                $('#datatable2').DataTable();
                $('#datatable3').DataTable();
            });
        </script>
        <%            if (request.getAttribute("completedProject") == null) {
                //RequestDispatcher rd = request.getRequestDispatcher("AdminProjectServlet");
                //rd.forward(request, response);
                response.sendRedirect("ViewAllProjectAdmin");
                return;
            }
            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
            ArrayList<Project> overdueProjectList = (ArrayList<Project>) request.getAttribute("overdueProject");
            ArrayList<Project> completedProjectList = (ArrayList<Project>) request.getAttribute("completedProject");
            ArrayList<Project> incompletedProjectList = (ArrayList<Project>) request.getAttribute("incompleteProject");

            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";
            String clientProfileUrl = "ClientProfile.jsp?profileId=";
            String clientProfileUrl2 = "";
            Map<String, String> projTypeHash = new HashMap();
            projTypeHash.put("tax", "Tax");
            projTypeHash.put("eci", "ECI");
            projTypeHash.put("gst", "GST");
            projTypeHash.put("management", "Management");
            projTypeHash.put("final", "Final Accounting");
            projTypeHash.put("secretarial", "Secretarial");
            projTypeHash.put("adhoc", "Ad Hoc");
        %>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div>
                <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                    <jsp:include page="StatusMessage.jsp"/>
                </div>
            </div>
        </nav>
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="margin-top: 2%; overflow: auto">
            <div class="container-fluid" style="text-align: left">
                <div class="container-fluid">
                    <table width="100%">
                        <tr>
                            <td align="left">
                                <h3>Overdue Projects</h3>
                            </td>
                            <td align="right">
                                <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#overduejobcollapsible"></button>
                            </td>
                        </tr>
                    </table>    
                    <table width="100%">
                        <tr>
                            <td>
                                <div id="overduejobcollapsible" class="collapse in">
                                    <table width="100%" style="cellpadding: 2%" id="datatable3">
                                        <thead>
                                            <tr>
                                                <th width="14%">Project Title</th>
                                                <th width="14%">Company Name</th>
                                                <th width="14%">Internal Timeline</th>
                                                <th width="14%">External Timeline</th>
                                                <th width="14%">Total Hours Spent</th>
                                                <th width="14%">Completion Status</th>
                                                <th width="14%">Review Status</th>
                                                <th width="14%">Project Type</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (overdueProjectList != null && !overdueProjectList.isEmpty()) {
                                                    for (int i = 0; i < overdueProjectList.size(); i++) {
                                                        Project p = overdueProjectList.get(i);

                                            %>
                                            <tr>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href=<%=profileUrl2%>>
                                                        <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
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
                                                    <%=sdf.format(p.getEnd())%> 
                                                </td>
                                                <td>
                                                    <%=sdf.format(p.getActualDeadline())%>
                                                </td>
                                                <td style=text-align:center>
                                                    <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectStatus()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectReviewStatus()%>
                                                </td>
                                                <td>
                                                    <%=projTypeHash.get(p.getProjectType())%>
                                                </td>
                                            </tr> 
                                            <%
                                                    }
                                                }
                                            %>
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
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow: auto">
            <div class="container-fluid" style="text-align: left">
                <div class="container-fluid">
                    <table width="100%">
                        <tr>
                            <td align="left">
                                <h3>Ongoing Projects</h3>
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
                                                <th width="14%">Project Title</th>
                                                <th width="14%">Company Name</th>
                                                <th width="14%">Internal Timeline</th>
                                                <th width="14%">External Timeline</th>
                                                <th width="14%">Total Hours Spent</th>
                                                <th width="14%">Completion Status</th>
                                                <th width="14%">Review Status</th>
                                                <th width="14%">Project Type</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (incompletedProjectList != null && !incompletedProjectList.isEmpty()) {
                                                    for (int i = 0; i < incompletedProjectList.size(); i++) {
                                                        Project p = incompletedProjectList.get(i);
                                            %>
                                            <tr>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href=<%=profileUrl2%>>
                                                        <%=p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
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
                                                    <%=sdf.format(p.getEnd())%>
                                                </td>
                                                <td>
                                                    <%=sdf.format(p.getActualDeadline())%>
                                                </td>
                                                <td style='text-align:center'>
                                                    <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectStatus()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectReviewStatus()%>
                                                </td>
                                                <td>
                                                    <%=projTypeHash.get(p.getProjectType())%>
                                                </td>
                                            </tr>   
                                            <%
                                                    }
                                                }
                                            %>
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
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow: auto">
            <div class="container-fluid" style="text-align: left">
                <div class="container-fluid">
                    <table width="100%">
                        <tr>
                            <td align="left">
                                <h3>Completed Projects</h3>
                            </td>
                            <td align="right">
                                <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#pastjobcollapsible"></button>                       
                            </td>
                        </tr>
                    </table>
                    <table width="100%">
                        <tr>
                            <td>
                                <div id="pastjobcollapsible" class="collapse in">
                                    <table width="100%" style="cellpadding: 2%" id="datatable2">
                                        <thead>
                                            <tr>
                                                <th width="14%">Project Title</th>
                                                <th width="14%">Company Name</th>
                                                <th width="14%">Internal Timeline</th>
                                                <th width="14%">External Timeline</th>
                                                <th width="14%">Total Hours Spent</th>
                                                <th width="14%">Completion Status</th>
                                                <th width="14%">Review Status</th>
                                                <th width="14%">Project Type</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (completedProjectList != null && !completedProjectList.isEmpty()) {
                                                    for (int i = 0; i < completedProjectList.size(); i++) {
                                                        Project p = completedProjectList.get(i);
                                            %>
                                            <tr>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href=<%=profileUrl2%>>
                                                        <%=p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
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
                                                    <%=sdf.format(p.getEnd())%>
                                                </td>
                                                <td>
                                                    <%=sdf.format(p.getActualDeadline())%>
                                                </td>
                                                <td style=text-align:center>
                                                    <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectStatus()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectReviewStatus()%>
                                                </td>
                                                <td>
                                                    <%=projTypeHash.get(p.getProjectType())%>
                                                </td>
                                            </tr> 
                                            <%
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </br>
        </nav> 
    </body>
    <jsp:include page="Footer.html"/>
</html>
