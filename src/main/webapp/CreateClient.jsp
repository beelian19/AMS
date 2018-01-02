<%-- 
    Document   : CreateClient
    Created on : Dec 24, 2017, 4:50:11 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Client | Abundant Accounting Management System</title>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>Create Client</h1>
                    <br/>
                    <div class="container-fluid">
                        <form action="AddClientServlet" method="post">
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
                                       <label>Company Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='companyName' id="companyName" placeholder="Company Name" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>UEN Number&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='UenNumber' id="UenNumber" placeholder="UEN Number" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                       <label>Incorporation Date&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="Date" name='incorporationDate' id="incorporationDate" placeholder="Incorporation Date" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Office Contact&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='officeContact' id="officeContact" placeholder="Office Contact" onkeypress="return numbersonly(event)" onkeyup="return limitlength(this, 9)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                       <label>Email Address&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="email" name='emailAddress' id="emailAddress" class="form-control" placeholder="Email Address" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Office Address&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='officeAddress' id="officeAddress" placeholder="Office Address" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                        <h4><font color="white">&emsp; Business Information</font></h4>
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
                                       <label>Business Type&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='businessType' id="businessType" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option --  </option>
                                            <option value="company">Company</option>
                                            <option value="partnership">Partnership</option>
                                            <option value="sole proprietorship">Sole Proprietorship</option>
                                        </select>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Financial Year End&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='financialYearEnd' id="financialYearEnd" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option --  </option>
                                            <option value="31-Jan">31-January</option>
                                            <option value="28-Feb">28-February</option>
                                            <option value="31-Mar">31-March</option>
                                            <option value="30-Apr">30-April</option>
                                            <option value="31-May">31-May</option>
                                            <option value="30-Jun">30-June</option>
                                            <option value="31-Jul">31-July</option>
                                            <option value="31-Aug">31-August</option>
                                            <option value="30-Sep">30-September</option>
                                            <option value="31-Oct">31-October</option>
                                            <option value="30-Nov">30-November</option>
                                            <option value="31-Dec">31-December</option>
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
                                       <label>GST Submission&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='gstSubmission' id="gstSubmission" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option --  </option>
                                            <option value="na">NA</option>
                                            <option value="m">Monthly</option>
                                            <option value="q">Quarterly</option>
                                            <option value="q">Semi Annual</option>
                                        </select> 
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Management Account&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <select name='mgmtAcc' id="mgmtAcc" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%; height: 30px'>
                                            <option disabled selected value> -- select an option --  </option>
                                            <option value="na">na</option>
                                            <option value="m15">m15</option>
                                            <option value="q15">q15</option>
                                            <option value="m6">m6</option>
                                            <option value="q6">q6</option>
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
                                        <h4><font color="white">&emsp; Director Information</font></h4>
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
                                       <label>Director Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='director' id="director" placeholder="Director Name" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Director's Email&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="email" name='secretaryEmail' id="secretaryEmail" placeholder="Director's Email" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                       <label>Director's Number&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='secretaryNumber' id="secretaryNumber" placeholder="Director's Number" onkeypress="return numbersonly(event)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Secretary Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='secretaryName' id="secretaryName" placeholder="Secretary Name" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                        <h4><font color="white">&emsp; Accountant Information</font></h4>
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
                                       <label>Accountant Name&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='accountantName' id="accountantName" placeholder="Accountant Name" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label>Accountant Email&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="email" name='accountantEmail' id="accountantEmail" placeholder="Accountant Email" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                       <label>Accountant Number&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name='accountantNumber' id="accountantNumber" placeholder="Accountant Number" onkeypress="return numbersonly(event)" class="text ui-widget-content ui-corner-all" required autofocus style='display: block; width:100%'>
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
                                    <td colspan="4">
                                        <br/>
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