<%-- 
    Document   : TokenOverview
    Created on : Jan 13, 2018, 6:54:30 PM
    Author     : Bernitatowyg
--%>

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
        <%             ArrayList<String> clientNameList = new ArrayList<>();
            ArrayList<Integer> clientIdList = new ArrayList<>();

            clientNameList = ClientDAO.getAllCompanyNames();
            for (int i = 0; i < clientNameList.size(); i++) {
                clientIdList.add(i, (ClientDAO.getClientByCompanyName(clientNameList.get(i))).getClientID());
            }
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
                    <h1>All Tokens <i class="material-icons" id="addNewToken">add_box</i></h1>
                    <form action="ResetToken" method="post">
                        <div class="container-fluid" width="100%" height="100%" style="text-align: left;">
                            <table id="datatable" style="border: #FFFFFF" width="100%" height="100%">
                                <thead>
                                    <tr>
                                        <th>Client ID</th>
                                        <th>Company Name</th>
                                        <th></th>
                                    </tr> 
                                </thead>
                                <tbody>
                                    <%
                                        if (clientIdList != null && !clientIdList.isEmpty()) {
                                            for (int i = 0; i < clientIdList.size(); i++) {
                                    %>
                                    <tr>
                                        <td>
                                            <%=clientIdList.get(i)%>
                                        </td>
                                        <td>
                                            <%=ClientDAO.getClientById(clientIdList.get(i).toString()).getCompanyName()%>
                                        </td>
                                        <td>
                                            <input type="radio" name="clientId" value='<%=clientIdList.get(i)%>' required>
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
        <script>
            $('#addNewToken').click(function () {
                $('#addNewTokenModal').modal();
            });
        </script>
        <!-- Start of Modal -->
        <div id="addNewTokenModal" class="modal fade" role="dialog">
            <!-- Modal content -->
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                            <span id="eventTitle">Add New Token</span>
                        </h4>
                    </div>
                    <div class="modal-body" align="left">
                        <form>
                            <table>
                                <fieldset>
                                    <tr>
                                        <td>
                                            <label for="clientId">Client ID&nbsp;<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="text" name="clientId" id="clientId" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label for="clientSecret">Client Secret&nbsp;<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="text" name="clientSecret" id="clientSecret" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label for="redirectURI">Redirect URI&nbsp;<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="text" name="redirectURI" id="redirectURI" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label for="companyId">Company ID&nbsp;<font color="red">*</font></label>
                                        </td>
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input type="text" name="companyId" id="companyId" class="text ui-widget-content ui-corner-all" required>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <br/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="1%" colspan="2">
                                            &nbsp;
                                        </td>
                                        <td style="text-align: right">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <button type="button" id="btnCreate" class="btn btn-success">Create</button>
                                        </td>
                                    </tr>
                                </fieldset>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $('#btnCreate').click(function () {
                if ($('#clientId').val().trim() == "") {
                    alert("Client ID Required");
                    return;
                }
                if ($('#clientSecret').val().trim() == "") {
                    alert("Client Secret Required");
                    return;
                }
                if ($('#redirectURI').val().trim() == "") {
                    alert("Redirect URI Required");
                    return;
                }
                if ($('#companyId').val().trim() == "") {
                    alert("Company ID Required");
                    return;
                } else {
                    var clientId = $('#clientId').val();
                    var clientSecret = $('#clientSecret').val();
                    var redirectURI = $('#redirectURI').val();
                    var companyId = $('#companyId').val();

                    $.ajax({
                        type: 'POST',
                        data: 'clientId=' + clientId + '&' + 'clientSecret=' + clientSecret + '&' + 'redirectURI=' + redirectURI + '&' + 'companyId=' + companyId,
                        url: 'CreateToken',
                        success: function () {
                            location.reload();
                            alert('New Token Added');
                            $('#addNewToken').modal('hide');
                        },
                        error: function () {
                            alert('Error: Please try again!');
                        }
                    })
                }
                $('#addNewToken').modal('hide');
            });
        </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>
