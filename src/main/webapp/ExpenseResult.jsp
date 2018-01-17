<%-- 
    Document   : ExpenseResult
    Created on : Dec 24, 2017, 5:19:53 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.SampleData"%>
<%@page import="java.util.concurrent.ExecutionException"%>
<%@page import="Entity.Payment"%>
<%@page import="Entity.PaymentFactory"%>
<%@page import="java.util.concurrent.Future"%>
<%@page import="Module.Expense.ExpenseFactory"%>
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
        <title>Invoice Results | Abundant Accounting Management System</title>
        <%            
            
            Future<PaymentFactory> qboFuture;
            if (request.getSession().getAttribute("expenseFuture") == null) {
                request.getSession().setAttribute("status", "Error: No job running found");
                response.sendRedirect("UploadExpense.jsp");
                return;
            }
            qboFuture = (Future<PaymentFactory>) request.getSession().getAttribute("expenseFuture");
            if (!qboFuture.isDone()) {
                request.getSession().setAttribute("status", "Payment job is still running");
                response.sendRedirect("UploadExpense.jsp");
                return;
            }

            PaymentFactory pf = null;

            try {
                pf = qboFuture.get();
            } catch (InterruptedException | ExecutionException ex) {
                request.getSession().setAttribute("status", "Error: Critical error " + ex.getMessage());
                response.sendRedirect("UploadExpense.jsp");
                return;
            }

            Client client = (request.getSession().getAttribute("paymentClient") != null) ? (Client) request.getAttribute("expenseClient") : null;
            if (client == null) {
                request.getSession().setAttribute("status", "Error: Null Client at ExpenseResult.jsp");
                request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
                return;
            }
            
            List<Payment> postList = pf.getPostPayments();
            List<String> processMessage = pf.getProcessMessages();
            if (processMessage == null) processMessage = new ArrayList<>();
            String clientName = client.getCompanyName();
            
            
            /*
            List<Payment> postList = SampleData.loadPostPaymentList();
            //List<Payment> postList = new ArrayList<>();
            List<String> processMessage = new ArrayList<>();
            //processMessage.add("test");
            //processMessage.add("test1");
            String clientName = "test";
            */

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
                    <%                        if (clientName != null && clientName != "") {
                    %>
                    <h1 style="text-align: center">Results for <%=clientName%></h1>
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
                        <%
                            if (!processMessage.isEmpty()) {

                        %>
                        <table width="60%" height="60%" style='border-bottom: #1b6d85; border-top: #1b6d85' cellpadding="10">
                            <tr>
                                <td width="50%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Processing errors
                                    </label>
                                </td>
                            </tr>
                            <%                                for (String error : processMessage) {
                            %>
                            <tr>
                                <td width="20%">
                                    <%=error%>
                                </td>
                            </tr>

                            <%
                                    }
                                }
                            %>      
                        </table> 
                    </div>
                    <br/>
                    <br/>
                    <!--
                    ###########################################################################################################################
                    -->
                    <div align="center" style='width: 80%; display: inline-block'>
                        <table id="datatable" style="border: #FFFFFF; text-align:center; overflow:auto" align="center">
                            <thead>
                                <tr>
                                    <th width="20%" Style="text-align:left">Reference Number</th>
                                    <th width="80%" Style="text-align:left">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (postList != null || !postList.isEmpty()) {
                                        String colorCode;
                                        for (Payment p : postList) {
                                            if (p.getStatus().toLowerCase().contains("error")) {
                                                colorCode = "#FFB6C1";
                                            } else {
                                                colorCode = "#F0F8FF";
                                            }

                                %>
                                <tr style="background-color: <%=colorCode%>">
                                    <td style="font-size: 14px; text-align:left" width="10%">
                                        <%=p.getReferenceNumber()%>
                                    </td>
                                    <td style="font-size: 10px; text-align:left" width="20%">
                                        <%=p.getStatus()%>
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
                    <table style="text-align: right" width="20%">
                        <tr width="20%">
                            <td>
                                <form action="saveResultsServlet" method="post">
                                    <!-- Reminder: send over filename and results -->
                                    <button class="btn btn-lg btn-primary btn-block btn-success" type="submit" >Send to email and clear results</button>
                                </form>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <form action="clearResultsServlet" method="post">
                                    <!-- Reminder: send over filename and results -->
                                    <button class="btn btn-lg btn-primary btn-block btn-success" type="submit" >Clear results</button>
                                </form>
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
