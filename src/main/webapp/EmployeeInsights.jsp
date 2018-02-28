<%-- 
    Document   : EmployeeInsights
    Created on : Feb 26, 2018, 8:30:29 PM
    Author     : yemin
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="DAO.ProjectDAO"%>
<%@page import="Entity.Project"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="Protect.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Employee Insights Page | Abundant Accounting Management System</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
        <style>
            /* Modal Content/Box */
            .modal-content {
                background-color: #fefefe;
                margin: 15% auto; /* 15% from the top and centered */
                padding: 20px;
                border: 1px solid #888;
                width: 50%; /* Could be more or less, depending on screen size */
            }

            /* The Close Button */
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }

            .close:hover,
            .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }
        </style>
        <script>
            $(document).ready(function () {
                $('#datatable4').DataTable();
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
                    <%
                        ArrayList<Project> employeeProjectList = new ArrayList();
                        employeeProjectList = (ArrayList<Project>) request.getSession().getAttribute("staffProjectList");
                        String profileUrl = "ProjectProfile.jsp?projectID=";
                        String profileUrl2 = "";

                        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                        DecimalFormat df = new DecimalFormat("#.00");
                        //System.out.println("Insights: " + projectList.size());
                    %>
                    <div class="container-fluid" style="text-align: center; width:80%; height:80%;">
                        <h3><b><%=request.getSession().getAttribute("empNameSelected")%>'s productivity for the year <%=request.getSession().getAttribute("yearEmployee")%></b></h3>
                        <table id='datatable4' align="center" style="text-align: left;">
                            <thead>
                                <tr>
                                    <th width="16.66%">Company Name</th>
                                    <th width="16.66%">Project Name</th>
                                    <th width="16.66%">Hours Assigned</th>
                                    <th width="16.66%">Hours Actual</th>
                                    <th width="16.66%">Difference</th>
                                    <th width="16.66%">Cost</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    //ArrayList<Project> employeeProjectList = new ArrayList();
                                    if (employeeProjectList != null && !employeeProjectList.isEmpty()) {
                                        for (int i = 0; i < employeeProjectList.size(); i++) {
                                            Project p = employeeProjectList.get(i);
                                %>
                                <tr>
                                    <td>
                                        <%=p.getCompanyName()%>
                                    </td>
                                    <td>
                                        <% profileUrl2 = profileUrl + p.getProjectID();%>
                                        <a href=<%=profileUrl2%>>
                                            <%= p.getProjectTitle().trim().equals("") ? "*No Title" : p.getProjectTitle()%>
                                        </a>
                                    </td>
                                    <td>
                                        <%=p.getPlannedHours()%>
                                    </td>
                                    <td>
                                        <%=p.getEmployee1Hours() + p.getEmployee2Hours()%>
                                    </td>
                                    <td>
                                        <%=p.getPlannedHours() - p.getEmployee1Hours() - p.getEmployee2Hours()%>
                                    </td>
                                    <td>
                                        <%=ProjectDAO.getTotalActualCost(p)%>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                        <br/>
                    </div>
                    <div class="row">
                        <div class="col-xs-9">
                        </div>
                        <div class="col-xs-3">
                            <div class="col-xs-3"></div>
                            <div>
                                <table>
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 61%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 16.167%">
                                            &nbsp;
                                        </td>
                                        <td style="width: 1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <button id='btnEmployeeCSV' class="btn btn-lg btn-primary btn-block" type="button">Download as CSV</button>
                                        </td>
                                        <td style="width: 11.167%">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/><br/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- The Modal -->
                <div id="myModal" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <span class="close">&times;</span>
                            <h4 class="modal-title">
                                Message from AMS
                            </h4>
                        </div>
                        <div class="modal-body" align='left'>
                            xls file is sent to abundantms2017@gmail.com
                        </div>
                    </div>
                </div>
        </nav>
        <script>
            $('#btnEmployeeCSV').click(function () {
                downloadAbundantCSV();
            });
            // Get the modal
            var modal = document.getElementById('myModal');

            // Get the button that opens the modal
            var btn = document.getElementById("myBtn");

            // Get the <span> element that closes the modal
            var span = document.getElementsByClassName("close")[0];

            // When the user clicks on the button, open the modal 
            function openModal() {
                modal.style.display = "block";
            }
            ;

            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            };

            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            };
            function downloadAbundantCSV() {
                $.ajax({
                    url: 'EmployeeWriteToCSV',
                    type: 'GET',
                    success: function () {
                        openModal();
                    }
                });
            }
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>
