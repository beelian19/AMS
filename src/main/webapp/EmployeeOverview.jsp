<%-- 
    Document   : EmployeeOverview
    Created on : Dec 24, 2017, 5:11:13 PM
    Author     : Bernitatowyg
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="entity.Employee"%>
<%@page import="dao.EmployeeDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page autoFlush="true" buffer="1094kb"%>
<%@include file="Protect.jsp"%>
<%@include file="AdminAccessOnly.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View All Employees | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">

        <script type="text/javascript">
            $(document).ready(function(){
                $('#datatable').DataTable();
            })
        </script>
    </head>
  
    <%
       if (request.getAttribute("nameList") == null || request.getAttribute("emailList") == null
                    || request.getAttribute("isAdminList") == null || request.getAttribute("numberList") == null
                    || request.getAttribute("positionList") == null){
    %>
        <jsp:forward page="ViewEmployeeServlet"/>
    <%
       }
        ArrayList<String> nameList = new ArrayList();
        ArrayList<String> positionList = new ArrayList();
        ArrayList<String> idList = new ArrayList();
        ArrayList<String> emailList = new ArrayList();
        ArrayList<String> numberList = new ArrayList();
        ArrayList<String> adminAccessList = new ArrayList();  
        nameList = (ArrayList<String>)request.getAttribute("nameList");
        positionList = (ArrayList<String>)request.getAttribute("positionList");       
        emailList = (ArrayList<String>)request.getAttribute("emailList");
        numberList = (ArrayList<String>)request.getAttribute("numberList");
        adminAccessList = (ArrayList<String>)request.getAttribute("isAdminList");
        idList = (ArrayList<String>) request.getAttribute("idList");
        
        String profileUrl = "StaffProfile.jsp?profileName=";
        String profileUrl2 = "";

        boolean listErrors = false;
        if(nameList==null || nameList.size()!= positionList.size() || positionList.size() != emailList.size() || emailList.size() != numberList.size() || numberList.size() != adminAccessList.size()){
            listErrors = true;
        }
    %>
    <body width="100%" style='background-color: #F0F8FF;'>
        <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
            <div class="navbar-header" width="100%">
                <jsp:include page="Header-pagesWithDatatables.jsp"/>
            </div>
            <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <jsp:include page="StatusMessage.jsp"/>
                <div class="container-fluid" style="text-align: center; width:80%; height:80%; margin-top: <%=session.getAttribute("margin")%>">
                    <h1>All Employees</h1>
                    <div class="container-fluid">
                        <form action="ViewEmployeeServlet" method="post">
                            <table id="datatable" width="100%" height="100%" style="text-align: left">
                                <thead>
                                    <tr>
                                        <th width="16.67%">Name</th>
                                        <th width="16.67%">Position</th>
                                        <th width="16.67%">Email</th>
                                        <th width="16.67%">Number</th>
                                        <th width="16.67%">Admin Access</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    if(!listErrors){
                                        for(int i = 0; i<nameList.size(); i++){
                                %>
                                            <tr>
                                                <td width="16.67%">
                                                    <% profileUrl2 = profileUrl + idList.get(i); %>
                                                    <a href=<%=profileUrl2%>>
                                                        <%=nameList.get(i)%>
                                                    </a>
                                                </td>
                                                <td width="16.67%">
                                                    <%=positionList.get(i)%>
                                                </td>
                                                
                                                <td width="16.67%">
                                                    <%=emailList.get(i)%>
                                                </td>
                                                <td width="16.67%">
                                                    <%=numberList.get(i)%>
                                                </td>
                                                <td width="16.67%">
                                                    <%=adminAccessList.get(i)%>
                                                </td>
                                            </tr>
                                <%  
                                        }
                                    }
                                %>
                                </tbody>
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
