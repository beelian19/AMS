<%--
    Document   : AdminHome.jsp
    Created on : Dec 24, 2017, 3:44:19 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.Client"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="Entity.Project"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>
<%@include file="AdminAccessOnly.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Home Page | Abundant Accounting Management System</title>
        <%            
            EmployeeDAO empDAO = new EmployeeDAO();
            ProjectDAO projectDAO = new ProjectDAO();
            ArrayList<Client> clientList = ClientDAO.getAllClient();
            ArrayList<Project> projectList = projectDAO.getAllIncompleteAdhocProjects();
            ArrayList<String> supList = empDAO.getAllSupervisor();
        %>
    </head>
    <body width="100%" style='background-color: #FFFFFF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>; margin-bottom: 5%">
                    <nav class="container-fluid" width="100%" height="100%">
                        <div class="container-fluid" align="center" style="width: 80%; height: 80%">
                            <!--<div align="right" style="margin-bottom: 1%">
                                <button id="create-task" style="font-size: 12px;">Create Task</button>
                                <button id="create-adhoc" style="font-size: 12px;">Create Ad hoc Project</button>
                            </div>-->
                            <!-- insert calendar here -->
                            <div id='calendar' align="center"></div>
                            <div style="text-align: center; padding-top: 1%">
                                <div align="center">
                                    <table style="width: 100%">
                                        <tr>
                                        <div align="left" style="width: 70%">
                                            <td style="width: 2%; text-align: left; float: bottom;">
                                                <strong>Legend:&emsp;</strong>
                                            </td>
                                            <td style="background-color: #FFD700; text-align: center; width: 18%" align="left">
                                                Incomplete
                                            </td>
                                            <td style="background-color: #6495ED; text-align: center; width: 18%" align="left">
                                                Waiting for review
                                            </td>
                                            <td style="background-color: #32CD32; text-align: center; width: 18%" align="left">
                                                Completed
                                            </td>
                                        </div>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <!-- Start of Modal -->
                            <div id="myModalAdHoc" class="modal fade" role="dialog">
                                <!-- Modal content -->
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">
                                                <span id="eventTitle"></span>
                                            </h4>
                                        </div>
                                        <div class="modal-body" align='left'>
                                            <button id='btnDelete' class='btn btn-default btn-sm pull-right'>
                                                <span class='glyphicon glyphicon-remove'></span> Remove
                                            </button>
                                            <button id='btnEdit' class='btn btn-default btn-sm pull-right' style='margin-right:5px;'>
                                                <span class='glyphicon glyphicon-pencil'></span> Edit
                                            </button>
                                            <p id="pDetails"></p>
                                        </div>
                                        <div class="modal-footer">
                                            <!--<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
                                            <button id='btnComplete' class='btn btn-default' style='margin-right:5px;'>
                                                Complete
                                            </button>
                                            <button id='btnReview' class='btn btn-default' style='margin-right:5px;'>
                                                Review
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End of Modal-->
                            <!-- Start of Modal -->
                            <div id="myModalCompanyProject" class="modal fade" role="dialog">
                                <!-- Modal content -->
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">
                                                <span id="eventTitle"></span>
                                            </h4>
                                        </div>
                                        <div class="modal-body" align='left'>
                                            <p id="pDetails"></p>
                                        </div>
                                        <div class="modal-footer">

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End of Modal-->
                            <!-- Start of Modal -->
                            <div id="myModalSave" class="modal fade" role="dialog">
                                <!-- Modal content -->
                                <div class="modal-dialog">
                                    <div class="modal-content" style="width:80%">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">
                                                <span id="eventTitle"></span>
                                            </h4>
                                        </div>
                                        <div class="modal-body" align="left">
                                            <form>
                                                <fieldset>
                                                    <!--Title-->
                                                    <label>Title&nbsp<font color="red">*</font></label>
                                                    <input type="text" name="titleEdit" id="titleEdit" class="text ui-widget-content ui-corner-all" required>

                                                    <!--Company Name-->
                                                    <label>Company Name&nbsp</label>
                                                    <input type="text" name="companyNameEdit" id="companyNameEdit" class="text ui-widget-content ui-corner-all" required readonly>

                                                    <!--Start Date-->
                                                    <label for="startDate">Start Date&nbsp<font color="red">*</font></label>
                                                    <input type="text" name="startDateEdit" id="startDateEdit" placeholder="dd/MM/yyyy" class="text ui-widget-content ui-corner-all" required>

                                                    <!--End Date-->
                                                    <label for="endDate">End Date&nbsp<font color="red">*</font></label>
                                                    <input type="text" name="endDateEdit" id="endDateEdit" placeholder="dd/MM/yyyy" class="text ui-widget-content ui-corner-all" required>

                                                    <label>Remarks&nbsp<font color="red">*</font></label><br>
                                                    <textarea name="remarksEdit" id="remarksEdit" class="text ui-widget-content ui-corner-all" cols="56" rows="5"></textarea>
                                                </fieldset>
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                <button type="button" id="btnSave" class="btn btn-success">Save</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End of Modal-->
                        </div>
                    </nav>
                </div>
            </div>
        </nav>

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
                                    <tr>
                                        <td>
                                            <label for="companyName">Company Name&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='companyNameCreate' id="companyNameCreate" class="form-control" required autofocus>

                                                <%
                                                    if (projectList != null && projectList.size() != 0) {
                                                        ArrayList<String> compNameList = new ArrayList<>();
                                                        for (int i = 0; i < projectList.size(); i++) {
                                                            String companyName = projectList.get(i).getCompanyName();
                                                            //System.out.println("JSP companyName: "+companyName+"-"+companyName.length());
                                                            compNameList.add(companyName);
                                                        }

                                                        Set<String> compNames = new HashSet<>(compNameList);
                                                        //System.out.println("Set size: " + compNames.size());
                                                        for (String name : compNames) {
                                                            //System.out.println(name);
%>                                                             
                                                <option value='<%=name%>'><%=name%></option>
                                                <%
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
                                    <!--companyName-->

                                    <!--Ad Hoc Projects-->
                                    <tr>
                                        <td>
                                            <label for="projects">Projects&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='projectCreate' id="projectCreate" class="form-control" required autofocus>

                                                <%
                                                    if (projectList != null && projectList.size() != 0) {
                                                        for (int i = 0; i < projectList.size(); i++) {
                                                            String projTitle = projectList.get(i).getProjectTitle();
                                                            String companyName = projectList.get(i).getCompanyName();
                                                %>

                                                <option value='<%=companyName%>'><%=projTitle%></option>
                                                <%
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
                                                    for (int i = 0;
                                                            i < supList.size();
                                                            i++) {
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

        <!--Project Modal-->
        <div id="myModalProject" class="modal fade" role="dialog">
            <!-- Modal content -->
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                            <span id="eventTitle">Add New Ad Hoc Project</span>
                        </h4>
                    </div>
                    <div class="modal-body" align="left">
                        <form>
                            <fieldset>
                                <table>
                                    <!--Project title-->
                                    <tr>
                                        <td>
                                            <label for="titleProject">Project Title&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="text" name="titleProjectCreate" id="titleProjectCreate" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <!--Project title-->

                                    <!--companyName-->
                                    <tr>
                                        <td>
                                            <label for="companyNameProject">Company Name&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='companyProjectCreate' id="companyProjectCreate" class="form-control" required autofocus>
                                                <option disabled selected value> — select an option — </option>
                                                <%
                                                    for (int i = 0; i < clientList.size(); i++) {
                                                        out.println("<option value='" + clientList.get(i).getCompanyName() + "'>" + clientList.get(i).getCompanyName() + "</option>");
                                                    }
                                                %>
                                                <option value="Others">Others</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <!--companyName-->

                                    <!--Start Date-->
                                    <tr>
                                        <td>
                                            <label for="startDateProject">Start Date&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="date" name="startDateProjectCreate" id="startDateProjectCreate" class="text ui-widget-content ui-corner-all" required>
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
                                            <label for="endDateProject">End Date&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="date" name="endDateProjectCreate" id="endDateProjectCreate" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <!--End Date-->

                                    <!--Emp1-->
                                    <tr>
                                        <td>
                                            <%
                                                if (supList != null && supList.size() != 0) {
                                            %>
                                            <label for="assignEmployeeProject">Assign First Employee&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='assignEmployeeProjectCreate' id="assignEmployeeProjectCreate" class="form-control" required autofocus>
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
                                    <!--Emp1-->

                                    <!--Emp2-->
                                    <tr>
                                        <td>
                                            <label for="assignEmployee1Project">Assign Second Employee&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='assignEmployee1ProjectCreate' id="assignEmployee1ProjectCreate" class="form-control" required autofocus>
                                                <option disabled selected value> — select an option — </option>
                                                <%
                                                    for (int i = 0; i < supList.size(); i++) {
                                                        out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                                    }
                                                %>
                                                <option value="na">NA</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <!--Emp2-->

                                    <!--Project Reviewer-->
                                    <tr>
                                        <td>
                                            <label for="reviewerProject">Project Reviewer&nbsp<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <select name='reviewerProjectCreate' id="reviewerProjectCreate" class="form-control" required autofocus>
                                                <option disabled selected value> — select an option — </option>
                                                <%
                                                        for (int j = 0; j < supList.size(); j++) {
                                                            out.println("<option value='" + supList.get(j) + "'>" + supList.get(j) + "</option>");
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
                                    <!--Project Reviewer-->

                                    <!--Project remarks-->
                                    <tr>
                                        <td>
                                            <label for="remarksProject">Project Remarks</label><br>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <textarea name="remarkProjectCreate" id="remarkProjectCreate" class="text ui-widget-content ui-corner-all" cols="40" rows="5"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <!--Project remarks-->

                                    <tr>
                                        <td width="1%" colspan="2">
                                            &nbsp;
                                        </td>
                                        <td style="text-align: right">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <button type="button" id="btnSaveAdhoc" class="btn btn-success">Submit</button>
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
            $(document).ready(function () {
                var selectedEvent = null;
                GenerateCalendar();
                function GenerateCalendar() {
                    var calendar = $('#calendar').fullCalendar({
                        businessHours: {
                            // days of week. an array of zero-based day of week integers (0=Sunday)
                            dow: [1, 2, 3, 4, 5], // Monday - Friday
                            start: '09:00', // a start time (10am )
                            end: '17:00', // an end time (6pm)
                        },
                        header: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'month,listMonth'
                        },
                        displayEventTime: false,
                        selectable: true,
                        selectHelper: true,
                        editable: false,
                        eventLimit: true,
                        views: {
                            agenda: {
                                eventLimit: 5 // adjust to 6 only for agendaWeek/agendaDay
                            }
                        },
                        fixedWeekCount: false,
                        events: "DisplayProjectForAdminHome",
                        eventAfterRender: function (event, element, view) {
                            //when project first created yellow color
                            var taskStatus = event.taskStatus;
                            var taskReviewStatus = event.reviewStatus;
                            var projectStatus = event.projectStatus;
                            var projectReviewStatus = event.projectReviewStatus;
                            if (taskStatus !== "NA" || taskReviewStatus !== "NA") {
                                if (taskStatus === "incomplete" && taskReviewStatus === "incomplete") {
                                    //console.log("Yellow");
                                    element.css('background-color', '#FFD700');
                                    element.css('color', '#000000');
                                } else if (taskStatus === "complete" && taskReviewStatus === "incomplete") {
                                    //when project completed by employee but havent review blue
                                    //console.log("Blue");
                                    element.css('background-color', '#6495ED');
                                    element.css('color', '#000000');
                                } else if (taskStatus === "complete" && taskReviewStatus === "complete") {
                                    //when both status is complete green color 
                                    //console.log("Green");
                                    element.css('background-color', '#32CD32');
                                    element.css('color', '#000000');
                                }
                            } else {//This is a company project
                                if (projectStatus === "incomplete" && projectReviewStatus === "incomplete") {
                                    element.css('background-color', '#FFD700');
                                    element.css('color', '#000000');
                                } else if (projectStatus === "complete" && projectReviewStatus === "incomplete") {
                                    //when project completed by employee but havent review blue
                                    element.css('background-color', '#6495ED');
                                    element.css('color', '#000000');
                                } else if (projectStatus === "complete" && projectReviewStatus === "complete") {
                                    //when both status is complete green color 
                                    element.css('background-color', '#32CD32');
                                    element.css('color', '#000000');
                                }
                            }
                        },
                        eventClick: function (calEvent, jsEvent, view) {
                            selectedEvent = calEvent;
                            var taskStatus = calEvent.taskStatus;
                            var projectType = calEvent.projectType;
                            //console.log("Check: " + projectType);
                            if (projectType === 'adhoc') {
                                $('#myModalAdHoc #eventTitle').text("Task Overview");
                                var $description = $('<div/>');
                                $description.append($('<p/>').html('<b>Title: </b><a href=ProjectProfile.jsp?projectID=' + calEvent.projectID + '>' + calEvent.title + '</a>'));
                                $description.append($('<p/>').html('<b>Company Name: </b>' + calEvent.companyName));
                                $description.append($('<p/>').html('<b>Assigned Employees: </b>' + calEvent.assignedEmployee1 + ' & ' + calEvent.assignedEmployee2));

                                $description.append($('<p/>').html('<b>Project Reviewer: </b>' + calEvent.projectReviewer));
                                $description.append($('<p/>').html('<b>Task Reviewer: </b>' + calEvent.reviewer));
                                $description.append($('<p/>').html('<b>Project Remarks:</b></br>' + calEvent.projectRemarks));
                                $description.append($('<p/>').html('<b>Task Remarks:</b></br>' + calEvent.taskRemarks));

                                $('#myModalAdHoc #pDetails').empty().html($description);
                                $('#myModalAdHoc').modal();
                            } else {
                                $('#myModalCompanyProject #eventTitle').text("Project Overview");
                                var $description = $('<div/>');
                                $description.append($('<p/>').html('<b>Title: </b><a href=ProjectProfile.jsp?projectID=' + calEvent.projectID + '>' + calEvent.title + '</a>'));
                                $description.append($('<p/>').html('<b>Company Name: </b>' + calEvent.companyName));
                                $description.append($('<p/>').html('<b>Assigned Employees: </b>' + calEvent.assignedEmployee1 + ' & ' + calEvent.assignedEmployee2));
                                if (projectType === 'tax') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>Tax'));
                                } else if (projectType === 'eci') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>ECI'));
                                } else if (projectType === 'gst') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>GST'));
                                } else if (projectType === 'management') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>Management'));
                                } else if (projectType === 'final') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>Final Accounting'));
                                } else if (projectType === 'secretarial') {
                                    $description.append($('<p/>').html('<b>Project Type: </b>Secretarial'));
                                }

                                $description.append($('<p/>').html('<b>Project Reviewer: </b>' + calEvent.projectReviewer));
                                $description.append($('<p/>').html('<b>Project Remarks:</b></br>' + calEvent.projectRemarks));
                                $('#myModalCompanyProject #pDetails').empty().html($description);
                                $('#myModalCompanyProject').modal();
                            }

                        },
                        eventMouseover: function (calEvent, jsEvent) {
                            var tooltip;
                            var projectType = calEvent.projectType;
                            var taskStatus = calEvent.taskStatus;
                            if (taskStatus === 'NA') {
                                if (projectType === 'tax') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> Tax<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                } else if (projectType === 'eci') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> ECI<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                } else if (projectType === 'gst') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> GST<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                } else if (projectType === 'management') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> Management<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                } else if (projectType === 'final') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> Final Accounting<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                } else if (projectType === 'secretarial') {
                                    tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                            "<b>Project Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                            "<b>Project Type: </b> Secretarial<br>" + "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 +
                                            "<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                            "<b>Project Remarks: </b> " + calEvent.projectRemarks + "<br>" +
                                            '</div>';
                                }
                            } else {
                                tooltip = '<div class="tooltipevent" style="width:400px;height:180px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                        "<b>Task Title: </b> " + calEvent.title + "<br>" + "<b>Company Name: </b> " + calEvent.companyName + "<br>" +
                                        "<b>Project Type: </b> Ad Hoc<br>" + "<b>Project Reviewer: </b>" + calEvent.projectReviewer + "<br>" +
                                        "<b>Employees Assigned: </b>" + calEvent.employee1 + " & " + calEvent.employee2 + "<br>" +
                                        "<b>Task Reviewer: </b> " + calEvent.reviewer + "<br>" + "<b>Task Remarks: </b> " + calEvent.taskRemarks + "<br>" +
                                        '</div>';
                            }

                            $("body").append(tooltip);
                            $(this).mouseover(function (e) {
                                $(this).css('z-index', 10000);
                                $('.tooltipevent').fadeIn('500');
                                $('.tooltipevent').fadeTo('10', 1.9);
                            }).mousemove(function (e) {
                                $('.tooltipevent').css('top', e.pageY + 10);
                                $('.tooltipevent').css('left', e.pageX + 20);
                            });
                        },
                        eventMouseout: function (calEvent, jsEvent) {
                            $(this).css('z-index', 8);
                            $('.tooltipevent').remove();
                        }
                    });
                    $('#btnEdit').click(function () {
                        //Open modal dialog to edit project
                        if (selectedEvent != null) {
                            var taskID = selectedEvent.taskID;
                            $('#myModalSave #eventTitle').text("Update Info");
                            $('#titleEdit').val(selectedEvent.title);
                            $('#companyNameEdit').val(selectedEvent.companyName);
                            $('#startDateEdit').val(selectedEvent.start.format("DD/MM/YYYY"));
                            if (selectedEvent.end !== null) {
                                var ending = $.fullCalendar.formatDate(selectedEvent.end, "DD/MM/YYYY");
                                var date = ending.substr(0, 2) - 1;
                                var monthYear = ending.substr(3, 10);
                                ending = date + "/" + monthYear;
                                $('#endDateEdit').val(ending);
                            }
                            $('#assignEmployeeEdit').val(selectedEvent.assignedEmployee1);
                            $('#assignEmployee1Edit').val(selectedEvent.assignedEmployee2);
                            if (taskID === "NA") {
                                $('#reviewerEdit').val(selectedEvent.projectReviewer);
                                $('#remarksEdit').val(selectedEvent.projectRemarks);
                            } else {
                                $('#reviewerEdit').val(selectedEvent.reviewer);
                                $('#remarksEdit').val(selectedEvent.taskRemarks);
                            }
                        }
                        $('#myModal').modal('hide');
                        $('#myModalSave').modal();
                    });
                    $('#btnSave').click(function () {
                        //Validation
                        if ($('#titleEdit').val().trim() == "") {
                            alert('Title Required');
                            return;
                        }
                        if ($('#companyNameEdit').val().trim() == "") {
                            alert('Title Required');
                            return;
                        }
                        if ($('#startDateEdit').val().trim() == "") {
                            alert("Start Date Required");
                            return;
                        }
                        if ($('#endDateEdit').val().trim() == "") {
                            alert("End Date Required");
                            return;
                        }

                        /*if ($('#startDateEdit').val().trim() > $('#endDateEdit').val().trim()) {
                         alert('Invalid End Date');
                         return;
                         }*/
                        if ($('#remarksEdit').val().trim() == "") {
                            alert('Remarks Required');
                            return;
                        } else {

                            var title = $('#titleEdit').val();
                            var companyName = $('#companyName').val();
                            //var project = $('#projectEdit').val();
                            var start = $('#startDateEdit').val();
                            var end = $('#endDateEdit').val();
                            var remarks = $('#remarksEdit').val();
                            var taskID = selectedEvent.taskID;
                            var reviewer = "";
                            if (taskID === "NA") {
                                reviewer = selectedEvent.projectReviewer;
                            } else {
                                reviewer = selectedEvent.reviewer;
                            }
                            $.ajax({
                                type: 'POST',
                                data: 'uniqueTaskID=' + selectedEvent.uniqueTaskID + '&' + 'title=' + title + '&' + 'start=' + start + '&' + 'end=' + end + '&' + 'assignEmployee=' + selectedEvent.assignedEmployee1 + '&' + 'assignEmployee1=' + selectedEvent.assignedEmployee2 + '&' + 'reviewer=' + reviewer + '&' + 'remarks=' + remarks + '&' + 'projectID=' + selectedEvent.projectID +
                                        '&' + 'taskID=' + taskID + '&' + 'taskStatus=' + selectedEvent.taskStatus + '&' + 'reviewStatus=' + selectedEvent.reviewStatus + '&' + 'companyName=' + companyName,
                                url: 'UpdateAdHocAdmin',
                                success: function () {
                                    $('#calendar').fullCalendar('refetchEvents');
                                    alert('Info Updated');
                                    $('#myModal').modal('hide');
                                    $('#myModalSave').modal('hide');
                                },
                                error: function () {
                                    alert('Fail to Update Task');
                                }
                            })
                        }
                    });
                    $('#btnDelete').click(function () {
                        //Open modal dialog to delete project
                        if (selectedEvent !== null && confirm('Are you sure?')) {
                            $.ajax({
                                type: 'POST',
                                data: 'projectID=' + selectedEvent.projectID + '&' + 'taskID=' + selectedEvent.taskID,
                                url: 'DeleteAdHocAdmin',
                                success: function () {
                                    //Refresh Calendar
                                    //console.log("IT's a SUCCESS");
                                    $('#calendar').fullCalendar('refetchEvents');
                                    alert('Task Deleted');
                                    $('#myModal').modal('hide');
                                },
                                error: function () {
                                    alert('Fail to Delete Task');
                                }
                            })
                        }
                    });
                    $('#btnComplete').click(function () {
                        if (selectedEvent !== null) {
                            var taskID = selectedEvent.taskID;
                            var taskStatus = selectedEvent.taskStatus;
                            var projectStatus = selectedEvent.projectStatus;
                            var taskReviewStatus = selectedEvent.reviewStatus;
                            var projectReviewStatus = selectedEvent.projectReviewStatus;
                            if (taskID !== "NA") {
                                if (taskStatus === 'complete' && taskReviewStatus === 'complete') {
                                    alert('No action required.');
                                    $('#myModal').modal('hide');
                                } else if (taskStatus === 'complete') {
                                    alert('Selected task has already been completed. Waiting for review.');
                                    $('#myModal').modal('hide');
                                } else {
                                    $.ajax({
                                        type: 'POST',
                                        data: 'projectID=' + selectedEvent.projectID + '&' + 'taskID=' + taskID + '&' + 'taskStatus=' + status,
                                        url: 'UpdateAdHocCompletionStatus',
                                        success: function () {
                                            $('#calendar').fullCalendar('refetchEvents');
                                            alert('Task completion status updated');
                                            $('#myModal').modal('hide');
                                        },
                                        error: function () {
                                            alert('Fail to update task completion status');
                                        }
                                    })
                                }
                            } else {
                                if (projectStatus === 'complete' && projectReviewStatus === 'complete') {
                                    alert('No action required.');
                                    $('#myModal').modal('hide');
                                } else if (projectStatus === 'complete') {
                                    alert('Selected project has already been completed. Waiting for review.');
                                    $('#myModal').modal('hide');
                                } else {
                                    $.ajax({
                                        type: 'POST',
                                        data: 'projectID=' + selectedEvent.projectID + '&' + 'taskID=' + taskID + '&' + 'projectStatus=' + status,
                                        url: 'UpdateAdHocCompletionStatus',
                                        success: function () {
                                            $('#calendar').fullCalendar('refetchEvents');
                                            alert('Project completion status updated');
                                            $('#myModal').modal('hide');
                                        },
                                        error: function () {
                                            alert('Fail to update project completion status');
                                        }
                                    })
                                }
                            }
                        }
                    }
                    );
                    $('#btnReview').click(function () {
                        if (selectedEvent !== null) {
                            var taskID = selectedEvent.taskID;
                            var taskStatus = selectedEvent.taskStatus;
                            var projectStatus = selectedEvent.projectStatus;
                            var taskReviewStatus = selectedEvent.reviewStatus;
                            var projectReviewStatus = selectedEvent.projectReviewStatus;
                            if (taskID !== "NA") {
                                if (taskStatus !== 'complete') {
                                    alert('Complete task first.');
                                    $('#myModal').modal('hide');
                                } else if (taskStatus === 'complete' && taskReviewStatus === 'complete') {
                                    alert('No action required.');
                                    $('#myModal').modal('hide');
                                } else {
                                    $.ajax({
                                        type: 'POST',
                                        data: 'projectID=' + selectedEvent.projectID + '&' + 'taskID=' + taskID,
                                        url: 'UpdateAdHocReviewStatus',
                                        success: function () {
                                            $('#calendar').fullCalendar('refetchEvents');
                                            alert('Task review status updated');
                                            $('#myModal').modal('hide');
                                        },
                                        error: function () {
                                            alert('Fail to update task review status');
                                        }
                                    })
                                }
                            } else {
                                if (projectStatus !== 'complete') {
                                    alert('Complete project first.');
                                    $('#myModal').modal('hide');
                                } else if (projectStatus === 'complete' && projectReviewStatus === 'complete') {
                                    alert('No action required.');
                                    $('#myModal').modal('hide');
                                } else {
                                    $.ajax({
                                        type: 'POST',
                                        data: 'projectID=' + selectedEvent.projectID + '&' + 'taskID=' + taskID,
                                        url: 'UpdateAdHocReviewStatus',
                                        success: function () {
                                            $('#calendar').fullCalendar('refetchEvents');
                                            alert('Project review status updated');
                                            $('#myModal').modal('hide');
                                        },
                                        error: function () {
                                            alert('Fail to update project review status');
                                        }
                                    })
                                }
                            }
                        }
                    }
                    );
                    $(document).scroll(function (e) {

                        if ($(".ui-widget-overlay")) //the dialog has popped up in modal view
                        {
                            //fix the overlay so it scrolls down with the page
                            $(".ui-widget-overlay").css({
                                position: 'fixed',
                                top: '0'
                            });
                            //get the current popup position of the dialog box
                            pos = $(".ui-dialog").position();
                            //adjust the dialog box so that it scrolls as you scroll the page
                            $(".ui-dialog").css({
                                position: 'fixed',
                                top: pos
                            });
                        }
                    });
                }
                //Task Modal
                $("#create-task").button().on("click", function () {
                    $('#myModalTask').modal();
                });
                $('#btnSaveTask').click(function () {
                    var companyName = document.getElementById("companyNameCreate").value;
                    var project = $("#projectCreate option:selected").html();
                    var taskTitle = document.getElementById("titleCreate").value;
                    var start = document.getElementById("startDateCreate").value;
                    var end = document.getElementById("endDateCreate").value;
                    var taskReviewer = document.getElementById("reviewerCreate").value;
                    var taskRemarks = document.getElementById("remarkCreate").value;

                    if (project == "") {
                        alert("Project Field Required");
                        return;
                    }
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
                            data: 'companyName=' + companyName + '&' + 'project=' + project + '&' + 'title=' + taskTitle + '&' + 'start=' + start + '&' + 'end=' + end + '&' + 'remarks=' + taskRemarks + '&' + 'reviewer=' + taskReviewer,
                            type: 'POST',
                            success: function () {
                                $('#calendar').fullCalendar('refetchEvents');
                                alert('Task Added');
                                $('#myModalTask').modal('hide');

                            }
                        });
                    }
                }
                );
                //Task Modal

                //Project Modal
                $("#create-adhoc").button().on("click", function () {
                    $('#myModalProject').modal();
                });
                $('#btnSaveAdhoc').click(function () {
                    var companyName = document.getElementById("companyProjectCreate").value;
                    var projectTitle = document.getElementById("titleProjectCreate").value;
                    var start = document.getElementById("startDateProjectCreate").value;
                    var end = document.getElementById("endDateProjectCreate").value;
                    var assignEmployee = document.getElementById("assignEmployeeProjectCreate").value;
                    var assignEmployee1 = document.getElementById("assignEmployee1ProjectCreate").value;
                    var projectReviewer = document.getElementById("reviewerProjectCreate").value;
                    var projectRemarks = document.getElementById("remarkProjectCreate").value;
                    if (companyName == "") {
                        alert("Company Name Field Required");
                        return;
                    }
                    if (projectTitle == "") {
                        alert("Project Field Required");
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
                    if (assignEmployee == "") {
                        alert("Assigned Employee Required");
                        return;
                    }
                    if (assignEmployee1 == "") {
                        alert("Second Employee Required");
                        return;
                    }
                    if (assignEmployee == assignEmployee1) {
                        alert("Same Employees Assigned. Choose Another Employee");
                        return;
                    }
                    if (projectReviewer == "") {
                        alert("Reviewer Required");
                        return;
                    }
                    if (projectReviewer == assignEmployee || projectReviewer == assignEmployee1) {
                        alert("Duplicate Entry for Reviewer and Employee Assigned");
                        return;
                    }
                    if (projectRemarks == "") {
                        alert("Remarks Required (NA if not applicable)");
                        return;
                    } else {
                        $.ajax({
                            url: 'CreateAdHocProjectAdmin',
                            data: 'companyName=' + companyName + '&' + 'title=' + projectTitle + '&' + 'start=' + start + '&' + 'end=' + end + '&' + 'emp=' + assignEmployee + '&' + 'emp1=' + assignEmployee1 + '&' + 'remarks=' + projectRemarks + '&' + 'reviewer=' + projectReviewer,
                            type: 'POST',
                            success: function () {
                                alert('Ad Hoc Project Added');
                                $('#myModalProject').modal('hide');
                            }
                        });
                    }

                })
                //Project Modal

                var modal = document.getElementById('myModal');
                // Get the <span> element that closes the modal
                var span = document.getElementsByClassName("close")[0];
                // When the user clicks on <span> (x), close the modal
                span.onclick = function () {
                    modal.style.display = "none";
                }
                // When the user clicks anywhere outside of the modal, close it
                window.onclick = function (event) {
                    if (event.target == modal) {
                        modal.style.display = "none";
                    }
                }
                var options = $("#projectCreate").html();
                $("#companyNameCreate").change(function (e) {
                    var text = $("#companyNameCreate :selected").text();
                    $("#projectCreate").html(options);
                    $('#projectCreate :not([value^="' + text.substr(0, 3) + '"])').remove();
                })
            });
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>