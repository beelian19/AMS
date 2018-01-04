package DAO;

import Entity.Token;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import Utility.ConnectionManager;

public class TokenDAO {

    private static String getTokenStatement = "SELECT * FROM tokens WHERE companyId = '%s'";

    public static Token getToken(int companyId) {
        String id = String.valueOf(companyId);
        return getToken(id);
    }

    public static Token getToken(String companyId) {
        Token token = null;
        String query = String.format(getTokenStatement, companyId);

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String accountType = rs.getString(1);
                String ClientId = rs.getString(2);
                String ClientSecret = rs.getString(3);
                String redirectUri = rs.getString(4);
                String refreshToken = rs.getString(5);
                String xToken = rs.getString(6);
                String xTokenSecret = rs.getString(7);
                String xTokenHandle = rs.getString(8);
                String inUse = rs.getString(9);
                int comId = rs.getInt(10);
                token = new Token(accountType, ClientId, ClientSecret, redirectUri, refreshToken, xToken, xTokenSecret, xTokenHandle, inUse, comId);
                return token;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return null;
    }

    public static ArrayList<Token> getAllToken() {
        ArrayList<Token> tokenList = new ArrayList<>();
        Token token = null;

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tokens");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String accountType = rs.getString(1);
                String ClientId = rs.getString(2);
                String ClientSecret = rs.getString(3);
                String redirectUri = rs.getString(4);
                String refreshToken = rs.getString(5);
                String xToken = rs.getString(6);
                String xTokenSecret = rs.getString(7);
                String xTokenHandle = rs.getString(8);
                String inUse = rs.getString(9);
                int comId = rs.getInt(10);
                token = new Token(accountType, ClientId, ClientSecret, redirectUri, refreshToken, xToken, xTokenSecret, xTokenHandle, inUse, comId);
                tokenList.add(token);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return tokenList;
    }

    public static boolean createToken(Token token) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO tokens VALUES (?,?,?,?,?,?,?,?,?,?)");
            stmt.setString(1, token.getAccType());
            stmt.setString(2, token.getClientId());
            stmt.setString(3, token.getClientSecret());
            stmt.setString(4, token.getRedirectUri());
            stmt.setString(5, token.getRefreshToken());
            stmt.setString(6, token.getXeroToken());
            stmt.setString(7, token.getXeroTokenSecret());
            stmt.setString(8, token.getXeroTokenHandle());
            stmt.setString(9, "0");
            stmt.setInt(10, token.getCompanyId());
            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }

    public static boolean updateToken(Token token) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE tokens SET ClientId = ?, ClientSecret = ?, redirectUri = ?, refreshToken = ?, inUse = ?, xeroToken = ?, xeroTokenSecret = ?, xeroTokenHandle = ?, accType = ? WHERE companyId=?");
            stmt.setString(1, token.getClientId());
            stmt.setString(2, token.getClientSecret());
            stmt.setString(3, token.getRedirectUri());
            stmt.setString(4, token.getRefreshToken());
            stmt.setString(5, token.getInUseString());
            stmt.setString(6, token.getXeroToken());
            stmt.setString(7, token.getXeroTokenSecret());
            stmt.setString(8, token.getXeroTokenHandle());
            stmt.setString(9, token.getAccType());
            stmt.setInt(10, token.getCompanyId());

            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }

    public boolean deleteToken(Token token) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("Delete from Tokens where companyId = ?");
            stmt.setInt(1, token.getCompanyId());
            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }
}
