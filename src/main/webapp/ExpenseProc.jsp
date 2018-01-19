<%-- 
    Document   : ExpenseProc
--%>
<%@page import="org.apache.http.impl.client.CloseableHttpClient"%>
<%@page import="org.apache.http.impl.client.HttpClients"%>
<%@page import="org.apache.http.impl.client.HttpClientBuilder"%>
<%@page import="org.apache.http.client.config.RequestConfig"%>
<%@page import="org.apache.http.client.config.CookieSpecs"%>
<%@page import="java.util.concurrent.Executors"%>
<%@page import="java.util.concurrent.ExecutorService"%>
<%@page import="java.util.concurrent.Future"%>
<%@page import="Entity.PaymentFactory"%>
<%@page import="Module.Expense.QBOCallable"%>
<%@include file="Protect.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Waiting Reset | Abundant Accounting Management System</title>
        </head>
        <body width="100%" style='background-color: #F0F8FF;'>
            <nav class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                <div class="navbar-header" style="width:100%">
                    <jsp:include page="Header-Plain.jsp"/>
                </div>
                <div class="container-fluid" width="100%" height="100%" style='padding-left: 0px; padding-right: 0px;'>
                    <jsp:include page="StatusMessage.jsp"/>
                    <div class="container-fluid" style="text-align: center; margin-top: <%=session.getAttribute("margin")%>" width="100%" height='100%'>
                        <h4>Expense is still processing please wait</h4>
                        <%
                            RequestConfig customizedRequestConfig = RequestConfig.custom().setCookieSpec(CookieSpecs.IGNORE_COOKIES).build();
                            HttpClientBuilder customizedClientBuilder
                                    = HttpClients.custom().setDefaultRequestConfig(customizedRequestConfig);
                            CloseableHttpClient client = customizedClientBuilder.build();
                            
                            
                            ExecutorService executorService = Executors.newSingleThreadExecutor();
                            QBOCallable qboCallable = (QBOCallable) request.getSession().getAttribute("qboCallable");
                            Future<PaymentFactory> qboFuture = executorService.submit(qboCallable);
                            PaymentFactory pf = qboFuture.get();
                            request.getSession().setAttribute("pfResult", pf);
                            response.sendRedirect("ExpenseResult.jsp");

                        %>
                    </div>
            </nav>
        </nav>
    </body>
    <jsp:include page="Footer.html"/>
</html>

