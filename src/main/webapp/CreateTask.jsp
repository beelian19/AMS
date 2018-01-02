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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <%
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<String> supList = empDAO.getAllSupervisor();
            ProjectDAO projectDAO = new ProjectDAO();
            ArrayList<Project> projectList = projectDAO.getAllIncompleteAdhocProjects();
        %>
    </head>
    <body>
        <div id="myModalTask" class="modal fade" role="dialog">
            <!-- Modal content -->
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
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
    </body>
</html>
