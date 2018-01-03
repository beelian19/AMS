<%-- 
    Document   : CreateProject
    Created on : Dec 24, 2017, 4:52:04 PM
    Author     : Bernitatowyg
--%>

<%@page import="DAO.EmployeeDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="Entity.Client"%>
<%@include file="Protect.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>Create Project | Abundant Accounting Management System</title>
        <%            Client client = (Client) session.getAttribute("client");
            HashMap<String, String> alltimeLines = (HashMap<String, String>) session.getAttribute("allTimeLines");
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<String> supList = empDAO.getAllSupervisor();
            String clientName = client.getCompanyName();
            int profileId = client.getClientID();
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
                    <h1>Create Project for <%=clientName%></h1>
                    <br/>
                    <div class="container-fluid" align="center" style='width: 100%; display: inline-block'>
                        <form>
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
                                        <label>Project Title&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="projectTitleCreate" id="projectTitleCreate" class="text ui-widget-content ui-corner-all" style='display: block; width:100%' required>
                                        <input type="hidden" name="profileId" id="profileId" value="<%=profileId%>"/>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Company Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="compName" value="<%=client.getCompanyName()%>" id="compName" class="text ui-widget-content ui-corner-all" readonly style='display: block; width:100%' required>  
                                        <input type='hidden' name='companyNameCreate' value='<%=client.getCompanyName()%>' id='companyNameCreate'>
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
                                        <label>Financial Year End&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="financialYearEndCreate" value="<%=client.getFinancialYearEnd()%>" id="financialYearEndCreate" class="text ui-widget-content ui-corner-all" readonly style='display: block; width:100%' required/>
                                    </td>
                                    <td colspan="4">
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
                                        <label style='display: block; width:100%'>Project Type&nbsp;<font color="red">*</font></label> 
                                    </td>
                                    <td>
                                        <select name='projectTypeCreate' id="projectTypeCreate" class="form-control" autofocus style='display: block; width:100%' required>
                                            <option disabled selected value> — select an option — </option>
                                            <option value="tax">Tax</option>
                                            <option value="eci">ECI</option>
                                            <option value="gst">GST</option>
                                            <option value="management">Management</option>
                                            <option value="final">Final Accounting</option>
                                            <option value="secretarial">Secretarial</option>
                                        </select> 
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Recommended Internal Deadline&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='recommendedInternalDeadline' id="recommendedInternalDeadline" class="form-control" autofocus style='display: block; width:100%' required>

                                            <%
                                                for (String key : alltimeLines.keySet()) {
                                                    if (key.equals("eciTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='ECI'>" + str + "</option>");
                                                    }
                                                    if (key.equals("taxTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Tax'>" + str + "</option>");
                                                    }
                                                    if (key.equals("gstTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='GST'>" + str + "</option>");
                                                    }
                                                    if (key.equals("mgtTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Management'>" + str + "</option>");
                                                    }
                                                    if (key.equals("finTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Final Accounting'>" + str + "</option>");
                                                    }
                                                    if (key.equals("secTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Secretarial'>" + str + "</option>");
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
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label>Internal Deadline&nbsp;</label>
                                    </td>
                                    <td>
                                        <input type="date" name="internalDeadlineCreate" id="internalDeadlineCreate" class="text ui-widget-content ui-corner-all" style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Recommended External Deadline&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='recommendedExternalDeadline' id="recommendedExternalDeadline" class="form-control" autofocus style='display: block; width:100%' required>

                                            <%                                                for (String key : alltimeLines.keySet()) {
                                                    if (key.equals("actualEciTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='ECI'>" + str + "</option>");
                                                    }
                                                    if (key.equals("actualTaxTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Tax'>" + str + "</option>");
                                                    }
                                                    if (key.equals("actualGstTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='GST'>" + str + "</option>");
                                                    }
                                                    if (key.equals("actualMgtTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Management'>" + str + "</option>");
                                                    }
                                                    if (key.equals("actualFinTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Final Accounting'>" + str + "</option>");
                                                    }
                                                    if (key.equals("actualSecTimeline")) {
                                                        String str = alltimeLines.get(key);
                                                        out.print("<option value='Secretarial'>" + str + "</option>");
                                                    }
                                                }

                                            %>
                                        </select>
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
                                        <label>External Deadline&nbsp</label>
                                    </td>
                                    <td>
                                        <input type="date" name="externalDeadlineCreate" id="externalDeadlineCreate" class="text ui-widget-content ui-corner-all"  style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Remarks&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <textarea name="remarksCreate" id="remarksCreate" class="text ui-widget-content ui-corner-all" cols="22" rows="3" style='display: block; width:100%' required></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <br/>
                                    </td>
                                </tr>
                                <tr bgcolor="#034C75" rowspan="8">
                                    <td colspan="7">
                                        <h4><font color="white">&emsp;Employees Assigned Information</font></h4>
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
                                        <label>Assigned Employee 1<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='assignedEmployee1' id="assignedEmployee1" class="form-control" autofocus style='display: block; width:100%' required>
                                            <option disabled selected value> — select an option — </option>
                                            <%                                                for (int i = 0; i < supList.size(); i++) {
                                                    out.println("<option value='" + supList.get(i) + "'>" + supList.get(i) + "</option>");
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Assigned Employee 2<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='assignedEmployee2' id="assignedEmployee2" class="form-control" autofocus style='display: block; width:100%' required>
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
                                        <label>Reviewer&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='reviewer' id="reviewer" class="form-control" autofocus style='display: block; width:100%' required>
                                            <option disabled selected value> — select an option — </option>
                                            <%
                                                for (int j = 0; j < supList.size(); j++) {
                                                    out.println("<option value='" + supList.get(j) + "'>" + supList.get(j) + "</option>");
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <td colspan="4">
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
                                    </form>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button id="btnCreateProject" class="btn btn-lg btn-primary btn-block btn-success" type="submit">Create</button>
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
                    </div>
                </div>
            </div>
        </nav>      
        <script>
            $(document).ready(function () {
                var options = $("#recommendedInternalDeadline").html();
                $("#projectTypeCreate").change(function (e) {
                    var text = $("#projectTypeCreate :selected").text();
                    $("#recommendedInternalDeadline").html(options);
                    $('#recommendedInternalDeadline :not([value^="' + text + '"])').remove();
                });

                var options1 = $("#recommendedExternalDeadline").html();
                $("#projectTypeCreate").change(function (e) {
                    var text1 = $("#projectTypeCreate :selected").text();
                    $("#recommendedExternalDeadline").html(options1);
                    $('#recommendedExternalDeadline :not([value^="' + text1 + '"])').remove();
                });
            });

        </script>
        <script>
            $('#btnCreateProject').click(function () {
                var clientID = document.getElementById("profileId").value;
                var title = document.getElementById("projectTitleCreate").value;
                var companyName = document.getElementById("companyNameCreate").value;
                var remarks = document.getElementById("remarksCreate").value;
                var projectType = document.getElementById("projectTypeCreate").value;
                var recommendedInternal = $("#recommendedInternalDeadline option:selected").html();
                var internal = document.getElementById("internalDeadlineCreate").value;
                var recommendedExternal = $("#recommendedExternalDeadline option:selected").html();
                var external = document.getElementById("externalDeadlineCreate").value;
                var emp1 = document.getElementById("assignedEmployee1").value;
                var emp2 = document.getElementById("assignedEmployee2").value;
                var reviewer = document.getElementById("reviewer").value;

                if (title === "") {
                    alert("Project Title required");
                } else if (companyName === "") {
                    alert("Company Name required");
                } else if (emp1 === "") {
                    alert("Assigned Employee required");
                } else if (emp2 === "") {
                    alert("Second Employee required");
                } else if (reviewer === "") {
                    alert("Reviewer required");
                } else if (remarks === "") {
                    alert("Remarks required");
                } else {
                    $.ajax({
                        url: 'CreateNewProject',
                        data: 'title=' + title + '&' + 'companyName=' + companyName + '&' + 'remarks=' + remarks + '&' + 'projectType=' + projectType + '&' + 'recommendedInternal=' + recommendedInternal
                                + '&' + 'internal=' + internal + '&' + 'recommendedExternal=' + recommendedExternal + '&' + 'external=' + external
                                + '&' + 'emp1=' + emp1 + '&' + 'emp2=' + emp2 + '&' + 'reviewer=' + reviewer + '&' + 'clientID=' + clientID,
                        type: 'POST',
                        success: function () {
                            var string = "/AMS/ClientProfile.jsp?profileId=" + clientID;
                            window.location.href = string;
                        },
                        error: function () {
                            var string = "/AMS/ClientProfile.jsp?profileId=" + clientID;
                            window.location.href = string;
                        }
                    });
                }

            });
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>