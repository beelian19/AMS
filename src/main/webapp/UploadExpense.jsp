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
    <%        String expenseJobRunning = (String) session.getAttribute("expenseJobRunning");
        if (expenseJobRunning != null) {
            session.setAttribute("status", "Error: Please try again later, there is an expense job currently running");
        }
        List<String> errors = (request.getAttribute("messages") != null) ? (List<String>) request.getAttribute("messages") : null;


    %>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" width="100%" height='100%' style="margin-top: <%=session.getAttribute("margin")%>" align="center">
                    <h1>Upload expenses into Quickbook</h1>
                    <div class="container-fluid" align="center" style='width: 40%; display: inline-block'>
                        <form action = "ReadExcelFile" method = "post" enctype = "multipart/form-data">
                            <table align="center" width="100%" style="align: center">
                                <tr>
                                    <td colspan="4">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <Strong>Upload a new expense xlsx file</Strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <%
                                            if (expenseJobRunning == null) {
                                        %>
                                        <input id="file-upload" type = "file" name = "file" value="Choose Files to Upload" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" style='display: block; width:100%; height: 30px' required/>
                                        <%
                                        } else {
                                        %>  
                                        <input id="file-upload" type = "file" name = "file" value="Choose Files to Upload" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" style='display: block; width:100%; height: 30px' disabled/>
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    if (errors != null) {
                                        for (String error : errors) {
                                %>
                                <tr>
                                    <td colspan="4">
                                        <p> <font color="red"><%=error%></font></p>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                <tr>
                                    <td colspan="4">
                                        <% if (request.getAttribute("UploadExcelSuccess") != null || request.getAttribute("UploadExcelResponse") != null) {%>
                                        <p><font color="green"><%=(request.getAttribute("UploadExcelSuccess") != null) ? request.getAttribute("UploadExcelSuccess") : ""%></font></p>
                                        <p><font color="red"><%=(request.getAttribute("UploadExcelResponse") != null) ? request.getAttribute("UploadExcelResponse") : ""%></font></p>
                                            <%}%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/><br/><br/><br/><br/><br/><br/><br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 5%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 15%">
                                        <button class="btn btn-lg btn-primary btn-block" type="reset">Cancel</button>
                                    </td>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 15%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit" id="file-validate" value="Validate Expense">Validate Expense</button>
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