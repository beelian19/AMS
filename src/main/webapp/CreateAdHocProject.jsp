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
<html>
    <head>
        <title>Create AdHoc Project | Abundant Accounting Management System</title>
        <%
            EmployeeDAO empDAO = new EmployeeDAO();
            Client client = (Client) request.getAttribute("client");
            ArrayList<Client> clientList = ClientDAO.getAllClient();
            ArrayList<String> supList = empDAO.getAllSupervisor();
        %>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>Create Ad Hoc Project</h1>
                    <br/>
                    <div class="container-fluid" align="center" style='width: 100%; display: inline-block'>
                        <form action="CreateAdHocProjectAdmin" method="post">
                            <table width="100%" height="100%" style="text-align: left">
                                <tr bgcolor="#034C75" rowspan="8">
                                    <td colspan="7">
                                        <h4><font color="white">&emsp; Basic Information</font></h4>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label for="titleProject">Project Title&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="titleProjectCreate" id="titleProjectCreate" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="companyNameProject">Company Name&nbsp<font color="red">*</font></label>
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
                                    <td width="1%">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr bgcolor="#034C75" rowspan="8">
                                    <td colspan="7">
                                        <h4><font color="white">&emsp; Project Information</font></h4>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label for="startDateProject">Start Date&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="date" name="startDateProjectCreate" id="startDateProjectCreate" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="endDateProject">End Date&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="date" name="endDateProjectCreate" id="endDateProjectCreate" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                    <td width="1%">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label for="remarksProject">Project Remarks</label>
                                    </td>
                                    <td>
                                        <textarea name="remarkProjectCreate" id="remarkProjectCreate" class="text ui-widget-content ui-corner-all" cols="40" rows="5"></textarea>
                                    </td>
                                    <td colspan='4'>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr bgcolor="#034C75" rowspan="8">
                                    <td colspan="7">
                                        <h4><font color="white">&emsp; Assigned Employee Information</font></h4>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <%
                                            if (supList != null && supList.size() != 0) {
                                        %>
                                        <label for="assignEmployeeProject">Assign First Employee&nbsp<font color="red">*</font></label>
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
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="assignEmployee1Project">Assign Second Employee&nbsp<font color="red">*</font></label>
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
                                    <td width="1%">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label for="reviewerProject">Project Reviewer&nbsp<font color="red">*</font></label>
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
                                    <td colspan='4'>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                            </table>
                            <table style="width: 100%">
                                <tr>
                                    <td style="width: 61%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block" type="reset">Reset</button>
                                    </td>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">Create</button>
                                    </td>
                                    <td style="width: 5.666%">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                        <br/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
            <br/>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
