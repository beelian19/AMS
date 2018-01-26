<%-- 
    Document   : TokenOverview
    Created on : Jan 13, 2018, 6:54:30 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.Map"%>
<%@page import="Entity.Token"%>
<%@page import="Entity.Token"%>
<%@page import="DAO.TokenDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.util.ArrayList"%>
<%@include file="Protect.jsp"%>
<%@page autoFlush="true" buffer="1094kb"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View All Token | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function () {
                $('#datatable').DataTable();
            })
        </script>
        <%             
            ArrayList<Client> clientList;
            clientList = ClientDAO.getAllClient();
            Map<Integer, Token> tokenMap = TokenDAO.getAllTokenMap();
        %>
    </head>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 80%;margin-top: <%=session.getAttribute("margin")%>">
                    <h1>All Tokens</h1>
                    <form action="ResetToken" method="post">
                        <div class="container-fluid" width="100%" height="100%" style="text-align: left;">
                            <table id="datatable" style="border: #FFFFFF" width="100%" height="100%">
                                <thead>
                                    <tr>
                                        <th>Client ID</th>
                                        <th>Company Name</th>
                                        <th>Has Token</th>
                                        <th>Select</th>
                                    </tr> 
                                </thead>
                                <tbody>
                                    <%
                                        if (clientList != null && !clientList.isEmpty()) {
                                            for (Client c: clientList) {
                                                
                                    %>
                                    <tr>
                                        <td>
                                            <%=c.getClientID()%>
                                        </td>
                                        <td>
                                            <%=c.getCompanyName()%>
                                        </td>
                                        <td>
                                            <%=(tokenMap.get(c.getClientID()) != null) ? "Y" : "N"%>
                                        </td>
                                        <td>
                                            <input type="radio" name="companyId" value='<%=c.getClientID()%>' required>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                            <br/><br/>
                            <table style="width: 100%" align="right">
                                <tr>
                                    <td style="width: 61%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block" type="submit" name="edit" value="edit">Edit</button>
                                    </td>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit" name="refreshToken" value="refreshToken">Refresh Token</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br/><br/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </nav>
        <br/>
    </body>
    <jsp:include page="Footer.html"/>
</html>
