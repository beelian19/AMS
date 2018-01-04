<%-- 
    Document   : ProjectProfile
    Created on : Nov 15, 2017, 1:34:19 AM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="Entity.Task"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <%            if (request.getParameter("projectID") == null) {
                session.setAttribute("status", "Error: No project parsed at project profile page");
                response.sendRedirect("EmployeeProfile.jsp");
                return;
            }
            String pID = request.getParameter("projectID");
            Project p = ProjectDAO.getProjectByID(pID);

            ArrayList<ArrayList<Task>> taskList = ProjectDAO.getAllProjectTaskFiltered(p.getProjectID());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            Employee e = EmployeeDAO.getEmployeeByID((String) request.getSession().getAttribute("userId"));
            String name = e.getName();

            ProjectDAO projectDAO = new ProjectDAO();
            ArrayList<Project> projectList = projectDAO.getAllIncompleteAdhocProjects();

            boolean canComplete = false;
            boolean canReview = false;
            boolean isAdHoc = false;
            boolean isAdmin = e.getIsAdmin().equals("yes");
            if (p.getProjectStatus().equals("incomplete") && !p.getProjectReviewer().equals(name)) {
                canComplete = true;
            }
            if (p.getProjectStatus().equals("complete") && p.getProjectReviewStatus().equals("incomplete") && !(p.getEmployee1().equals(name)
                    || p.getEmployee2().equals(name))) {
                canReview = true;
            }
            if (p.getProjectStatus().equals("incomplete") && isAdmin) {
                canComplete = true;
            }
            if (p.getProjectReviewStatus().equals("incomplete") && isAdmin && p.getProjectStatus().equals("complete")) {
                canReview = true;
            }
            if (p.getProjectType().equals("adhoc")) {
                isAdHoc = true;
            }

            Employee emp1 = EmployeeDAO.getEmployee(p.getEmployee1());
            Employee emp2 = EmployeeDAO.getEmployee(p.getEmployee2());
            Employee rev = EmployeeDAO.getEmployee(p.getProjectReviewer());
            String clientProfileUrl = "ClientProfile.jsp?profileId=";
            String clientProfileUrl2 = "";
            String assignedEmployee1ProfileUrl = "StaffProfile.jsp?profileName=";
            String assignedEmployee2ProfileUrl = "StaffProfile.jsp?profileName=";
            String reviewerProfileUrl1 = "StaffProfile.jsp?profileName=";
            String reviewerProfileUrl2 = "";
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<String> supList = empDAO.getAllSupervisor();
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=p.getProjectTitle()%>&nbsp;Profile | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
                $('#datatable2').DataTable();
                $('#datatable3').DataTable();
                $('#datatable4').DataTable();
            });
        </script>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div>
                <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                    <jsp:include page="StatusMessage.jsp"/>
                    <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="margin-top: <%=session.getAttribute("margin")%>; overflow:auto">
                        <div class="container-fluid" style="text-align: center;">
                            <div class="container-fluid" align="center">
                                <h1><%=p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                    <i id="edit" class="material-icons">mode_edit</i>
                                </h1>
                                <table align="center" style="width: 50%">
                                    <tr>
                                        <td>
                                            <label>Status: </label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <%=p.getProjectStatus()%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Reviewer Status:  </label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <%=p.getProjectReviewStatus()%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Start Date:  </label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <%=sdf.format(p.getStart())%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>End Date: </label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <%=sdf.format(p.getEnd())%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>

                                    </tr>
                                    <!--Create Task is HERE!!!!!-->
                                    <tr>
                                        <td>
                                            <%
                                                if (isAdHoc) {
                                            %>
                                            <button id="create-task" style="font-size: 12px;">Create Task</button>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <!--Create Task is HERE!!!!!-->
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>

                                    </tr>
                                    <%
                                        if (canReview || canComplete) {
                                    %>
                                    <form action="UpdateProjectCompletionStatus" method="post">
                                        <tr>
                                            <td>
                                                <%
                                                    if (canReview) {
                                                %>

                                                <input type="submit" name="review" value="Review"/>
                                                <%
                                                    }
                                                %>
                                            </td>
                                            <td width="1%">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <%
                                                    if (canComplete) {
                                                %>
                                                <input type="submit" name="complete" value="Complete"/>
                                                <%
                                                    }
                                                %>

                                            </td>
                                        </tr>
                                        <input type='hidden' id='projectIden' value='<%=p.getProjectID()%>' name='projectIden'/>
                                    </form>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </table>
                            </div>
                        </div>

                </div>
            </div>
        </div>
    </nav>
</div>
</nav>
<nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow:auto">
    <div class="container-fluid" style="text-align: left">
        <div class="container-fluid">
            <table width="100%">
                <tr>
                    <td align="left">
                        <h3>Project Details</h3>
                    </td>
                    <td align="right">
                        <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#descriptioncollapsible"></button>
                    </td>
                </tr>
            </table>
            <!-- insert past jobs -->
            <table width="100%">
                <tr>
                    <td>
                        <div id="descriptioncollapsible" class="collapse in">
                            <table width="100%" style="cellpadding: 1%">
                                <tr>
                                    <td>
                                        <label>Company Name: </label>
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
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label>Business Type: </label>
                                    </td>
                                    <td>
                                        <%=p.getBusinessType()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>Project Type: </label>
                                    </td>
                                    <td>
                                        <%=p.getProjectType()%>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label>No. of Invoices</label>
                                    </td>
                                    <td>
                                        <!--<=%p.getNumberOfInvoices()%>-->
                                        Wait for Yumai for Number of Invoices
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>Reviewer: </label>
                                    </td>
                                    <td>
                                        <%
                                            reviewerProfileUrl2 = reviewerProfileUrl1 + rev.getEmployeeID();
                                            //System.out.println(reviewerProfileUrl2);
%>
                                        <a href='<%=reviewerProfileUrl2%>'>
                                            <%=p.getProjectReviewer()%>
                                        </a>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label>Remarks</label>
                                    </td>
                                    <td>
                                        <%=p.getProjectRemarks()%>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <br/>
    </div>
</nav>
<nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow:auto">
    <div class="container-fluid" style="text-align: left">
        <div class="container-fluid">
            <table width="100%">
                <tr>
                    <td align="left">
                        <h3>Project Hours</h3>
                    </td>
                    <td align="right">
                        <button type="button" class="glyphicon glyphicon-minus" data-toggle="collapse" data-target="#projectHourscollapsible"></button>
                    </td>
                </tr>
            </table>
            <!-- insert past jobs -->
            <table width="100%">
                <tr>
                    <td>
                        <div id="projectHourscollapsible" class="collapse in">
                            <form action="UpdateProjectHours" method="post" id="my_form">
                                <table width="100%" style="cellpadding: 1%">
                                    <tr>
                                        <td>
                                            <label>Assigned Employee 1: </label>
                                        </td>
                                        <td>
                                            <%

                                                if (!p.getEmployee1().equals("NA")) {
                                                    assignedEmployee1ProfileUrl = assignedEmployee1ProfileUrl + emp1.getEmployeeID();
                                            %>

                                            <a href='<%=assignedEmployee1ProfileUrl%>'>
                                                <%=p.getEmployee1()%>
                                            </a>
                                            <%
                                            } else {
                                            %>

                                            <label> <%=p.getEmployee1()%> </label>

                                            <%
                                                }
                                            %>
                                        </td>
                                        <td width="1%">
                                        </td>
                                        <td>
                                            <label>Assigned Employee 2: </label>
                                        </td>
                                        <td>
                                            <%
                                                if (emp2 != null && !p.getEmployee2().equals("NA")) {
                                                    assignedEmployee2ProfileUrl = assignedEmployee2ProfileUrl + emp2.getEmployeeID();
                                            %>
                                            <a href='<%=assignedEmployee2ProfileUrl%>'>
                                                <%=p.getEmployee2()%>
                                            </a>
                                            <%
                                            } else {
                                            %>

                                            <label> <%=p.getEmployee2()%> </label>

                                            <%
                                                }
                                            %>    
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>Employee 1 Hours Spent: </label>
                                        </td>
                                        <td>
                                            <input type="number" step="0.1" min="0" name="employee1Hours" id="employee1Hours" placeholder='<%=p.getEmployee1Hours()%>' value='<%=p.getEmployee1Hours()%>'>
                                        </td>
                                        <td width="1%">
                                        </td>
                                        <td>
                                            <label>Employee 2 Hours Spent:: </label>
                                        </td>
                                        <% if (p.getEmployee2().toLowerCase().contains("na")) {

                                        %>
                                        <td>
                                            <input disabled type="number" step="0.1" min="0" name="employee2Hours" id="employee2Hours" placeholder='<%=p.getEmployee2Hours()%>'  value='<%=p.getEmployee2Hours()%>'>
                                        </td>
                                        <%
                                        } else {
                                        %>
                                        <td>
                                            <input type="number" step="0.1" min="0" name="employee2Hours" id="employee2Hours" placeholder='<%=p.getEmployee2Hours()%>'  value='<%=p.getEmployee2Hours()%>'>
                                        </td>
                                        <%
                                            }
                                        %>

                                    </tr>
                                    <tr>
                                        <td colspan="5">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type='hidden' id='projectIden' value='<%=p.getProjectID()%>' name='projectIden'/>
                                            <button style="font-size: 10.5px;">Update Hours</button>
                                        </td>
                                    </tr>
                                </table>
                                <!--<input type='hidden'  id='projectIden' name='projectIden' value='<=p.getProjectID()%>'/>
                                <input type="submit" value="Submit"/>-->
                            </form>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <br/>
    </div>
</nav>                 
<nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow:auto">
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
                                        <th width="20%">Task Title</th>
                                        <th width="20%">Start Date</th>
                                        <th width="20%">End Date</th>
                                        <th width="20%">Reviewer</th>
                                        <th width="20%">Remarks</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (taskList != null) {
                                            for (int i = 0; i < taskList.get(0).size(); i++) {
                                                Task t = taskList.get(0).get(i);
                                    %>
                                    <tr>
                                        <td>
                                            <%=t.getTaskTitle()%>
                                        </td>
                                        <td>
                                            <%=t.getStart()%>
                                        </td>
                                        <td>
                                            <%=t.getEnd()%>
                                        </td>
                                        <td>
                                            <%
                                                reviewerProfileUrl2 = reviewerProfileUrl1 + t.getReviewer();
                                            %>
                                            <a href='<%=reviewerProfileUrl2%>'>
                                                <%=t.getReviewer()%>
                                            </a>
                                        </td>
                                        <td>
                                            <%=t.getTaskRemarks()%>
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
<nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow:auto">
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
                                        <th width="20%">Task Title</th>
                                        <th width="20%">Start Date</th>
                                        <th width="20%">End Date</th>
                                        <th width="20%">Reviewer</th>
                                        <th width="20%">Remarks</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (taskList != null) {
                                            for (int i = 0; i < taskList.get(1).size(); i++) {
                                                Task t = taskList.get(1).get(i);
                                    %>
                                    <tr>
                                        <td>
                                            <%=t.getTaskTitle()%>
                                        </td>
                                        <td>
                                            <%=t.getStart()%>
                                        </td>
                                        <td>
                                            <%=t.getEnd()%>
                                        </td>
                                        <td>
                                            <%
                                                reviewerProfileUrl2 = reviewerProfileUrl1 + t.getReviewer();
                                            %>
                                            <a href='<%=reviewerProfileUrl2%>'>
                                                <%=t.getReviewer()%>
                                            </a>
                                        </td>
                                        <td>
                                            <%=t.getTaskRemarks()%>
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
<nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page" style="overflow:auto">
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
                                        <th width="20%">Task Title</th>
                                        <th width="20%">Start Date</th>
                                        <th width="20%">End Date</th>
                                        <th width="20%">Reviewer</th>
                                        <th width="20%">Remarks</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (taskList != null) {
                                            for (int i = 0; i < taskList.get(2).size(); i++) {
                                                Task t = taskList.get(2).get(i);
                                    %>
                                    <tr>
                                        <td>
                                            <%=t.getTaskTitle()%>
                                        </td>   
                                        <td>
                                            <%=t.getStart()%>
                                        </td>
                                        <td>
                                            <%=t.getEnd()%>
                                        </td>
                                        <td>
                                            <%
                                                reviewerProfileUrl2 = reviewerProfileUrl1 + t.getReviewer();
                                            %>
                                            <a href='<%=reviewerProfileUrl2%>'>
                                                <%=t.getReviewer()%>
                                            </a>
                                        </td>
                                        <td>
                                            <%=t.getTaskRemarks()%>
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
<script>
    $('#edit').click(function () {
        $('#editProfileModal').modal();
    });
</script>
<!-- Start of Modal -->
<div id="editProfileModal" class="modal fade" role="dialog">
    <!-- Modal content -->
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <span id="eventTitle">Edit Details</span>
                </h4>
            </div>
            <div class="modal-body" align="left">
                <form>
                    <table>
                        <fieldset>
                            <tr>
                                <td>
                                    <label for="companyName">Company Name&nbsp;<font color="red">*</font></label>
                                    <input type="hidden" name="projectIDEdit" id="projectIDEdit" value="<%=p.getProjectID()%>"/>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="companyNameEdit" id="officeCcompanyNameEditontactEdit" value="<%=p.getCompanyName()%>" class="text ui-widget-content ui-corner-all" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="projectTitle">Project Title&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="projectTitleEdit" id="projectTitleEdit" value="<%=p.getProjectTitle()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="businessType">Business Type&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="businessTypeEdit" id="businessTypeEdit" value="<%=p.getBusinessType()%>" class="text ui-widget-content ui-corner-all" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="projectStart">Start Date&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="projectStartEdit" id="projectStartEdit" placeholder="yyyy-MM-dd" value="<%=p.getStart()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                            <tr>
                                <td>
                                    <label for="projectEnd">End Date&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="projectEndEdit" id="projectEndEdit" placeholder="yyyy-MM-dd" value="<%=p.getEnd()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>  
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="projectRemarks">Project Remarks&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <textarea name="projectRemarksEdit" id="projectRemarksEdit" value="<%=p.getProjectRemarks()%>" class="text ui-widget-content ui-corner-all" cols="22" rows="3" style='display: block; width:100%'><%=p.getProjectRemarks()%></textarea>
                                </td> 
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="emp1">Assigned Employee 1&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='emp1Edit' id="emp1Edit" class="form-control" required autofocus>
                                        <option value="<%=p.getEmployee1()%>"><%=p.getEmployee1()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < supList.size(); i++) {
                                                if (!supList.get(i).equals(p.getEmployee1())) {
                                                    out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="emp2">Assigned Employee 2&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='emp2Edit' id="emp2Edit" class="form-control" required autofocus>
                                        <option value="<%=p.getEmployee2()%>"><%=p.getEmployee2()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < supList.size(); i++) {
                                                if (!supList.get(i).equals(p.getEmployee2())) {
                                                    out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                                }
                                            }
                                        %>
                                        <option value="na">NA</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="projectReviewer">Project Reviewer&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='projectReviewerEdit' id="projectReviewerEdit" class="form-control" required autofocus>
                                        <option value="<%=p.getProjectReviewer()%>"><%=p.getProjectReviewer()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < supList.size(); i++) {
                                                if (!supList.get(i).equals(p.getProjectReviewer())) {
                                                    out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td width="1%" colspan="2">
                                    &nbsp;
                                </td>
                                <td style="text-align: right">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    <button type="button" id="btnSave" class="btn btn-success">Save</button>
                                </td>
                            </tr>
                        </fieldset>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>

<!--Task Modal-->
<div id="myModalTask" class="modal fade" role="dialog">
    <!-- Modal content -->
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <span id="eventTitle">Add New Task</span>
                </h4>
            </div>
            <div class="modal-body" align="left">
                <form>
                    <fieldset>
                        <table>
                            <!--companyName-->
                            <!--<tr>
                                <td>
                                    <label for="companyName">Company Name&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='companyNameCreate' id="companyNameCreate" class="form-control" required autofocus>

                                        <
                                            if (projectList != null && projectList.size() != 0) {
                                                ArrayList<String> compNameList = new ArrayList<>();
                                                for (int i = 0; i < projectList.size(); i++) {
                                                    String companyName = projectList.get(i).getCompanyName();
                                                    //System.out.println("JSP companyName: "+companyName+"-"+companyName.length());
                                                    compNameList.add(companyName);
                                                }

                                                Set<String> compNames = new HashSet<>(compNameList);
                                                //System.out.println("Set size: " + compNames.size());
                                                for (String company : compNames) {
                                                    //System.out.println(name);
                                        %>                                                             
                                        <option value='<=company%>'><=company%></option>
                            <
                                }
                            }
                            %>
                        </select>
                    </td
                     m>
                </tr>
                <tr>
                    <td colspan="3">
                        &nbsp;
                    </td>
                </tr>
                            <!--companyName-->

                            <!--Ad Hoc Projects-->
                            <!--<tr>
                                <td>
                                    <label for="projects">Projects&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='projectCreate' id="projectCreate" class="form-control" required autofocus>

                                        <
                                            if (projectList != null && projectList.size() != 0) {
                                                for (int i = 0; i < projectList.size(); i++) {
                                                    String projTitle = projectList.get(i).getProjectTitle();
                                                    String companyName = projectList.get(i).getCompanyName();
                                        %>

                                        <option value='<=companyName%>'><=projTitle%></option>
                                        <
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--Ad Hoc Projects-->

                            <!--Task title-->
                            <tr>
                                <td>
                                    <label for="title">Task Title&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="titleCreate" id="titleCreate" class="text ui-widget-content ui-corner-all" required>
                                    <input type="hidden" name="projectIDCreate" id="projectIDCreate" value="<%=p.getProjectID()%>"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--Task title-->

                            <!--Start Date-->
                            <tr>
                                <td>
                                    <label for="startDate">Start Date&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="date" name="startDateCreate" id="startDateCreate" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--Start Date-->

                            <!--End Date-->
                            <tr>
                                <td>
                                    <label for="endDate">End Date&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="date" name="endDateCreate" id="endDateCreate" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--End Date-->

                            <!--Task Reviewer-->
                            <tr>
                                <td>
                                    <label for="reviewer">Task Reviewer&nbsp<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='reviewerCreate' id="reviewerCreate" class="form-control" required autofocus>
                                        <option disabled selected value> — select an option — </option>
                                        <%
                                            for (int i = 0; i < supList.size(); i++) {
                                                out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--Task Reviewer-->

                            <!--remarks-->
                            <tr>
                                <td>
                                    <label for="remarks">Task Remarks</label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <textarea name="remarkCreate" id="remarkCreate" class="text ui-widget-content ui-corner-all" cols="40" rows="5"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <!--remarks-->

                            <tr>
                                <td width="1%" colspan="2">
                                    &nbsp;
                                </td>
                                <td style="text-align: right">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    <button type="button" id="btnSaveTask" class="btn btn-success">Submit</button>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>                                    
<script>
    $("#create-task").click(function () {
        $('#myModalTask').modal();
    });
    $('#btnSaveTask').click(function () {
        //var companyName = document.getElementById("companyNameCreate").value;
        //var project = $("#projectCreate option:selected").html();
        var projectId = document.getElementById("projectIDCreate").value;
        var taskTitle = document.getElementById("titleCreate").value;
        var start = document.getElementById("startDateCreate").value;
        var end = document.getElementById("endDateCreate").value;
        var taskReviewer = document.getElementById("reviewerCreate").value;
        var taskRemarks = document.getElementById("remarkCreate").value;

        //if (project == "") {
            //alert("Project Field Required");
            //return;
        //}
        if (taskTitle == "") {
            alert("Title Field Required");
            return;
        }
        if (start == "") {
            alert("Start Date Required");
            return;
        }
        if (end == "") {
            alert("End Date Required");
            return;
        }
        if (start > end) {
            alert('Invalid End Date');
            return;
        }
        if (taskReviewer == "") {
            alert("Reviewer Required");
            return;
        }
        if (taskRemarks == "") {
            alert("Remarks Required (NA if not applicable)");
            return;
        } else {
            $.ajax({
                url: 'CreateTaskAdmin',
                data: 'projectId=' + projectId + '&' + 'title=' + taskTitle + '&' + 'start=' + start + '&' + 'end=' + end + '&' + 'remarks=' + taskRemarks + '&' + 'reviewer=' + taskReviewer,
                type: 'POST',
                success: function () {
                    //$('#calendar').fullCalendar('refetchEvents');
                    alert('Task Added');
                    $('#myModalTask').modal('hide');
                    location.reload();
                }
            });
        }
    }
    );
    $('#btnSave').click(function () {
        if ($('#projectTitleEdit').val().trim() == "") {
            alert("Project Title Required");
            return;
        }
        if ($('#projectStartEdit').val().trim() == "") {
            alert("Start Date Required");
            return;
        }
        if ($('#projectEndEdit').val().trim() == "") {
            alert("End Date Required");
            return;
        }
        if ($('#projectRemarksEdit').val().trim() == "") {
            alert("Remarks Required");
            return;
        }
        if ($('#emp1Edit').val().trim() == "") {
            alert("Assigned Employee 1 Required");
            return;
        }
        if ($('#emp2Edit').val().trim() == "") {
            alert("Assigned Employee 2 Required");
            return;
        }
        if ($('#projectReviewerEdit').val().trim() == "") {
            alert("Reviewer Required");
            return;
        } else {
            var projectID = $('#projectIDEdit').val();
            var projectTitle = $('#projectTitleEdit').val();
            var startDate = $('#projectStartEdit').val();
            var endDate = $('#projectEndEdit').val();
            var projectRemarks = $('#projectRemarksEdit').val();
            var emp1 = $('#emp1Edit').val();
            var emp2 = $('#emp2Edit').val();
            var projectReviewer = $('#projectReviewerEdit').val();


            $.ajax({
                type: 'POST',
                data: 'projectID=' + projectID + '&' + 'projectTitle=' + projectTitle + '&' + 'startDate=' + startDate + '&' + 'endDate=' + endDate + '&' + 'projectRemarks=' + projectRemarks + '&' + 'emp1=' + emp1 + '&' + 'emp2=' + emp2 + '&' + 'projectReviewer=' + projectReviewer,
                url: 'UpdateProject',
                success: function () {
                    location.reload();
                    alert('Details Updated');
                    $('#editProfileModal').modal('hide');
                },
                error: function () {
                    alert('Fail to Edit Details');
                }
            })
        }
        $('#editProfileModal').modal('hide');
    });
</script>
</body>
<!-- End of Modal-->
<jsp:include page="Footer.html"/>
</html>