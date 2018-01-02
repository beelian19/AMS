<%-- 
    Document   : CreateAdHocProject
    Created on : Jan 2, 2018, 3:16:42 PM
    Author     : yemin
--%>

<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Create Ad Hoc Project | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <%
            EmployeeDAO empDAO = new EmployeeDAO();
            Client client = (Client) request.getAttribute("client");
            ArrayList<Client> clientList = ClientDAO.getAllClient();
            ArrayList<String> supList = empDAO.getAllSupervisor();
        %>
    </head>
    <body>
        <!--Project Modal-->
        <div id="myModalProject" class="modal fade" role="dialog">
            <!-- Modal content -->
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
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
    </body>
</html>
