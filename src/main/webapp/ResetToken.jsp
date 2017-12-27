<%-- 
    Document   : ResetToken
    Created on : Dec 24, 2017, 5:15:35 PM
    Author     : Bernitatowyg
--%>

<%@page import="Entity.Client"%>
<%@page import="java.util.ArrayList"%>
<%@page import="DAO.ClientDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Reset Token | Abundant Accounting Management System</title>
        <%
            ArrayList<String> clientNameList = new ArrayList<>();
            ArrayList<Integer> clientIdList = new ArrayList<>();
            
            clientNameList = ClientDAO.getAllCompanyNames();
            for(int i=0; i<clientNameList.size(); i++){
                clientIdList.add(i, (ClientDAO.getClientByCompanyName(clientNameList.get(i))).getClientID());
            }
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
                    <h1>Reset Token</h1>
                    <div class="container-fluid" style="width: 20%">
                        <!-- Parse in QBO/XERO after midterms-->
                        <form action = "refreshTokenServlet" method = "post">
                            <select name="clientSelected" id="clientSelected" required>
                                <option disabled selected value> -- select an option -- </option>
                                <%
                                    if (clientNameList.size() == clientIdList.size()) {
                                        for (int i = 0; i < clientNameList.size(); i++) {
                                %>
                                <option class="optionFont" value=<%=clientIdList.get(i)%>><%=clientNameList.get(i)%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <br/><br/>
                            <button class="btn btn-lg btn-primary btn-block" type="submit" value="Reset Token">Reset Token</button>
                        </form>
                    </div>
                </div>
            </div>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>
