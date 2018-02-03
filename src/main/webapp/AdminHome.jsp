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
                        </div>
                    </nav>
                </div>
            </div>
        </nav>
        <div id="myModalCompanyProject" class="modal fade" role="dialog">
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
        <div id="myModalAdHoc" class="modal fade" role="dialog">
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
        <div id="myModalSave" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                            <span id="eventTitle"></span>
                        </h4>
                    </div>
                    <div class="modal-body" align="left">
                        <form>
                            <fieldset>
                                <label>Title&nbsp<font color="red">*</font></label>
                                <input type="text" name="titleEdit" id="titleEdit" class="text ui-widget-content ui-corner-all" required>

                                <label>Company Name&nbsp</label>
                                <input type="text" name="companyNameEdit" id="companyNameEdit" class="text ui-widget-content ui-corner-all" required readonly>

                                <label for="startDate">Start Date&nbsp<font color="red">*</font></label>
                                <input type="text" name="startDateEdit" id="startDateEdit" placeholder="dd/MM/yyyy" class="text ui-widget-content ui-corner-all" required>

                                <label for="endDate">End Date&nbsp<font color="red">*</font></label>
                                <input type="text" name="endDateEdit" id="endDateEdit" placeholder="dd/MM/yyyy" class="text ui-widget-content ui-corner-all" required>

                                <label>Remarks&nbsp<font color="red">*</font></label><br>
                                <textarea name="remarksEdit" id="remarksEdit" class="text ui-widget-content ui-corner-all" cols="56" rows="5"></textarea>
                            </fieldset>
                            <button type="button" id="btnSave" class="btn btn-success">Save</button>
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
                        eventRender: function (event, element, view) {
                            //when project first created yellow color
                            var taskStatus = event.taskStatus;
                            var taskReviewStatus = event.reviewStatus;
                            var projectStatus = event.projectStatus;
                            var projectReviewStatus = event.projectReviewStatus;
                            if (taskStatus !== "NA" || taskReviewStatus !== "NA") {
                                if (taskStatus === "incomplete" && taskReviewStatus === "incomplete") {
                                    element.css('background-color', '#FFD700');
                                    element.css('color', '#000000');
                                } else if (taskStatus === "complete" && taskReviewStatus === "incomplete") {
                                    //when project completed by employee but havent review blue
                                    element.css('background-color', '#6495ED');
                                    element.css('color', '#000000');
                                } else if (taskStatus === "complete" && taskReviewStatus === "complete") {
                                    //when both status is complete green color
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
                                $description.append($('<p/>').html('<b>Assigned Employees: </b>' + calEvent.employee1 + ' & ' + calEvent.employee2));

                                $description.append($('<p/>').html('<b>Project Reviewer: </b>' + calEvent.projectReviewer));
                                $description.append($('<p/>').html('<b>Task Reviewer: </b>' + calEvent.reviewer));
                                $description.append($('<p/>').html('<u>Project Remarks</u></br>' + calEvent.projectRemarks));
                                $description.append($('<p/>').html('<u>Task Remarks:</u></br>' + calEvent.taskRemarks));

                                $('#myModalAdHoc #pDetails').empty().html($description);
                                $('#myModalAdHoc').modal();
                            } else {
                                $('#myModalCompanyProject #eventTitle').text("Project Overview");
                                var $description = $('<div/>');
                                $description.append($('<p/>').html('<b>Title: </b><a href=ProjectProfile.jsp?projectID=' + calEvent.projectID + '>' + calEvent.title + '</a>'));
                                $description.append($('<p/>').html('<b>Company Name: </b>' + calEvent.companyName));
                                $description.append($('<p/>').html('<b>Assigned Employees: </b>' + calEvent.employee1 + ' & ' + calEvent.employee2));
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
                                $description.append($('<p/>').html('<u>Project Remarks</u></br>' + calEvent.projectRemarks));
                                $('#myModalCompanyProject #pDetails').empty().html($description);
                                $('#myModalCompanyProject').modal();
                            }

                        },
                        eventMouseover: function (calEvent, jsEvent) {
                            var tooltip;
                            var taskStatus = calEvent.taskStatus;
                            if (taskStatus === 'NA') {
                                tooltip = '<div class="tooltipevent" style="width:400px;height:50px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                        "The external deadline for this project is <b>" + calEvent.actualDeadline + "</b>." + "</br><b>Click</b> on it for more information." +
                                        '</div>';
                            } else {
                                tooltip = '<div class="tooltipevent" style="width:400px;height:50px;background:#FFEFD5;position:absolute;z-index:10001;">' +
                                        "There are <b>no</b> external deadline for this." + "</br><b>Click</b> on it for more information." +
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