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
                    <h1>All Tokens</h1>
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
                                    if (clientIdList!=null && !clientIdList.isEmpty()){
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
                                        <button class="btn btn-lg btn-primary btn-block" id="edit" type="submit">Edit</button>
                                    </td>
                                    <td style="width: 1%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 16.167%">
                                        <button class="btn btn-lg btn-primary btn-block btn-success" type="submit">Refresh Token</button>
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
        </nav>
        <br/>
        <script>
        $('#edit').click(function () {
            $('#editTokenModal').modal();
        });
    </script>
    <!-- Start of Modal -->
    <div id="editTokenModal" class="modal fade" role="dialog">
        <!-- Modal content -->
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">
                        <span id="eventTitle">Edit Details</span>
                    </h4>
                </div>
                <div class="modal-body" align="left">
                    <form>
                        <table>
                            <fieldset>
                                <tr>
                                    <td>  
                                        <label>Client ID&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <!--<input type="text" name="clientId" id="clientId" value="" class="text ui-widget-content ui-corner-all" required>-->
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Client Secret&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <!--<input type="text" name="emailEdit" id="emailEdit" value="" class="text ui-widget-content ui-corner-all" required>-->
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Redirect URI&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <!--<input type="text" name="directorEdit" id="directorEdit" value="" class="text ui-widget-content ui-corner-all" required>-->
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="reviewer">Company ID&nbsp;<font color="red">*</font></label>
                                    </td>
                                    <td width="1%">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <!--<input type="text" name="secretaryEdit" id="secretaryEdit" value="" class="text ui-widget-content ui-corner-all" readonly>-->
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
                                        <button type="button" id="btnSave" class="btn btn-success">Save</button>
                                    </td>
                                </tr>
                            </fieldset>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- End of Modal-->
    <script>
        $('#btnSave').click(function () {
            if ($('#officeContactEdit').val().trim() == "") {
                alert("Office Contact Number Required");
                return;
            }
            if ($('#emailEdit').val().trim() == "") {
                alert("Email Required");
                return;
            }
            if ($('#directorEdit').val().trim() == "") {
                alert("Director Information Required");
                return;
            }
            if ($('#secretaryEdit').val().trim() == "") {
                alert("Secretary Information Required");
                return;
            }
            if ($('#accountantEdit').val().trim() == "") {
                alert("Accountant Information Required");
                return;
            }
            if ($('#realmidEdit').val().trim() == "") {
                alert("Real MID Required");
                return;
            }
            if ($('#addressEdit').val().trim() == "") {
                alert("Address Required");
                return;
            }
            if ($('#gstSubmissionEdit').val().trim() == "") {
                alert("GST Submission Required");
                return;
            }
            if ($('#mgmtAccEdit').val().trim() == "") {
                alert("Management Acct Required");
                return;
            } else {
                var number = $('#officeContactEdit').val();
                var email = $('#emailEdit').val();
                var director = $('#directorEdit').val();
                var secretary = $('#secretaryEdit').val();
                var accountant = $('#accountantEdit').val();
                var uen = $('#uen').val();
                var realmid = $('#realmidEdit').val();

                var officeAddress = $('#addressEdit').val();
                var gstSubmission = $('#gstSubmissionEdit').val();
                var mgmtAcc = $('#mgmtAccEdit').val();


                $.ajax({
                    type: 'POST',
                    data: 'officeContact=' + number + '&' + 'contactEmailAddress=' + email + '&' + 'director=' + director + '&' + 'secretary=' + secretary + '&' + 'accountant=' + accountant + '&' + 'uen=' + uen + '&' + 'realmid=' + realmid + '&' + 'officeAddress=' + officeAddress + '&' + 'gstSubmission=' + gstSubmission + '&' + 'mgmtAcc=' + mgmtAcc,
                    url: 'UpdateClientServlet',
                    success: function () {
                        location.reload();
                        alert('Details Updated');
                        $('#editProfileModal').modal('hide');
                    },
                    error: function () {
                        alert('Fail to Edit Details');
                    }
                })
            }
            $('#editProfileModal').modal('hide');
        });
    </script>
    </body>
    <jsp:include page="Footer.html"/>
</html>
