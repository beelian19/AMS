<%-- 
    Document   : ClientProfile
    Created on : Dec 24, 2017, 4:47:54 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="Entity.Project"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <%            
            if (request.getParameter("profileId") != null && request.getAttribute("client") == null) {
                request.setAttribute("clientID", request.getParameter("profileId"));
                RequestDispatcher rd = request.getRequestDispatcher("ViewClientServlet");
                rd.forward(request, response);
                return;
            } else if (request.getAttribute("client") == null) {
                session.setAttribute("status", "Error: No client parsed at client profile page");
                response.sendRedirect("EmployeeProfile.jsp");
                return;
            } else if (request.getAttribute("incompletedProject") == null || request.getAttribute("completedProject") == null) {
                session.setAttribute("status", "Error: No projects parsed at client profile page");
                response.sendRedirect("EmployeeProfile.jsp");
                return;
            }
            ArrayList<Project> incompletedProjectList = (ArrayList<Project>) request.getAttribute("incompletedProject");
            ArrayList<Project> completedProjectList = (ArrayList<Project>) request.getAttribute("completedProject");
            String sessionID = (String) session.getAttribute("userId");
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee emp = empDAO.getEmployeeByID(sessionID);

            Client client = (Client) request.getAttribute("client");
            String clientName = "";
            if (client == null) {
                clientName = "Client not found";
            } else {
                clientName = client.getCompanyName();
            }

            String businessType = "";
            String companyName = "";
            String incorporation = "";
            String UenNumber = "";
            String officeContact = "";
            String emailAddress = "";
            String officeAddress = "";
            String financialYearEnd = "";
            String gst = "";
            String director = "";
            String shareholder = "";
            String secretary = "";
            String realmid = "";
            String mgmtAcc = "";

            if (client != null) {
                businessType = client.getBusinessType();
                companyName = clientName;
                incorporation = client.getIncorporation();
                UenNumber = client.getUENNumber();
                officeContact = client.getOfficeContact();
                emailAddress = client.getContactEmailAddress();
                officeAddress = client.getOfficeAddress();
                financialYearEnd = client.getFinancialYearEnd();
                gst = client.getGstSubmission();
                director = client.getDirector();
                shareholder = client.getAccountant();
                secretary = client.getSecretary();
                realmid = client.getRealmid();
                mgmtAcc = client.getMgmtAcc();
            }
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";
            String assignedEmployeeURL = "EmployeeProfile.jsp?profileName=";;
            String assignedEmployeeURL2 = "";
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=clientName%>&nbsp;Profile | Abundant Accounting Management System</title>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
                $('#datatable2').DataTable();
            })
        </script>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <!-- ########################################################## header ########################################################## -->        
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="margin-top: <%=session.getAttribute("margin")%>; overflow: auto">
                    <div class="container-fluid" style="text-align: center">
                        <div class="container-fluid" style="text-align: center">
                            <br/><br/>
                            <!-- Staff image -->
                            <img id="profile-img" class="profile-img-card" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png"/>
                            <!-- staff name -->
                            <h2>
                                <%=companyName%>&nbsp;
                                <i id="edit" class="material-icons">mode_edit</i>

                            </h2>
                            <h5>
                                <%=businessType%>
                            </h5>
                            <h5>
                                <%=incorporation%>
                            </h5>
                            <h5>
                                <%=UenNumber%>
                            </h5>
                        </div>

                        <div style="text-align: center; padding-bottom: 1%">
                            <form action='GetClientObject' method='post'>
                                <input type='hidden' id='companyName' value='<%=companyName%>' name='companyName'/>
                                <button style="font-size: 10.5px;">Create Project</button>
                            </form>
                        </div>

                    </div>
                </nav>
            </div>
        </nav>
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow: auto">
            <div class="container-fluid" style="text-align: left">
                <div class="container-fluid">
                    <table width="100%">
                        <tr>
                            <td align="left">
                                <h3>Description</h3>
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
                                                <strong> Email: </strong>
                                            </td>
                                            <td>
                                                <%=emailAddress%>
                                            </td>
                                            <td>
                                                <strong> Contact Number: </strong>
                                            </td>
                                            <td>
                                                <%=officeContact%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong> Address: </strong>
                                            </td>
                                            <td>
                                                <%=officeAddress%>
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong> Financial Year End: </strong>
                                            </td>
                                            <td>
                                                <%=financialYearEnd%>
                                            </td>
                                            <td>
                                                <strong> GST: </strong>
                                            </td>
                                            <td>
                                                <%=gst%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong> Director: </strong>
                                            </td>
                                            <td>
                                                <%=director%>
                                            </td>
                                            <td>
                                                <strong> Accountant: </strong>
                                            </td>
                                            <td>
                                                <%=shareholder%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <strong> Secretary: </strong>
                                            </td>
                                            <td>
                                                <%=secretary%>
                                            </td>
                                            <td colspan="2">
                                                &nbsp;
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
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow:auto">
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
                                                <th width="25%">Project Title</th>
                                                <th width="25%">Due Date</th>
                                                <th width="25%">Status</th>
                                                <th width="25%">Review Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (incompletedProjectList != null && !incompletedProjectList.isEmpty()) {
                                                    for (Project p : incompletedProjectList) {
                                            %>
                                            <tr>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href='<%=profileUrl2%>'>
                                                        <%=p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <%=p.getEnd()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectStatus()%>
                                                </td>
                                                <td>
                                                    <%=p.getProjectReviewStatus()%>
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
        <nav class="navbar navbar-default navbar-center container-fluid navbar-profile-page container-fluid" style="overflow:auto">
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
                                                <th width="25%">Project Title</th>
                                                <th width="25%">End Date</th>
                                                <th width="25%">Assigned Employee</th>
                                                <th width="25%">Hours</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (incompletedProjectList != null && !incompletedProjectList.isEmpty()) {
                                                    for (Project p : completedProjectList) {
                                            %>
                                            <tr>
                                                <td>
                                                    <% profileUrl2 = profileUrl + p.getProjectID();%>
                                                    <a href='<%=profileUrl2%>'>
                                                        <%=p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <%=p.getEnd()%>
                                                </td>
                                                <td>
                                                    <%

                                                        if (!p.getEmployee1().equals("NA")) {
                                                            assignedEmployeeURL2 = assignedEmployeeURL +EmployeeDAO.getEmployee(p.getEmployee1()).getEmployeeID();
                                                            
                                                    %>

                                                    <a href='<%=assignedEmployeeURL2%>'>
                                                        <%=p.getEmployee1()%>
                                                    </a>
                                                    <%
                                                    } else {
                                                    %>

                                                    <label><%=p.getEmployee1()%></label>

                                                    <%
                                                        }
                                                    %>





                                                </td>
                                                <td>
                                                    <%=p.getEmployee2Hours() + p.getEmployee1Hours()%>
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
                                        <input type="hidden" name="uen" id="uen" value="<%=UenNumber%>" class="text ui-widget-content ui-corner-all" required>
                                        <label>Office Contact&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="officeContactEdit" id="officeContactEdit" value="<%=client.getOfficeContact()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Email&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="emailEdit" id="emailEdit" value="<%=client.getContactEmailAddress()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Director&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="directorEdit" id="directorEdit" value="<%=client.getDirector()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Secretary&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="secretaryEdit" id="secretaryEdit" value="<%=client.getSecretary()%>" class="text ui-widget-content ui-corner-all" required>
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
                                        <label for="reviewer">Accountant&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="accountantEdit" id="accountantEdit" value="<%=client.getAccountant()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>  
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Real MID&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="realmidEdit" id="realmidEdit" value="<%=client.getRealmid()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td> 
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Address&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="addressEdit" id="addressEdit" value="<%=client.getOfficeAddress()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">GST&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="gstSubmissionEdit" id="gstSubmissionEdit" value="<%=client.getGstSubmission()%>" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">MGMT ACC&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input type="text" name="mgmtAccEdit" id="mgmtAccEdit" value="<%=client.getMgmtAcc()%>" class="text ui-widget-content ui-corner-all" required>
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
    <!-- End of Modal-->
    <script>
        $('#btnSave').click(function () {
            if ($('#officeContactEdit').val().trim() == "") {
                alert("Office Contact Number Required");
                return;
            }
            if ($('#emailEdit').val().trim() == "") {
                alert("Email Required");
                return;
            }
            if ($('#directorEdit').val().trim() == "") {
                alert("Director Information Required");
                return;
            }
            if ($('#secretaryEdit').val().trim() == "") {
                alert("Secretary Information Required");
                return;
            }
            if ($('#accountantEdit').val().trim() == "") {
                alert("Accountant Information Required");
                return;
            }
            if ($('#realmidEdit').val().trim() == "") {
                alert("Real MID Required");
                return;
            }
            if ($('#addressEdit').val().trim() == "") {
                alert("Address Required");
                return;
            }
            if ($('#gstSubmissionEdit').val().trim() == "") {
                alert("GST Submission Required");
                return;
            }
            if ($('#mgmtAccEdit').val().trim() == "") {
                alert("Management Acct Required");
                return;
            } else {
                var number = $('#officeContactEdit').val();
                var email = $('#emailEdit').val();
                var director = $('#directorEdit').val();
                var secretary = $('#secretaryEdit').val();
                var accountant = $('#accountantEdit').val();
                var uen = $('#uen').val();
                var realmid = $('#realmidEdit').val();

                var officeAddress = $('#addressEdit').val();
                var gstSubmission = $('#gstSubmissionEdit').val();
                var mgmtAcc = $('#mgmtAccEdit').val();


                $.ajax({
                    type: 'POST',
                    data: 'officeContact=' + number + '&' + 'contactEmailAddress=' + email + '&' + 'director=' + director + '&' + 'secretary=' + secretary + '&' + 'accountant=' + accountant + '&' + 'uen=' + uen + '&' + 'realmid=' + realmid + '&' + 'officeAddress=' + officeAddress + '&' + 'gstSubmission=' + gstSubmission + '&' + 'mgmtAcc=' + mgmtAcc,
                    url: 'UpdateClientServlet',
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
<jsp:include page="Footer.html"/>
</html>