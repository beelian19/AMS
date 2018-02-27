<%-- 
    Document   : TaskAdminOverview
    Created on : Feb 27, 2018, 11:53:03 PM
    Author     : jagdishps.2014
--%>

<%@page import="Entity.Task"%>
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
        <title>View All Tasks | Abundant Accounting Management System</title>
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
        <%            if (request.getAttribute("completedTask") == null) {
                //RequestDispatcher rd = request.getRequestDispatcher("AdminProjectServlet");
                //rd.forward(request, response);
                response.sendRedirect("ViewAllTaskAdmin");
                return;
            }
            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
            ArrayList<Task> overdueTaskList = (ArrayList<Task>) request.getAttribute("overdueTask");
            ArrayList<Task> completedTaskList = (ArrayList<Task>) request.getAttribute("completedTask");
            ArrayList<Task> incompletedTaskList = (ArrayList<Task>) request.getAttribute("incompleteTask");
            
            
            /*String profileUrl = "ProjectProfile.jsp?projectID=";
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
            */
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
                                <h3>Overdue Tasks</h3>
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
                                                <th width="25%">Task Title</th>
                                                <th width="25%">End Date</th>
                                                <th width="25%">Task Status</th>
                                                <th width="25%">Review Status</th>
                                               
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (overdueTaskList != null && !overdueTaskList.isEmpty()) {
                                                    for (int i = 0; i < overdueTaskList.size(); i++) {
                                                        Task t = overdueTaskList.get(i);

                                            %>
                                            <tr>
                                                <td>
                                                    
                                                        <%= t.getTaskTitle()%>
                                                    
                                                </td>
                                                
                                                <td>
                                                    <%=sdf.format(t.getEnd())%> 
                                                </td>
                                               
                                               
                                                <td>
                                                    <%=t.getTaskStatus()%>
                                                </td>
                                                <td>
                                                    <%=t.getReviewStatus()%>
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
                                <h3>Ongoing Tasks</h3>
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
                                                <th width="25%">Task Title</th>
                                                <th width="25%">End Date</th>
                                                <th width="25%">Task Status</th>
                                                <th width="25%">Review Status</th>
                                            </tr>
                                        </thead>
                                       <tbody>
                                            <%
                                                if (incompletedTaskList != null && !incompletedTaskList.isEmpty()) {
                                                    for (int i = 0; i < incompletedTaskList.size(); i++) {
                                                        Task t = incompletedTaskList.get(i);

                                            %>
                                            <tr>
                                                <td>
                                                    
                                                        <%= t.getTaskTitle()%>
                                                    
                                                </td>
                                                
                                                <td>
                                                    <%=sdf.format(t.getEnd())%> 
                                                </td>
                                               
                                               
                                                <td>
                                                    <%=t.getTaskStatus()%>
                                                </td>
                                                <td>
                                                    <%=t.getReviewStatus()%>
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
                                <h3>Completed Tasks</h3>
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
                                                 <th width="25%">Task Title</th>
                                                <th width="25%">End Date</th>
                                                <th width="25%">Task Status</th>
                                                <th width="25%">Review Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (completedTaskList != null && !completedTaskList.isEmpty()) {
                                                    for (int i = 0; i < completedTaskList.size(); i++) {
                                                        Task t = completedTaskList.get(i);

                                            %>
                                            <tr>
                                                <td>
                                                    
                                                        <%= t.getTaskTitle()%>
                                                    
                                                </td>
                                                
                                                <td>
                                                    <%=sdf.format(t.getEnd())%> 
                                                </td>
                                               
                                               
                                                <td>
                                                    <%=t.getTaskStatus()%>
                                                </td>
                                                <td>
                                                    <%=t.getReviewStatus()%>
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
