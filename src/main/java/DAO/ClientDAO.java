/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Entity.Client;
import Entity.Project;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import Utility.ConnectionManager;

public class ClientDAO {

    private static String createNewClientStatement = "Insert into client values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static String updateClientStatement = "UPDATE client SET businessType=?, companyName=?, incorporation=?, officeContact=?, contactEmailAddress=?, officeAddress=?, financialYearEnd=?, gstSubmission=?, director=?, secretary=?, accountant=?, realmid=? mgmtAcc=? WHERE UENNumber=?";
    private static String deleteClientByIDStatement = "DELETE from client WHERE clientID=? ";
    private static String getAllClientsStatement = "SELECT * FROM CLIENT order by companyName asc";
    private static String getClientByIDStatement = "SELECT * FROM CLIENT where clientID = ?";
    private static String getClientByUENStatement = "SELECT * FROM CLIENT where UENNumber = ?";
    private static String getAllClientNameStatement = "SELECT companyName FROM CLIENT";
    private static String getAllClientProjectStatement = "SELECT * FROM project WHERE companyName='%s'";
    private static String getClientRealmidStatement = "SELECT realmid FROM client where companyName = ?";
    private static String getClientByCompanyNameStatement = "SELECT * FROM CLIENT WHERE companyName = ?";
    private static String checkClientExist = "SELECT EXISTS(SELECT * FROM client WHERE UENNumber = ?) ";

    public boolean addNewClient(String businessType, String companyName, String incorporation, String UenNumber, String officeContact, String emailAddress, String officeAddress, String financialYearEnd, String gst, String director, String secretary, String accountant, String mgmtAcc) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(createNewClientStatement);

            stmt.setString(1, Integer.toString(getCounter()));
            stmt.setString(2, businessType);
            stmt.setString(3, companyName);
            stmt.setString(4, incorporation);
            stmt.setString(5, UenNumber);
            stmt.setString(6, officeContact);
            stmt.setString(7, emailAddress);
            stmt.setString(8, officeAddress);
            stmt.setString(9, financialYearEnd);
            stmt.setString(10, gst);
            stmt.setString(11, director);
            stmt.setString(12, secretary);
            stmt.setString(13, accountant);
            stmt.setString(14, "NA");
            stmt.setString(15, mgmtAcc);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateClient(Client client) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateClientStatement);

            stmt.setString(1, client.getBusinessType());
            stmt.setString(2, client.getCompanyName());
            stmt.setString(3, client.getIncorporation());
            stmt.setString(4, client.getOfficeContact());
            stmt.setString(5, client.getContactEmailAddress());
            stmt.setString(6, client.getOfficeAddress());
            stmt.setString(7, client.getFinancialYearEnd());
            stmt.setString(8, client.getGstSubmission());
            stmt.setString(9, client.getDirector());
            stmt.setString(10, client.getSecretary());
            stmt.setString(11, client.getAccountant());
            stmt.setString(12, client.getRealmid());
            stmt.setString(13, client.getMgmtAcc());
            stmt.setString(14, client.getUENNumber());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteClient(String clientId) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(deleteClientByIDStatement);

            stmt.setString(1, clientId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCounter() throws SQLException {

        Connection conn = ConnectionManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement("Select max(clientID) from client");
        ResultSet rs = stmt.executeQuery();
        rs.last();
        int temp = rs.getInt("max(clientID)");
        //Integer tempCount = Integer.parseInt(temp);
        int counter = temp + 1;

        return counter;
    }

    public static ArrayList<Client> getAllClient() {
        ArrayList<Client> clientList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllClientsStatement);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Client client = new Client(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getString(12), rs.getString(13), rs.getString(14), rs.getString(15));
                clientList.add(client);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clientList;

    }

    public static Boolean clientExist(String UEN) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(checkClientExist);
            stmt.setString(1, UEN);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (SQLException e) {
        }
        return null;
    }

    public static Client getClientById(String id) {
        Client client = null;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getClientByIDStatement);
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                return new Client(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getString(12), rs.getString(13), rs.getString(14), rs.getString(15));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Client getClientByUEN(String UEN) {
        
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getClientByUENStatement);
            stmt.setString(1, UEN);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                return new Client(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getString(12), rs.getString(13), rs.getString(14), rs.getString(15));
            }

        } catch (SQLException e) {
        }
        return null;
    }

    public static String getClientRealmid(String name) {
        String realmid = null;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getClientRealmidStatement);
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                realmid = rs.getString(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return realmid;
    }

    public static ArrayList<String> getAllCompanyNames() {
        ArrayList<String> companyNameList = new ArrayList<>();
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllClientNameStatement);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String name = rs.getString(1);
                companyNameList.add(name);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return companyNameList;
    }

    public static ArrayList<ArrayList<Project>> getAllClientProjectFiltered(String name) {
        return ProjectDAO.getAllProjectsByCompanyName(name);
    }

    public boolean updateClientProfile(String UenNumber, String officeContact, String emailAddress, String director, String secretary, String accountant, String realmid, String officeAddress, String gstSubmission, String mgmtAcc) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE client SET officeContact=?, contactEmailAddress=?, director=?, secretary=?, accountant=?,realmid=?, officeAddress=?, gstSubmission=?,mgmtAcc=? WHERE UENNumber=?");

            stmt.setString(1, officeContact);
            stmt.setString(2, emailAddress);
            stmt.setString(3, director);
            stmt.setString(4, secretary);
            stmt.setString(5, accountant);
            stmt.setString(6, realmid);
            stmt.setString(7, officeAddress);
            stmt.setString(8, gstSubmission);
            stmt.setString(9, mgmtAcc);
            stmt.setString(10, UenNumber);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static Client getClientByCompanyName(String companyName) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getClientByCompanyNameStatement);
            stmt.setString(1, companyName);
            ResultSet rs = stmt.executeQuery();
            Client client = null;
            while (rs.next()) {
                int clientId = rs.getInt(1);
                String businessType = rs.getString(2);

                String incorporation = rs.getString(4);
                String UenNumber = rs.getString(5);
                String officeContact = rs.getString(6);
                String emailAddress = rs.getString(7);
                String officeAddress = rs.getString(8);
                String financialYearEnd = rs.getString(9);
                String gst = rs.getString(10);
                String director = rs.getString(11);
                String secretary = rs.getString(12);
                String accountant = rs.getString(13);
                String realmid = rs.getString(14);
                String mgmtAcc = rs.getString(15);
                client = new Client(clientId, businessType, companyName, incorporation, UenNumber, officeContact, emailAddress, officeAddress, financialYearEnd, gst, director, secretary, accountant, realmid, mgmtAcc);
            }

            return client;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

}
