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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Create Project | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <%
            Client client = (Client) request.getAttribute("client");
            HashMap<String, String> alltimeLines = (HashMap<String, String>) request.getAttribute("allTimeLines");
            EmployeeDAO empDAO = new EmployeeDAO();
            ArrayList<String> supList = empDAO.getAllSupervisor();
            String clientName = client.getCompanyName();
            int profileId = client.getClientID();
            //System.out.println("Client ID: "+profileId);
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
                    <div class="container-fluid" align="center" style='width: 100%; display: inline-block'>
                        <form>
                            <table style="width:100%; text-align: left">
                                <tr>
                                    <td colspan="9">
                                        <br/><br/>
                                    </td>
                                </tr>
                                <tr>
                                    <!--Project Title (Input)-->
                                    <td width="1%">
                                    </td>
                                    <td width="16.167%">
                                        <label>Project Title&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <input type="text" name="projectTitleCreate" id="projectTitleCreate" class="text ui-widget-content ui-corner-all" style='display: block; width:100%' required>
                                        <input type="hidden" name="profileId" id="profileId" value="<%=profileId%>"/>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <!--Company Name (DropDown List)-->
                                    <td width="16.167%">
                                        <label>Company Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <input type="text" name="compName" value="<%=client.getCompanyName()%>" id="compName" class="text ui-widget-content ui-corner-all" readonly style='display: block; width:100%' required>  
                                        <input type='hidden' name='companyNameCreate' value='<%=client.getCompanyName()%>' id='companyNameCreate'>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <!--Financial Year End-->
                                    <td width="16.167%">
                                        <label>Financial Year End&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <input type="text" name="financialYearEndCreate" value="<%=client.getFinancialYearEnd()%>" id="financialYearEndCreate" class="text ui-widget-content ui-corner-all" readonly style='display: block; width:100%' required/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <!--Project Type (DropDown List)-->
                                    <td width="1%">
                                    </td>
                                    <td width="16.167%">
                                        <label style='display: block; width:100%'>Project Type&nbsp<font color="red">*</font></label> 
                                    </td>
                                    <td width="16.167%">
                                        <select name='projectTypeCreate' id="projectTypeCreate" class="form-control" autofocus style='display: block; width:100%' required>
                                            <option disabled selected value> — select an option — </option>
                                            <option value="tax">Tax</option>
                                            <option value="eci">ECI</option>
                                            <option value="gst">GST</option>
                                            <option value="mgt">Management</option>
                                            <option value="final">Final Accounting</option>
                                            <option value="secretarial">Secretarial</option>
                                        </select> 
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <!--Deadline (Compute Based on Project Type Selection)-->
                                    <td width="16.167%">
                                        <label>Recommended Internal Deadline&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
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
                                                //System.out.println("Check======== : " + companyNameList.size() + " : " + projectList.size());
                                            %>
                                        </select> 
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td width="16.167%">
                                        <label>Internal Deadline&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <input type="date" name="internalDeadlineCreate" id="internalDeadlineCreate" class="text ui-widget-content ui-corner-all" style='display: block; width:100%' required>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <!--Deadline (Compute Based on Project Type Selection)-->
                                    <td width="1%">
                                    </td>
                                    <td width="16.167%">
                                        <label>Recommended External Deadline&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <select name='recommendedExternalDeadline' id="recommendedExternalDeadline" class="form-control" autofocus style='display: block; width:100%' required>

                                            <%
                                                for (String key : alltimeLines.keySet()) {
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
                                                //System.out.println("Check======== : " + companyNameList.size() + " : " + projectList.size());
                                            %>
                                        </select>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td width="16.167%">
                                        <label>External Deadline&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <input type="date" name="externalDeadlineCreate" id="externalDeadlineCreate" class="text ui-widget-content ui-corner-all"  style='display: block; width:100%' required>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <!--Emp1 DropDown List-->
                                    <td width="16.167%">
                                        <label>Assigned Employee 1<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <select name='assignedEmployee1' id="assignedEmployee1" class="form-control" autofocus style='display: block; width:100%' required>
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
                                    <td colspan="9">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <!--Emp2 DropDown List-->
                                    <td width="1%">
                                    </td>
                                    <td width="16.167%">
                                        <label>Assigned Employee 2<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
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
                                        &nbsp;
                                    </td>
                                    <!--Reviewer DropDown List-->
                                    <td width="16.167%">
                                        <label>Reviewer&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%"> 
                                        <select name='reviewer' id="reviewer" class="form-control" autofocus style='display: block; width:100%' required>
                                            <option disabled selected value> — select an option — </option>
                                            <%
                                                for (int j = 0; j < supList.size(); j++) {
                                                    out.println("<option value='" + supList.get(j) + "'>" + supList.get(j) + "</option>");
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <!--<td width="1%">
                                        &nbsp;
                                    </td>
                                    <td width="16.167%">
                                        <label>Recurring Frequency&nbsp<font color="red">*</font></label> 
                                    </td>
                                    <td width="16.167%">
                                        <select name='frequency' id="frequency" class="form-control" required autofocus style='display: block; width:100%'>
                                            <option disabled selected value> — select an option — </option>
                                            <option value="na">NA</option>
                                            <option value="m">monthly</option>
                                            <option value="q">quarterly</option>
                                            <option value="s">semi annual</option>
                                        </select> 
                                    </td>-->
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <!--Remarks (Input)-->
                                    <td width="1%">
                                    </td>
                                    <td width="16.167%">
                                        <label>Remarks&nbsp<font color="red">*</font></label>
                                    </td>
                                    <td width="16.167%">
                                        <textarea name="remarksCreate" id="remarksCreate" class="text ui-widget-content ui-corner-all" cols="22" rows="3" style='display: block; width:100%' required></textarea>
                                    </td>
                                    <td colspan="6">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>


                            <table style="width: 100%">
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
                                        <button class="btn btn-lg btn-primary btn-block" type="reset">Reset</button>
                                    </td>
                                    </form>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button id="btnCreateProject" class="btn btn-lg btn-primary btn-block btn-success" type="submit">Create Project</button>
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
                    //console.log($('#recommendedExternalDeadline :not([value^="' + text.substr(0, text.indexOf(" "))+ '"])'));
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
            //console.log(projectType);
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
                }else if(companyName === "") {
                    alert("Company Name required");
                }else if(emp1 === "") {
                    alert("Assigned Employee required");
                }else if(emp2 === "") {
                    alert("Second Employee required");
                }else if(reviewer === "") {
                    alert("Reviewer required");
                }else if(remarks === "") {
                    alert("Remarks required");
                } else {
                    $.ajax({
                        url: 'AddProject',
                        data: 'title=' + title + '&' + 'companyName=' + companyName + '&' + 'remarks=' + remarks + '&' + 'projectType=' + projectType + '&' + 'recommendedInternal=' + recommendedInternal
                                + '&' + 'internal=' + internal + '&' + 'recommendedExternal=' + recommendedExternal + '&' + 'external=' + external
                                + '&' + 'emp1=' + emp1 + '&' + 'emp2=' + emp2 + '&' + 'reviewer=' + reviewer,
                        type: 'POST',
                        success: function () {
                            var string = "/ams-1.0/ClientProfile.jsp?profileId=" + clientID;
                            window.location.href = string;
                        },
                        error: function () {
                            var string = "/ams-1.0/ClientProfile.jsp?profileId=" + clientID;
                            window.location.href = string;
                        }
                    });
                }

            });
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>