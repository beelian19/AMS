/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import Utility.ConnectionManager;

/**
 *
 * @author jagdishps.2014
 */
public class DashboardDAO {
 
    public static int countTotalProject() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from project");
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    }
    
    public static int countTotalOngoingProject() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select COUNT(*) FROM project WHERE projectStatus = ? or projectReviewStatus=?");
            stmt.setString(1,"incomplete");
            stmt.setString(2,"incomplete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("COUNT(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    }
    
     public static int countTotalOverdueProject() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from project where (projectStatus=? or projectReviewStatus=?) and end < CURRENT_DATE()");
            stmt.setString(1,"incomplete");
            stmt.setString(2,"incomplete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    }
     
     public static int countTotalCompleteProject() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from project where projectStatus =? and projectReviewStatus =?");
            stmt.setString(1,"complete");
            stmt.setString(2,"complete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    } 
     
    public static int countTotalTask() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from task");
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    } 
    
     public static int countTotalOngoingTask() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select COUNT(*) FROM task WHERE taskStatus = ? or reviewStatus=?");
            stmt.setString(1,"incomplete");
            stmt.setString(2,"incomplete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("COUNT(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    }
    
      public static int countTotalOverdueTask() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from task where (taskStatus=? or reviewStatus=?) and end < CURRENT_DATE()");
            stmt.setString(1,"incomplete");
            stmt.setString(2,"incomplete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    }
    
      public static int countTotalCompleteTask() {
        int numProject = 0; 
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("select count(*) from task where taskStatus =? and reviewStatus =?");
            stmt.setString(1,"complete");
            stmt.setString(2,"complete");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                numProject = rs.getInt("count(*)");

               
            }
            return numProject; 
            
        } catch (SQLException e) {
            System.out.println("SQLException at DashboardDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at DashboardDAO: " + e.getMessage());
        }
        return numProject;

    } 
}
