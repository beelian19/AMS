<%-- 
    Document   : ProcessExpense
    Created on : Dec 24, 2017, 5:19:39 PM
    Author     : Bernitatowyg
--%>

<%@page import="dao.ProjectDAO"%>
<%@page import="entity.Project"%>
<%@page import="entity.Token"%>
<%@page import="dao.TokenDAO"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="entity.Excel"%>
<%@page import="java.util.Arrays"%>
<%@page import="Account.QBOPurchaseHelper"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="java.util.ArrayList"%>
<%@page import="entity.Employee"%>
<%@page import="dao.EmployeeDAO"%>
<%@page import="entity.Client"%>
<%@page import="dao.ClientDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="Protect.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice Management Module | Abundant Accounting Management System</title>
        <style type="text/css">
            /* Popup container - can be anything you want */
            .popup {
                position: relative;
                display: inline-block;
                cursor: pointer;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
            }

            /* The actual popup */
            .popup .popuptext {
                visibility: hidden;
                width: 500px;
                background-color: #555;
                color: #fff;
                text-align: left;
                border-radius: 6px;
                padding: 8px 0;
                position: absolute;
                z-index: 1;
                bottom: 125%;
                left: 50%;
                right: 50%;
            }

            /* Popup arrow */
            .popup .popuptext::after {
                content: "";
                position: absolute;
                top: 100%;
                left: 10%;
                margin-left: -5px;
                border-width: 5px;
                border-style: solid;
                border-color: #555 transparent transparent transparent;
            }

            /* Toggle this class - hide and show the popup */
            .popup .show {
                visibility: visible;
                -webkit-animation: fadeIn 0.5s;
                animation: fadeIn 0.5s;
            }

            /* Add animation (fade in the popup) */
            @-webkit-keyframes fadeIn {
                from {opacity: 0;} 
                to {opacity: 1;}
            }

            @keyframes fadeIn {
                from {opacity: 0;}
                to {opacity:1 ;}
            }
        </style>
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
        <%            // Ensure that the workbook is there, if not redirect to InvoiceManagement.jsp
            if (request.getSession().getAttribute("excel") == null) {
                request.setAttribute("UploadExcelResponse", "Missing excel attribute at process-invoice.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("InvoiceManagement.jsp");
                rd.forward(request, response);
            }
            Excel excel = (Excel) request.getSession().getAttribute("excel");

            Boolean canProceed = false;
            // Get all the data 
            // These are the new stuff
            String clientSelected = "debug";
            String projectId = "";
            Project project = null;
            if (request.getSession().getAttribute("invoiceProjectId") == null) {
                request.setAttribute("UploadExcelResponse", "Missing project attribute at process-invoice.jsp");
                RequestDispatcher rd = request.getRequestDispatcher("InvoiceManagement.jsp");
                rd.forward(request, response);
            } else {
                projectId = (String) request.getSession().getAttribute("invoiceProjectId");
                project = ProjectDAO.getProjectByID(projectId);
                clientSelected = project.getCompanyName();
                canProceed = true;
            }

            String chargedAccount = excel.getChargedAccountName();
            String clientName = excel.getCompanyName();
            String chargedAccountNumber = excel.getChargedAccountNumber();
            String fromDate = excel.getFromDate();
            String toDate = excel.getToDate();
            String totalInvoices = excel.getNumberOfInvoices() + "";
            String numInvoicesProcessing = excel.getLineItemsCount() + "";
            String realmid = null;
            realmid = ClientDAO.getClientRealmid(clientSelected);
            if (realmid == null || realmid.trim().equals("")) {
                realmid = "---No realmid detected---";
                canProceed = false;
                //set canproceed to false;
            }
            Token token = null;
            //todo GEt QBO or XERO
            if (project != null) {
                token = TokenDAO.getToken(ClientDAO.getClientByCompanyName(clientSelected).getClientID());
            }

            if (token == null) {
                request.setAttribute("UploadExcelResponse", "Token is not found for project id: " + projectId);
                RequestDispatcher rd = request.getRequestDispatcher("InvoiceManagement.jsp");
                rd.forward(request, response);
            }

            if (token.getInUse()) {
                request.setAttribute("UploadExcelResponse", "Access token QBO is in use. Only one user may use is at one time");
                RequestDispatcher rd = request.getRequestDispatcher("InvoiceManagement.jsp");
                rd.forward(request, response);
                return;
            }
            int numberOfItems = 0;
            String[][] lineItems = new String[1][1];
            lineItems[0][0] = "No lineItems detected";
            if (excel.getInitialized()) {
                lineItems = (String[][]) excel.getLineItems();
                numberOfItems = lineItems.length;
            } else {
                canProceed = false;
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
                    <%                        if (clientSelected != "") {
                    %>
                    <h2 style="text-align: center">
                        Invoices for <%=clientSelected%>
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
                    <div class="popup" onclick="helpPopup()">(Click here for help)
                        <span class="popuptext" id="myPopup">
                            &nbsp;1. Client's realmid has to be present to confirm the invoices
                            <br/>
                            &nbsp;2. For line items to be valid, there must not be any "--Needed--" tags in the row
                            <br/>
                            &nbsp;3. A clear line does not necessarily mean that the row invoice will be processed. &nbsp;&nbsp;Check results after to confirm. 
                        </span>
                    </div>
                    </br>
                    <br/>
                    <div class="container-fluid" align="center">
                        <table width="60%" height="60%" border="1px" cellpadding="10">
                            <tr>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Charged Account
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
                                        Client Account Id
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=realmid%>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Invoices From Date
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=fromDate%>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Invoices To Date
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=toDate%>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Total Valid Invoices
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=numInvoicesProcessing%>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%">
                                    <label Style="whitespace: nowrap" style="overflow-x:auto">
                                        Total Contained Invoices
                                    </label>
                                </td>
                                <td width="20%" style="padding-left: 2%; padding-right: 2%" style="overflow-x:auto">
                                    <%=totalInvoices%>
                                </td>
                            </tr>
                        </table>  
                    </div>
                    <br/>
                    <br/>
                    <table id="datatable" style="border: #FFFFFF; text-align:center; width: 100%; overflow:auto">
                        <thead>
                            <tr>
                                <th width="3%" Style="text-align:center">#</th>
                                <th width="10%">Transaction Date</th>
                                <th width="7%">Account #</th>
                                <th width="7%">Account</th>
                                <th width="7%">Description</th>
                                <th width="7%">Vendor</th>
                                <th width="7%">Ref Number</th>
                                <th width="7%">Location</th>
                                <th width="7%">Payment Method</th>
                                <th width="7%">Amount ex GST</th>
                                <th width="7%">GST Type</th>
                                <th width="7%">Amount inc GST</th>
                                <th width="7%">Memo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (numberOfItems != 0) {
                                    String colorCode;
                                    for (String[] row : lineItems) {
                                        if (row[1] == null || row[13] == null) {
                                            break;
                                        }

                                        if (row[13].equals("1")) {
                                            colorCode = "#ffffff";
                                        } else {
                                            colorCode = "#ffb6c1";
                                        }
                            %>
                            <tr style="background-color: <%=colorCode%>">

                                <td style="font-size: 14px; text-align:center ">
                                    <%=row[0]%>
                                </td>
                                <td style="font-size: 14px; text-align:center; font-weight:bold ">
                                    <%=(row[1] == null) ? "---Needed---" : row[1]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[2] == null) ? "---Needed---" : row[2]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[3] == null) ? "---Needed ---" : row[3]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[4] == null) ? "-" : row[4]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[5] == null) ? "---Needed---" : row[5]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[6] == null) ? "-" : row[6]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[7] == null) ? "-" : row[7]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[8] == null) ? "---Needed---" : row[8]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[9] == null) ? "---Needed---" : (row[9].contains("-")) ? row[9] + "(Negative)" : row[9]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[10] == null) ? "---Needed---" : row[10]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[11] == null) ? "---Needed---" : row[11]%>
                                </td>
                                <td style="font-size: 14px;">
                                    <%=(row[12] == null) ? "-" : StringUtils.substring(row[12], 0, 15) + "..."%>
                                </td>
                            </tr>
                            <%
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
                                <form action="InvoiceManagement.jsp" method="post">
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
                                <form action = "QBOExecutePurchase" method = "post">
                                    <button name="process-invoice" value="Submit" class="btn btn-lg btn-primary btn-block btn-success" type="submit">Confirm</button>
                                </form>
                                <%
                                } else {
                                %>
                                <form action = "Dank memes" method = "post">
                                    <button name="process-invoice" value="Submit" class="btn btn-lg btn-primary btn-block btn-success" type="submit" disabled>Confirm</button>
                                </form>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    </table>
                    <script>
                        // When the user clicks on div, open the popup
                        function helpPopup() {
                            var popup = document.getElementById("myPopup");
                            popup.classList.toggle("show");
                        }
                    </script>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>

