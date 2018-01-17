<%-- 
    Document   : ProcessExpense
    Created on : Dec 24, 2017, 5:19:39 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.PaymentLine"%>
<%@page import="Entity.Payment"%>
<%@page import="Entity.PaymentFactory"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="Entity.Token"%>
<%@page import="DAO.TokenDAO"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="Entity.Excel"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice Management Module | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
            })
        </script>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <%            PaymentFactory pf = (request.getSession().getAttribute("paymentFactory") != null) ? (PaymentFactory) request.getSession().getAttribute("paymentFactory") : null;
            if (pf == null) {
                request.getSession().setAttribute("status", "Error: Null PaymentFactory at ProcessExpense.jsp");
                request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
            }

            String chargedAccount = pf.getChargedAccountName();
            Client client = (request.getSession().getAttribute("paymentClient") != null) ? (Client) request.getSession().getAttribute("paymentClient") : null;
            if (client == null) {
                request.getSession().setAttribute("status", "Error: Null Client at ProcessExpense.jsp");
                request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
            }

            Boolean canProceed = true;

            String clientName = client.getCompanyName();
            String chargedAccountNumber = pf.getChargedAccountNumber() + "";
            String realmid = null;
            realmid = client.getRealmid();
            if (realmid == null || realmid.isEmpty()) {
                realmid = "---No realmid detected---";
                canProceed = false;
            }
            Token token = pf.getToken();

            if (token.getInUse()) {
                request.getSession().setAttribute("status", "Error: Access token QBO is in use for " + clientName + ". Only one user may use is at one time");
                RequestDispatcher rd = request.getRequestDispatcher("UploadExpense.jsp");
                rd.forward(request, response);
                return;
            }

            List<Payment> preList = pf.getPrePayments();
            if (preList == null || preList.isEmpty()) {
                request.getSession().setAttribute("status", "Error: No payment objects found");
                request.getRequestDispatcher("UploadExpense.jsp").forward(request, response);
            }

        %>
        <!--
        ###########################################################################################################################
        -->
        <!--
            for object[][] First 8 rows are expense info, 9 and below are the line items
        -->
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" style="width:100%; height:100%; padding:0%; margin:0%;">
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%">
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center;margin-top: <%=session.getAttribute("margin")%>" width="100%" height='100%'>
                    <%                        if (clientName != "") {
                    %>
                    <h2 style="text-align: center">
                        Invoices for <%=clientName%>
                    </h2>
                    <%
                    } else {
                    %>
                    <h2 style="text-align: center">
                        Error in finding client
                    </h2>
                    <%
                        }
                    %>
                    </br>
                    <br/>
                    <div class="container-fluid" align="center">
                        <table width="60%" height="60%" border="1px" cellpadding="10">
                            <tr>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Charged Account Name
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=chargedAccount%>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Charged Account Number
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=chargedAccountNumber%>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Client Name
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=clientName%>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Client Realmid
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=realmid%>
                                </td>
                            </tr>

                        </table>  
                    </div>
                    <br/>
                    <br/>
                    <table id="datatable" style="border: #FFFFFF; text-align:center; width: 100%; overflow:auto">
                        <thead>
                            <tr>
                                <th width="2%" Style="text-align:center">xl#</th>
                                <th width="8%">Transaction Date</th>
                                <th width="6%">Reference No</th>
                                <th width="6%">Account Name</th>
                                <th width="6%">Account Number</th>
                                <th width="6%">Vendor</th>
                                <th width="6%">GST Type </th>
                                <th width="6%">Amount excl GST</th>
                                <th width="6%">Amount incl GST</th>
                                <th width="6%">Line Desc.</th>
                                <th width="6%">Payment Method</th>
                                <th width="6%">Location</th>
                                <th width="7%">Class</th>
                                <th width="6%">Customer</th>
                                <th width="6%">Memo</th>
                                <th width="12%">Init Message</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (preList != null) {
                                    String colorCode;
                                    int xlRow = 2;
                                    for (Payment p : preList) {
                                        for (PaymentLine pl : p.getLines()) {
                                            xlRow++;
                                            if (p.checkPayment() && pl.checkPaymentLine()) {
                                                colorCode = "#ffffff";
                                            } else {
                                                colorCode = "#ffb6c1";
                                            }
                            %>
                            <tr style="background-color: <%=colorCode%>">

                                <td style="font-size: 10px; text-align:center ">
                                    <%=xlRow%>
                                </td>
                                <td style="font-size: 10px; text-align:center; font-weight:bold ">
                                    <%=(p.getDateString() == null) ? "---Needed---" : p.getDateString()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(p.getReferenceNumber() == null) ? "No reference number" : p.getReferenceNumber()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getAccountName() == null) ? "No Account Name" : pl.getAccountName()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getAccountNumber() == null) ? "---Needed---" : pl.getAccountNumber()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(p.getVendor() == null) ? "---Needed---" : p.getVendor()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getTax() == null) ? "---Needed---" : pl.getTax()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getExTaxAmount() == null) ? "---Needed---" : (pl.getExTaxAmount() < 0.0) ? pl.getExTaxAmount() + "(Negative)" : pl.getExTaxAmount()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getIncTaxAmount() == null) ? "---Needed---" : (pl.getIncTaxAmount() < 0.0) ? pl.getIncTaxAmount() + "(Negative)" : pl.getIncTaxAmount()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getLineDescription() == null) ? "No Line Desc." : pl.getLineDescription()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(p.getPaymentMethod() == null) ? "Non Found. CASH inserted" : p.getPaymentMethod()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(p.getLocation() == null) ? "No Location Found" : p.getLocation()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getQBOLineClass() == null) ? "No Class Found" : pl.getQBOLineClass()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getQBOLineCustomer() == null) ? "No Customer Found" : pl.getQBOLineCustomer()%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(p.getMemo() == null) ? "No Memo Found" : StringUtils.substring(p.getMemo(), 0, 15) + "..."%>
                                </td>
                                <td style="font-size: 10px;">
                                    <%=(pl.getInitStatus().trim().equals("Init:")) ? "-" : pl.getInitStatus()%>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <br/>
                    <br/>
                    <table style="text-align: right" width="100%">
                        <tr width="90%">
                            <td width="80%">
                                &nbsp
                            </td>
                            <td>
                                <form action="UploadExpense.jsp" method="post">
                                    <button class="btn btn-lg btn-primary btn-block" type="submit">Back</button>
                                </form>
                            </td>
                            <td>
                                &nbsp
                            </td>
                            <td>
                                <%
                                    if (canProceed) {
                                %>
                                <form action = "ExecuteExpense" method = "post">
                                    <button name="ProcessExpense" value="Submit" class="btn btn-lg btn-primary btn-block btn-success" type="submit">Confirm</button>
                                </form>
                                <%
                                } else {
                                %>
                                <form action = "UploadExpense.jsp" method = "post">
                                    <button name="ProcessExpense" value="Submit" class="btn btn-lg btn-primary btn-block btn-success" type="submit" disabled>Confirm</button>
                                </form>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>

