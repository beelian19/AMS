<%-- 
    Document   : EmployeeProfile
    Created on : Dec 24, 2017, 5:07:40 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entity.Project"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page autoFlush="true" buffer="1094kb"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <%            if (request.getParameter("profileName") != null && request.getAttribute("name") == null) {
                request.setAttribute("id", request.getParameter("profileName"));
                RequestDispatcher rd = request.getRequestDispatcher("StaffProfileServlet");
                rd.forward(request, response);
            } else if (request.getAttribute("name") == null) {
                //System.out.println("TEST==============Success");
                // if anything null, it will force it to profile servlet to retrieve the details

                String employeeID = (String) session.getAttribute("userId");
                request.setAttribute("id", employeeID);
                RequestDispatcher rd = request.getRequestDispatcher("StaffProfileServlet");
                rd.forward(request, response);
            }
            String viewAllID = (String) request.getAttribute("id");

            ArrayList<String> nationalities = new ArrayList();
            nationalities.add("singaporean");
            nationalities.add("PR");
            nationalities.add("foreigner");

            ArrayList<String> access = new ArrayList();
            access.add("yes");
            access.add("no");

            ArrayList<String> positions = new ArrayList();
            positions.add("Full-time Employee");
            positions.add("Part-time Employee");
            positions.add("Intern");
            positions.add("Contract Employee");
            positions.add("Ex-Employee");
            positions.add("Accountant");
            positions.add("IT Executive");
            ArrayList<Project> incompletedProjectList = (ArrayList<Project>) request.getAttribute("incompletedProject");
            //System.out.println("SIZE--------------"+incompletedProjectList.size());
            ArrayList<Project> completedProjectList = (ArrayList<Project>) request.getAttribute("completedProject");
            ArrayList<Project> overdueProjectList = (ArrayList<Project>) request.getAttribute("overdueProject");
            String sessionID = (String) session.getAttribute("userId");
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee employee = empDAO.getEmployeeByID(viewAllID);
            Employee emp = empDAO.getEmployeeByID(sessionID);
            String employeeName = "";

            if (employee == null) {
                employeeName = "No User";
            } else {
                employeeName = employee.getName();
            }
            String profileUrl = "ProjectProfile.jsp?projectID=";
            String profileUrl2 = "";

            String clientProfileUrl = "ClientProfile.jsp?profileId=";
            String clientProfileUrl2 = "";
            DecimalFormat df = new DecimalFormat("#.00");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=employeeName%>&nbsp;Profile | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
                $('#datatable2').DataTable();
                $('#datatable3').DataTable();
            })
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
                                <br/><br/>
                                <!-- Staff image -->
                                <img id="profile-img" class="profile-img-card" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png"/>
                                <!-- staff name -->
                                <h2>
                                    <%=employeeName%>
                                    <%
                                        if (emp.getIsAdmin().equals("yes")) {
                                    %>
                                    <i id="edit" class="material-icons">mode_edit</i>
                                    <%
                                    } else if (viewAllID.equals(sessionID)) {
                                    %>
                                    <i id="employeeEdit" class="material-icons">mode_edit</i>        
                                    <%
                                        }
                                    %>   
                            </div>

                            <h5><%=employee.getPosition()%></h5>
                            <!-- date joined -->
                            <h5>Joined on&nbsp;<%=employee.getDateJoined()%></h5>
                            <h5><%=employee.getNationality()%></h5>
                            <br/>
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
                                        <a href="mailto:"+<%=employee.getEmail()%>><%=employee.getEmail()%></a>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <strong> Number: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getNumber()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong> Monthly Overhead: </strong>
                                    </td>
                                    <td>
                                        <%
                                            if (viewAllID.equals(sessionID) || employee.getIsAdmin().equals("yes")) {
                                        %>
                                        <%=employee.getMonthlyOverhead()%>
                                        <%
                                        } else {
                                        %>
                                        Confidential Data
                                        <%
                                            }
                                        %>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <strong> DOB: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getDob()%>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong> Bank Account: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getBankAccount()%>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <strong> Admin Access: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getIsAdmin()%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong> NRIC: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getNric()%>
                                    </td>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <strong> Supervisor: </strong>
                                    </td>
                                    <td>
                                        <%=employee.getIsSupervisor()%>
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
                                        <th width="20.0%">Project Title</th>
                                        <th width="20.0%">Company Name</th>
                                        <th width="20.0%">Deadline</th>
                                        <th width="20.0">Hours Assigned</th>
                                        <th width="20.0%">Hours Spent</th>
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
                                            <%=p.getEnd()%>
                                        </td>   
                                        <td>
                                            <%
                                                double assignedHours = p.getPlannedHours();
                                                if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(df.format(assignedHours/2.0));
                                                }else{
                                                    out.println(df.format(assignedHours));
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <% ProjectDAO pDAO = new ProjectDAO();
                                                double hours = pDAO.getHoursPerEmployeeByProject(p.getProjectID(), employeeName);
                                            %>
                                            <%=hours%>
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
                                        <th width="20.0%">Project Title</th>
                                        <th width="20.0%">Company Name</th>
                                        <th width="20.0%">Deadline</th>
                                        <th width="20.0%">Hours Assigned</th>
                                        <th width="20.0%">Hours Spent</th>
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
                                            <%=p.getEnd()%>
                                        </td> 
                                        <td>
                                            <%
                                                double assignedHours = p.getPlannedHours();
                                                if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(df.format(assignedHours/2.0));
                                                }else{
                                                    out.println(df.format(assignedHours));
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <% ProjectDAO pDAO = new ProjectDAO();
                                                double hours = pDAO.getHoursPerEmployeeByProject(p.getProjectID(), employeeName);
                                            %>
                                            <%=hours%>
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
                                        <th width="20.0%">Project Title</th>
                                        <th width="20.0%">Company Name</th>
                                        <th width="20.0%">Deadline</th>
                                        <th width="20.0%">Hours Assigned</th>
                                        <th width="20.0%">Hours Spent</th>
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
                                            <%=p.getEnd()%>
                                        </td> 
                                        <td>
                                            <%
                                                double assignedHours = p.getPlannedHours();
                                                if(!p.getEmployee2().toLowerCase().equals("na")){
                                                    out.println(df.format(assignedHours/2.0));
                                                }else{
                                                    out.println(df.format(assignedHours));
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <% ProjectDAO pDAO = new ProjectDAO();
                                                double hours = pDAO.getHoursPerEmployeeByProject(p.getProjectID(), employeeName);
                                            %>
                                            <%=hours%>
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
<script>
    $('#employeeEdit').click(function () {
        $('#employeeEditProfileModal').modal();
    });
</script>
<!-- Employee Edit MODAL START -->
<div id="employeeEditProfileModal" class="modal fade" role="dialog">
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
                                    <label>Mobile Number&nbsp;<font color="red">*</font></label>
                                    <input type="hidden" name="employeeid" id="employeeid" value="<%=viewAllID%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="employeeMobileNumberEdit" id="employeeMobileNumberEdit" value="<%=employee.getNumber()%>" class="text ui-widget-content ui-corner-all" required>
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
                                    <input type="text" name="employeeEmailEdit" id="employeeEmailEdit" value="<%=employee.getEmail()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="reviewer">Bank Account&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="employeeBankAccountEdit" id="employeeBankAccountEdit" value="<%=employee.getBankAccount()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="reviewer">Password&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="passwordEdit" id="passwordEdit" value="<%=employee.getPassword()%>" class="text ui-widget-content ui-corner-all" required>
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
                                    <button type="button" id="employeeBtnSave" class="btn btn-success">Save</button>
                                </td>
                            </tr>
                        </fieldset>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
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
                                    <label>Mobile Number&nbsp;<font color="red">*</font></label>
                                    <input type="hidden" name="id" id="id" value="<%=viewAllID%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="mobileNumberEdit" id="mobileNumberEdit" value="<%=employee.getNumber()%>" class="text ui-widget-content ui-corner-all" required>
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
                                    <input type="text" name="emailEdit" id="emailEdit" value="<%=employee.getEmail()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="reviewer">Bank Account&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="bankAccountEdit" id="bankAccountEdit" value="<%=employee.getBankAccount()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="reviewer">Nationality&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='nationalityEdit' id="nationalityEdit" class="form-control" required autofocus>
                                        <option value="<%=employee.getNationality()%>"><%=employee.getNationality()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < nationalities.size(); i++) {
                                                if (!nationalities.get(i).equals(employee.getNationality())) {
                                                    out.println("<option value='" + nationalities.get(i) + "'>" + nationalities.get(i) + "</option>");
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
                                    <label for="reviewer">Monthly Overhead&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <input type="text" name="salaryEdit" id="salaryEdit" value="<%=employee.getMonthlyOverhead()%>" class="text ui-widget-content ui-corner-all" required>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="reviewer">Admin Access&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='isAdminEdit' id="isAdminEdit" class="form-control" required autofocus>
                                        <option value="<%=employee.getIsAdmin()%>"><%=employee.getIsAdmin()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < access.size(); i++) {
                                                if (!access.get(i).equals(employee.getIsAdmin())) {
                                                    out.println("<option value='" + access.get(i) + "'>" + access.get(i) + "</option>");
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
                                    <label for="reviewer">Position&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='positionEdit' id="positionEdit" class="form-control" required autofocus>
                                        <option value="<%=employee.getPosition()%>"><%=employee.getPosition()%></option>
                                        <%
                                            //System.out.println(nameList);
                                            for (int i = 0; i < positions.size(); i++) {
                                                if (!positions.get(i).equals(employee.getPosition())) {
                                                    out.println("<option value='" + positions.get(i) + "'>" + positions.get(i) + "</option>");
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
                                    <label for="reviewer">Supervisor&nbsp;<font color="red">*</font></label>
                                </td>
                                <td width="1%">
                                    &nbsp;
                                </td>
                                <td>
                                    <select name='supervisorEdit' id="supervisorEdit" class="form-control" required autofocus>
                                        <option value="<%=employee.getIsSupervisor()%>"><%=employee.getIsSupervisor()%></option>
                                        <%
                                            for (int i = 0; i < access.size(); i++) {
                                                if (!access.get(i).equals(employee.getIsSupervisor())) {
                                                    out.println("<option value='" + access.get(i) + "'>" + access.get(i) + "</option>");
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
<!-- End of Modal-->
<script>
    $('#btnSave').click(function () {
        if ($('#mobileNumberEdit').val() === "") {
            alert("Mobile Number Required");
            return;
        }
        if ($('#emailEdit').val() === "") {
            alert("Email Required");
            return;
        }
        if ($('#bankAccountEdit').val() === "") {
            alert("Bank Account Required");
            return;
        }
        if ($('#nationalityEdit').val() === "") {
            alert("Nationality Required");
            return;
        }
        if ($('#salaryEdit').val() === "") {
            alert("Monthly Overhead Required");
            return;
        }
        if ($('#isAdminEdit').val() === "") {
            alert("Admin Access Required");
            return;
        }
        if ($('#positionEdit').val() === "") {
            alert("position Required");
            return;
        }
        if ($('#supervisorEdit').val() === "") {
            alert("Supervisor Required");
            return;
        } else {
            var number = $('#mobileNumberEdit').val();
            var email = $('#emailEdit').val();
            var bankAccount = $('#bankAccountEdit').val();
            var nationality = $('#nationalityEdit').val();
            var salary = $('#salaryEdit').val();
            var id = $('#id').val();
            var isAdmin = $('#isAdminEdit').val();
            var position = $('#positionEdit').val(); 
            var supervisor = $('#supervisorEdit').val();
            
            console.log("Position: "+position);

            $.ajax({
                type: 'POST',
                data: 'mobileNumber=' + number + '&' + 'emailAddress=' + email + '&' + 'bankAccount=' + bankAccount + '&' + 'nationality=' + nationality + '&' + 'currentSalary=' + salary + '&' + 'id=' + id + '&' + 'isAdmin=' + isAdmin + '&' + 'position=' + position + '&' + 'supervisor=' + supervisor,
                url: 'EmployeeProfileUpdate',
                success: function () {
                    $('#editProfileModal').modal('hide');
                    alert('Details Updated');
                    location.reload();
                },
                error: function () {
                    alert('Fail to Edit Details');
                }
            })
        }
        $('#editProfileModal').modal('hide');
    });
</script>
<script>
    $('#employeeBtnSave').click(function () {
        if ($('#employeeMobileNumberEdit').val().trim() == "") {
            alert("Mobile Number Required");
            return;
        }
        if ($('#employeeEmailEdit').val().trim() == "") {
            alert("Email Required");
            return;
        }
        if ($('#employeeBankAccountEdit').val().trim() == "") {
            alert("Bank Account Required");
            return;
        }
        if ($('#passwordEdit').val().trim() == "") {
            alert("Password Required");
            return;

        } else {
            var number = $('#employeeMobileNumberEdit').val();
            var email = $('#employeeEmailEdit').val();
            var bankAccount = $('#employeeBankAccountEdit').val();
            var password = $('#passwordEdit').val();
            var id = $('#employeeid').val();


            $.ajax({
                type: 'POST',
                data: 'empMobileNumber=' + number + '&' + 'empEmailAddress=' + email + '&' + 'empBankAccount=' + bankAccount + '&' + 'password=' + password + '&' + 'empid=' + id,
                url: 'EmployeeOwnProfileUpdate',
                success: function () {
                    location.reload();
                    alert('Details Updated');
                    $('#employeeEditProfileModal').modal('hide');
                },
                error: function () {
                    alert('Fail to Edit Details');
                }
            })
        }
        $('#employeeEditProfileModal').modal('hide');
    });
</script>    
</body>
<jsp:include page="Footer.html"/>
</html>
