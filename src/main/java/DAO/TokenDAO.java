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
    
    public static Token getToken(String companyId){
        Token token = null;
        String query = String.format(getTokenStatement, companyId);
        
        try(Connection conn = ConnectionManager.getConnection()){
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                String accountType = rs.getString(1);
                String ClientId = rs.getString(2);
                String ClientSecret = rs.getString(3);
                String redirectUri = rs.getString(4);
                String refreshToken = rs.getString(5);
                String inUse = rs.getString(6);
                int comId = rs.getInt(7);
                token = new Token(accountType, ClientId, ClientSecret, redirectUri, refreshToken, inUse, comId);
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
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROOM tokens");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String accountType = rs.getString(1);
                String ClientId = rs.getString(2);
                String ClientSecret = rs.getString(3);
                String redirectUri = rs.getString(4);
                String refreshToken = rs.getString(5);
                String inUse = rs.getString(6);
                int companyId = rs.getInt(7);
                token = new Token(accountType, ClientId, ClientSecret, redirectUri, refreshToken, inUse, companyId);
                tokenList.add(token);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return tokenList;
    }
    
    public static boolean createToken(Token token){
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO tokens VALUES (?,?,?,?,?,?,?)");
            stmt.setString(1, token.getAccType());
            stmt.setString(2, token.getClientId());
            stmt.setString(3, token.getClientSecret());
            stmt.setString(4, token.getRedirectUri());
            stmt.setString(5, token.getRefreshToken());
            stmt.setString(6, "0");
            stmt.setInt(7, token.getCompanyId());
            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }
    
    public static boolean updateToken(Token token){
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE tokens SET ClientId = ?, ClientSecret = ?, redirectUri = ?, refreshToken = ?, inUse = ?, accType = ? WHERE companyId=?");
            stmt.setString(1, token.getClientId());
            stmt.setString(2, token.getClientSecret());
            stmt.setString(3, token.getRedirectUri());
            stmt.setString(4, token.getRefreshToken());
            stmt.setString(5, token.getInUseString());
            stmt.setInt(7, token.getCompanyId());
            stmt.setString(6, token.getAccType());
            
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
