<%-- 
    Document   : ExpenseResult
    Created on : Dec 24, 2017, 5:19:53 PM
    Author     : Bernitatowyg
--%>

<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="Entity.Token"%>
<%@page import="DAO.TokenDAO"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="Entity.Excel"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="Protect.jsp" %>

<html>
    <head>
        <title>Process Invoice | Abundant Accounting Management System</title>
        <%            /**
             * Check if future "expensefuture" exist, if not, display no job submitted message 
             * if exist, check if done. If not, display still ongoing with info from request session ef
             * if done, display resutls and clear ef and future from session using future.get()
             *
             */
            if (request.getSession().getAttribute("excel") == null) {
                request.setAttribute("UploadExcelResponse", "Missing excel attribute at ExpenseResult.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("UploadExpense.jsp");
                rd.forward(request, response);
            }
            Excel excel = (Excel) request.getSession().getAttribute("excel");
            String client = excel.getCompanyName();
            String numProjected = (String) request.getAttribute("projectedNumber");
            String[][] results = (String[][]) request.getAttribute("results");
            int numberOfItems = results.length;
            String actualProccessed = results[0][1];
            String actualError = results[0][2];

            if (request.getSession().getAttribute("invoiceProjectId") == null) {
                request.setAttribute("UploadExcelResponse", "Missing project id ExpenseResult.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("UploadExpense.jsp");
                rd.forward(request, response);
            }
            String projectId = (String) request.getSession().getAttribute("invoiceProjectId");
            Project p = ProjectDAO.getProjectByID(projectId);
            String projectUrl = "ProjectProfile.jsp?projectID=";
            projectUrl += projectId;
            //Boolean canProceed = true;
            request.getSession().removeAttribute("realmid");
            request.getSession().removeAttribute("invoiceProjectId");
            request.getSession().removeAttribute("excel");
            // Rows below are for debugging
            int numInvoice = Integer.parseInt(actualProccessed);
            numInvoice += p.getNumberOfInvoices();
            p.setNumberOfInvoices(numInvoice);
            ProjectDAO.updateProject(p);

            // Get all the data 
            // These are the new stuff
            //String[][] lineItems = (String[][]) excel.getLineItems();
            String empId = (String) session.getAttribute("userId");
            EmployeeDAO empDAO = new EmployeeDAO();
            Employee employee = empDAO.getEmployeeByID(empId);
            String employeeName = "";
            if (employee == null) {
                employeeName = "No User";
            } else {
                employeeName = employee.getName();
            }
            String sessionUserIsAdmin = employee.getIsAdmin();


        %>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
            });
        </script>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 100%; height: 100%; margin-top: <%=session.getAttribute("margin")%>">
                    <%                        if (client != null && client != "") {
                    %>
                    <h1 style="text-align: center">Results for <%=client%></h1>
                    <%
                    } else {
                    %>
                    <h1 style="text-align: center">Invoices</h1>
                    <%
                        }
                    %>
                    <!--
                    ###########################################################################################################################
                    -->         
                    <br/>
                    <div align="center">
                        <table width="60%" height="60%" style='border-bottom: #1b6d85; border-top: #1b6d85' cellpadding="10">
                            <tr>
                                <td width="20%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Projected Number Of Successful Invoices
                                    </label>
                                </td>
                                <td width="20%">
                                    <%=numProjected%>
                                </td>
                                <td width="20%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Total Successfully Submitted Invoices
                                    </label>
                                </td>
                                <td width="20%">
                                    <%=actualProccessed%>
                                </td>
                                <td width="20%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Total Erroneous Invoices
                                    </label>
                                </td>
                                <td width="20%">
                                    <%=actualError%>
                                </td>
                            </tr>
                        </table>  
                    </div>
                    <br/>
                    <br/>
                    <!--
                    ###########################################################################################################################
                    -->
                    <!--
                        for object[][] First 8 rows are expense info, 9 and below are the line items
                    -->
                    <div align="center" style='width: 80%; display: inline-block'>
                        <table id="datatable" style="border: #FFFFFF; text-align:center; overflow:auto" align="center">
                            <thead>
                                <tr>
                                    <th width="10%" Style="text-align:left">#</th>
                                    <th width="20%" Style="text-align:left">Invoice Id</th>
                                    <th width="70%" Style="text-align:left">Message</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (numberOfItems != 0) {
                                        String colorCode;
                                        for (String[] row : results) {

                                            if (row[0] == null) {
                                                break;
                                            } else if (row[0].equals("0")) {
                                                continue;
                                            }

                                            if (row[1].equals("0")) {
                                                colorCode = "#ffb6c1";
                                            } else {
                                                colorCode = "#F0F8FF";
                                            }
                                %>
                                <tr style="background-color: <%=colorCode%>">

                                    <td style="font-size: 14px; text-align:left" width="10%">
                                        <%=row[0]%>
                                    </td>
                                    <td style="font-size: 14px; text-align:left" width="20%">
                                        <%=(row[1] == null) ? "missing" : row[1]%>
                                    </td>
                                    <td style="font-size: 14px;" width="70%">
                                        <%=(row[2] == null) ? "missing" : row[2]%>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <br/>
                    <br/>
                    <table style="text-align: right" width="90%">
                        <tr width="90%">
                            <td width="80%">
                                &nbsp;
                            </td>
                            <td>
                                <form action="<%= projectUrl%>" method="post">
                                    <button class="btn btn-lg btn-primary btn-block" type="submit">Go to project</button>
                                </form>
                            </td>
                            <td width="1%">
                                &nbsp;
                            </td>
                            <td>
                                <form action="saveResultsServlet" method="post">
                                    <!-- Reminder: send over filename and results -->
                                    <button class="btn btn-lg btn-primary btn-block btn-success" type="submit" >Save to email</button>
                                </form>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </nav>
</nav>
</body>
<jsp:include page="Footer.html"/>
</html>
