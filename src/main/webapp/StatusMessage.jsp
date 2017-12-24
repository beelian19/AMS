<%-- 
    Document   : StatusMessage
    Created on : Dec 24, 2017, 5:09:02 PM
    Author     : Bernitatowyg
--%>

<%
        String status = (String) session.getAttribute("status");
        String margin = "0%";
        if (status != null) {
            if (status.contains("Error:")) {
    %>
    <div class="alert alert-danger" width="100%">
        <Strong><center><%=status%></center></Strong>
    </div>
    <%
    } else {
    %>
    <div class="alert alert-success" width="100%">
        <Strong><center><%=status%></center></Strong>
    </div>
    <%
            }
        } else {
            // do nothing
            margin = "12%";
        }
        session.setAttribute("margin", margin);
        session.setAttribute("status", null);
    %>