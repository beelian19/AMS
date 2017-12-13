/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Entity.Task;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import Utility.ConnectionManager;

/**
 *
 * @author jagdishps.2014
 */
public class TaskDAO {

    private static String insertNewTaskStatement = "INSERT INTO TASK VALUES (?,?,?,?,?,?,?,?,?,?)";
    private static String updateTaskStatement = "Update TASK set title=?, start= ?, end=?,taskRemarks=?,taskStatus=?, reviewer =?,reviewStatus=? WHERE uniqueTaskID=?";
    private static String updateRemarksStatement = "UPDATE TASK SET taskRemarks=? WHERE uniqueTaskID=?";

    public static void addTask(int projectID, int taskID, String taskTitle, Date start, Date end, String taskRemarks, String reviewer) {
        java.sql.Date sqlDate1;
        java.sql.Date sqlDate2;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(insertNewTaskStatement);
            stmt.setInt(1, projectID);
            stmt.setInt(2, taskID);
            stmt.setString(3, taskTitle);
            sqlDate1 = new java.sql.Date(start.getTime());
            stmt.setDate(4, sqlDate1);
            sqlDate2 = new java.sql.Date(end.getTime());
            stmt.setDate(5, sqlDate2);
            stmt.setString(6, taskRemarks);
            stmt.setString(7, "incomplete");
            stmt.setInt(8, getUniqueTaskID());
            stmt.setString(9, reviewer);
            stmt.setString(10, "incomplete");

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static ArrayList<Task> getAllIncompleteTasks(){
        ArrayList<Task> returnList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "SELECT * FROM task WHERE taskStatus = 'incomplete' OR reviewStatus = 'incomplete'";
            PreparedStatement stmt = conn.prepareStatement(statement);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Task task = new Task(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getDate(4), rs.getDate(5), rs.getString(6), rs.getString(7), rs.getInt(8), rs.getString(9), rs.getString(10));
                returnList.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return returnList;
        
    
    }

    public boolean deleteTask(int projectID, int taskID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM task WHERE projectID= ? AND taskID = ?");
            // need to check how we're going to assign the jobid
            //System.out.println("TEST===="+projectID+"====="+taskID);
            stmt.setInt(1, projectID);
            stmt.setInt(2, taskID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static ArrayList<Task> viewAllTask() {
        ArrayList<Task> taskList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "SELECT * FROM task ORDER BY end asc";
            PreparedStatement stmt = conn.prepareStatement(statement);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Task task = new Task(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getDate(4), rs.getDate(5), rs.getString(6), rs.getString(7), rs.getInt(8), rs.getString(9), rs.getString(10));
                taskList.add(task);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return taskList;
    }

    public boolean updateTask(Task task){
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateTaskStatement);
            stmt.setString(1, task.getTaskTitle());
            sqlDate = new java.sql.Date(task.getStart().getTime());
            stmt.setDate(2, sqlDate);
            sqlDate = new java.sql.Date(task.getEnd().getTime());
            stmt.setDate(3, sqlDate);
            stmt.setString(4, task.getTaskRemarks());
            stmt.setString(5,task.getTaskStatus());
            stmt.setString(6, task.getReviewer());
            stmt.setString(7,task.getReviewStatus());
            stmt.setInt(8, task.getUniqueTaskID());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTaskStatus(int projectID, int taskID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "UPDATE task SET taskStatus=? WHERE projectID=? AND taskID=?";
            PreparedStatement stmt = conn.prepareStatement(statement);

            stmt.setString(1, "complete");
            stmt.setInt(2, projectID);
            stmt.setInt(3, taskID);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateReviewStatus(int projectID, int taskID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "UPDATE task SET reviewStatus=? WHERE projectID=? AND taskID=?";
            PreparedStatement stmt = conn.prepareStatement(statement);

            stmt.setString(1, "complete");
            stmt.setInt(2, projectID);
            stmt.setInt(3, taskID);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<Task> viewReviewerTasks(String name) {
        ArrayList<Task> taskList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "SELECT * FROM task WHERE reviewer=? ORDER BY taskEnd asc";
            PreparedStatement stmt = conn.prepareStatement(statement);
            stmt.setString(1, name);
            

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Task task = new Task(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getDate(4), rs.getDate(5), rs.getString(6), rs.getString(7), rs.getInt(8), rs.getString(9), rs.getString(10));
                taskList.add(task);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return taskList;
    }
    
    public static int getUniqueTaskID() throws SQLException {
        Connection conn = ConnectionManager.getConnection();
        PreparedStatement stmt = conn.prepareStatement("Select max(uniqueTaskID) from task");

        ResultSet rs = stmt.executeQuery();
        rs.last();
        int temp = rs.getInt("max(uniqueTaskID)");
        //Integer tempCount = Integer.parseInt(temp);
        int counter = temp + 1;

        return counter;
    }

    public Task getTaskByID(String uniqueTaskID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "SELECT * FROM task WHERE uniqueTaskID=?";
            PreparedStatement stmt = conn.prepareStatement(statement);
            stmt.setInt(1, Integer.parseInt(uniqueTaskID));

            ResultSet rs = stmt.executeQuery();

            if (!rs.next()) {
                return null;
            }

            int projectID = rs.getInt(1);
            int taskID = rs.getInt(2);
            String title = rs.getString(3);
            Date start = rs.getDate(4);
            Date end = rs.getDate(5);
            String remarks = rs.getString(6);
            String taskStatus = rs.getString(7);
            int uniqueID = rs.getInt(8);
            String reviewer = rs.getString(9);
            String reviewStatus = rs.getString(10);

            return new Task(projectID, taskID, title, start, end, remarks, taskStatus, uniqueID, reviewer, reviewStatus);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRemarks(String remarks, String uniqueTaskID) {

        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = updateRemarksStatement;
            PreparedStatement stmt = conn.prepareStatement(statement);

            stmt.setString(1, remarks);
            stmt.setInt(2, Integer.parseInt(uniqueTaskID));
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
