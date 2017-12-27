<%-- 
    Document   : UploadExpense
    Created on : Dec 24, 2017, 5:01:52 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.Collections"%>
<%@page import="Entity.Project"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp" %>

<html>
    <head>
        <title>Upload Expense | Abundant Accounting Management System</title>
    </head>
    <%        
        ArrayList<String> idList = new ArrayList();
        ArrayList<String> nameList = new ArrayList();
        ClientDAO clientDAO = new ClientDAO();
        ProjectDAO projectDAO = new ProjectDAO();
        ArrayList<Project> projectList = projectDAO.getAllIncompleteProjects();
        ArrayList<Client> clientList = clientDAO.getAllClient();
        if (clientList != null) {
            for (int i = 0; i < clientList.size(); i++) {
                Client c = clientList.get(i);
                String id = Integer.toString(c.getClientID());
                String name = c.getCompanyName();
                idList.add(id);
                nameList.add(name);
            }
        }
        //Collections.sort(nameList, String.CASE_INSENSITIVE_ORDER);
    %>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" width="100%" height='100%' style="margin-top: <%=session.getAttribute("margin")%>" align="center">
                    <h1>Upload expenses onto Quickbook</h1>
                    <div class="container-fluid" align="center" style='width: 40%; display: inline-block'>
                        <form action = "ProcessExcelServlet" method = "post" enctype = "multipart/form-data">
                            <table align="center" width="100%" style="align: center">
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <Strong>Upload a new expense file</Strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <input id="file-upload" type = "file" name = "file" value="Choose Files to Upload" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" required/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <Strong>Select Client</Strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <select name="clientSelected" id="clientSelected" required>
                                            <option disabled selected value> -- select an option -- </option>
                                            <%
                                                if (idList.size() == nameList.size()) {
                                                    for (int i = 0; i < idList.size(); i++) {
                                            %>
                                            <option class="optionFont" value=<%=idList.get(i)%>><%=nameList.get(i)%></option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <Strong>Select Project</Strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <select name="projectSelected" id="projectSelected" required>
                                            <option disabled selected value> -- select an option -- </option>
                                            <%
                                                for (int i = 0; i < projectList.size(); i++) {
                                                    Project p = projectList.get(i);
                                                    String projectTitle = p.getProjectTitle();
                                                    int projectId = p.getProjectID();
                                            %>
                                            <option class="optionFont" value='<%=projectId%>'><%=projectTitle%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <% if (request.getAttribute("UploadExcelSuccess") != null || request.getAttribute("UploadExcelResponse") != null) {%>
                                        <p><font color="green"><%=(request.getAttribute("UploadExcelSuccess") != null) ? request.getAttribute("UploadExcelSuccess") : ""%></font></p>
                                        <p><font color="red"><%=(request.getAttribute("UploadExcelResponse") != null) ? request.getAttribute("UploadExcelResponse") : ""%></font></p>
                                            <%}%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 66.666%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block" type="reset">Cancel</button>
                                    </td>
                                    </form>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <input class="btn btn-lg btn-primary btn-block btn-success" id="file-validate" type = "submit" value = "Validate Expense"/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>