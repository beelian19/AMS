<%-- 
    Document   : CreateTask
    Created on : Jan 2, 2018, 3:43:57 PM
    Author     : yemin
--%>

<%@page import="DAO.EmployeeDAO"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Create Task | Abundant Accounting Management System</title>
        <%
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<String> supList = empDAO.getAllSupervisor();
            ProjectDAO projectDAO = new ProjectDAO();
            ArrayList<Project> projectList = projectDAO.getAllIncompleteAdhocProjects();
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
                    <h1>Create Task</h1>
                    <br/>
                    <div class="container-fluid" align="center" style='width: 100%; display: inline-block'>
                        <form action="CreateTaskAdmin" method="post">
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
                                        <label for="companyNameProject">Company Name&nbsp<font color="red">*</font></label>
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
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="projects">Projects&nbsp<font color="red">*</font></label>
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
                                        <h4><font color="white">&emsp; Task Information</font></h4>
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
                                        <label for="title">Task Title&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="titleCreate" id="titleCreate" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="startDate">Start Date&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="date" name="startDateCreate" id="startDateCreate" class="text ui-widget-content ui-corner-all" required>
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
                                        <label for="endDate">End Date&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="date" name="endDateCreate" id="endDateCreate" class="text ui-widget-content ui-corner-all" required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="remarks">Task Remarks</label>
                                    </td>
                                    <td>
                                        <textarea name="remarkCreate" id="remarkCreate" class="text ui-widget-content ui-corner-all" cols="40" rows="5"></textarea>
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
                                        <h4><font color="white">&emsp; Task Information</font></h4>
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
                                        <label for="reviewer">Task Reviewer&nbsp<font color="red">*</font></label>
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
