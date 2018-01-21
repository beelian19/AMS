<%-- 
    Document   : EditToken
    Created on : Jan 16, 2018, 2:28:20 AM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Token | Abundant Accounting Management System</title>
        <%            String clientId = (request.getAttribute("clientId") != null) ? (String) request.getAttribute("clientId") : "NA";
            String clientSecret = (request.getAttribute("clientSecret") != null) ? (String) request.getAttribute("clientSecret") : "NA";
            String taxEnabled = (request.getAttribute("taxEnabled") != null) ? (String) request.getAttribute("taxEnabled") : "NA";
            String redirectURI = (request.getAttribute("redirectURI") != null) ? (String) request.getAttribute("redirectURI") : "NA";
            if (request.getAttribute("companyId") == null) {
                request.getSession().setAttribute("status", "Error: No company id parsed at EditToken.jsp");
                request.getRequestDispatcher("TokenOverview.jsp").forward(request, response);
            }
            String companyId = (String) request.getAttribute("companyId");
            Client client = ClientDAO.getClientById(companyId);
            if (client == null) {
                request.getSession().setAttribute("status", "Error: No company with company AMS id of " + companyId);
                request.getRequestDispatcher("TokenOverview.jsp").forward(request, response);
            }
            String clientName = client.getCompanyName();

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
                    <h1>Edit Token For <%=clientName%></h1>
                    <br/>
                    <div class="container-fluid">
                        <form action="EditTokenServlet" method="post">
                            <table width="100%" height="100%" style="text-align: left">
                                <tr bgcolor="#034C75" rowspan="8">
                                    <td colspan="7">
                                        <h4><font color="white">&emsp; Token Information</font></h4>
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
                                        <label for="clientId">Client ID&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="clientId" id="clientId" class="text ui-widget-content ui-corner-all" value='<%=clientId%>' required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="clientSecret">Client Secret&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="clientSecret" id="clientSecret" class="text ui-widget-content ui-corner-all" value='<%=clientSecret%>' required>
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
                                        <label for="redirectURI">Redirect URI&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="redirectURI" id="redirectURI" class="text ui-widget-content ui-corner-all" value='<%=redirectURI%>' required>
                                    </td>
                                    <td width="15%">
                                    </td>
                                    <td>
                                        <label for="companyId">Tax Enabled (y/n) &nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <input type="text" name="taxEnabled" id="taxEnabled" class="text ui-widget-content ui-corner-all" value='<%=taxEnabled%>'  required>
                                    </td>
                                    <td width="1%">
                                    </td>
                                </tr>
                                <tr>
                                    <td width="1%">
                                    </td>
                                    <td>
                                        <label for="companyId">Company ID&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td>
                                        <%=companyId%>
                                        <input type="text" name="companyId" id="companyId" class="text ui-widget-content ui-corner-all" value='<%=companyId%>' hidden required>
                                    </td>

                                    <td colspan="5">
                                        <br/>
                                    </td>
                                </tr>
                            </table>
                            <table style="width: 100%; position: absolute; bottom: 10px;">
                                <tr>
                                    <td style="width: 61%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block" type="reset">Reset Fields</button>
                                    </td>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">Update</button>
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
