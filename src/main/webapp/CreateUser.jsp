<%-- 
    Document   : CreateUser
    Created on : Dec 24, 2017, 4:50:55 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Employee"%>
<%@include file="Protect.jsp"%>
<%@include file="AdminAccessOnly.jsp"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create User | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; margin-top: <%=session.getAttribute("margin")%>" width="100%" height='100%'>
                    <h1>Create User</h1>
                    <br/>
                    <div class="container-fluid">
                        <form action="AddEmployee" method="post">
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
                                        <label>Employee Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='employeeName' id="employeeName" placeholder="Employee's Name" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Employee NRIC&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='employeeNRIC' id="employeeNRIC" placeholder="Employee's NRIC"  onkeyup="return limitlength(this, 9)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <label>Employee Email&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="email" name='employeeEmail' id="employeeEmail" placeholder="Employee's Email" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Employee Mobile Number&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='employeeNumber' id="employeeNumber" placeholder="Employee's Number" onkeypress="return numbersonly(event)" onkeyup="return limitlength(this, 8)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <label>Nationality&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <Select name='nationality' id="nationality" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option -- </option>
                                            <option value="foreigner">Foreigner</option>
                                            <option value="pr">PR</option>
                                            <option value="singaporean">Singaporean</option>
                                        </Select>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Date of Birth&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <%
                                            int year = Calendar.getInstance().get(Calendar.YEAR);
                                            int maxDByear = year - 16;
                                            String maxDate = maxDByear + "-12-31";
                                        %>
                                        <input type="date" name='dob' id="dob" max="<%=maxDate%>" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <label>Employee Bank Account&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='employeeBankAccount' id="employeeBankAccount" placeholder="Employee's Bank Account" onkeyup="return limitlength(this, 25)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Temporary Password&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='tempPassword' id="tempPassword" placeholder="Temporary Password" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <h4><font color="white">&emsp; Company Information</font></h4>
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
                                        <label>Employee Position&nbsp;</label>
                                    </td>
                                    <td>
                                        <select name='employeePosition' id="employeePosition"  class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option -- </option>
                                            <option value="Full-time Employee">Full-time Employee</option>
                                            <option value="Part-time Employee">Part-time Employee</option>
                                            <option value="Intern">Intern</option>
                                            <option value="Contract Employee">Contract Employee</option>
                                        </select>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Date Joined&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="date" name='dateJoined' id="dateJoined" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <label>Supervisor&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='supervisor' id="supervisor" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option -- </option>
                                            <option value="yes">Yes</option>
                                            <option value="no">No</option>
                                        </select>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Monthly Overhead&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='employeeSalary' id="employeeSalary" placeholder="Employee's Salary" onkeypress="return numbersonly(event)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
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
                                        <label>Has Admin Access&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <Select name='isAdmin' id="isAdmin" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option -- </option>
                                            <option value="yes">Yes</option>
                                            <option value="no">No</option>
                                        </Select>
                                    </td> 
                                    <td colspan="4">
                                    </td>
                                </tr>
                                <tr>
                                <tr>
                                    <td colspan="7">
                                        <br/><br/><br/>
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
