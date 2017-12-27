<%-- 
    Document   : ClientOverview
    Created on : Dec 24, 2017, 5:10:10 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.Employee"%>
<%@page import="DAO.EmployeeDAO"%>
<%@page import="Entity.Client"%>
<%@page import="DAO.ClientDAO"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="Protect.jsp"%>
<%@page autoFlush="true" buffer="1094kb"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View All Clients | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function(){
                $('#datatable').DataTable();
            })
        </script>
    </head>
        <!-- ########################################################## header ########################################################## -->
        <%            

            ArrayList<Integer> idList = new ArrayList();
            ArrayList<String> nameList = new ArrayList();
            ArrayList<String> businessTypeList = new ArrayList();

            ClientDAO clientDAO = new ClientDAO();
            ArrayList<Client> clientList = clientDAO.getAllClient();
            
            String profileUrl = "ClientProfile.jsp?profileId=";
            String profileUrl2 = "";
            
            if (clientList != null) {
                for (int i = 0; i < clientList.size(); i++) {
                    Client c = clientList.get(i);
                    int id = c.getClientID();
                    String name = c.getCompanyName();

                    idList.add(id);
                    nameList.add(name);
                    businessTypeList.add(c.getBusinessType());
                }
            }
           
        %>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width: 80%;margin-top: <%=session.getAttribute("margin")%>">
                    <h1>All Clients</h1>
                    <div class="container-fluid" width="100%" height="100%" style="text-align: left;">
                        <table id="datatable" style="border: #FFFFFF" width="100%" height="100%">
                            <thead>
                               <tr>
                                    <th>Client ID</th>
                                    <th>Company Name</th>
                                    <th>Business Type</th>
                                </tr> 
                            </thead>
                            <tbody>
                            <%
                                if (idList.size() == nameList.size()) {
                                    for (int i = 0; i < idList.size(); i++) {
                            %>
                                        <tr>
                                            <td>
                                                <%=idList.get(i)%>
                                            </td>
                                            <td>
                                                <% profileUrl2 = profileUrl + idList.get(i); %>
                                                <a href=<%=profileUrl2%>>
                                                    <%=nameList.get(i)%>
                                                </a>
                                            </td>
                                            <td>
                                               <%=businessTypeList.get(i)%>
                                            </td>
                                        </tr>
                            <%
                                    }
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </nav>
        <br/>
    </body>
    <jsp:include page="Footer.html"/>
</html>
