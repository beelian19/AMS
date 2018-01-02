/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Entity.MonthlyRemarks;
import Utility.ConnectionManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Lin
 */
public class MRDAO {

    /**
     * Returns a hashmap of a hashmap The first map's key is the yearMonth, with
     * a Map of all employees and their remarks
     *
     * @return
     */
    public static HashMap<Integer, Map<String, String>> getAllMonthlyRemarksMap() {

        HashMap<Integer, Map<String, String>> yearMonthEmployeeRemarksMap = new HashMap<>();
        ArrayList<MonthlyRemarks> all = new ArrayList<>();
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM monthlyremarks");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                all.add(new MonthlyRemarks(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return null;
        }

        if (all.isEmpty()) {
            return null;
        }

        all.stream().forEach((mr) -> {
            yearMonthEmployeeRemarksMap.put(mr.getYearMonth(), mr.getRemarksMap());
        });

        return yearMonthEmployeeRemarksMap;
    }

    private static MonthlyRemarks getMonthlyRemarks(int yearMonth) {
        MonthlyRemarks monthlyremarks;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM monthlyremarks WHERE yearMonth = '%s'");
            stmt.setString(1, String.valueOf(yearMonth));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                monthlyremarks = new MonthlyRemarks(rs.getInt(1), rs.getString(2));
                return monthlyremarks;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return null;
    }

    private static String replaceValues(String remarks) {
        if (remarks == null) {
            return null;
        }
        remarks = remarks.replaceAll(",", ".");
        return remarks.replaceAll("=", ".");
    }

    private static Boolean updateMonthlyRemarks(MonthlyRemarks mr) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE monthlyremarks SET remarks = ? WHERE yearMonth = ?");
            stmt.setString(1, mr.getRemarks());
            stmt.setInt(2, mr.getYearMonth());
            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }

    private static Boolean createMonthlyRemarks(MonthlyRemarks mr) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO monthlyremarks VALUES (?,?)");
            stmt.setString(1, mr.getRemarks());
            stmt.setInt(2, mr.getYearMonth());
            return stmt.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return false;
    }

    private static Boolean createMR(Integer yearMonth, String employeeName, String employeeRemarks) {
        String remarks = replaceValues(employeeRemarks);
        MonthlyRemarks mr = new MonthlyRemarks(yearMonth, employeeName + "=" + remarks);
        return createMonthlyRemarks(mr);
    }

    /**
     * Method to update the employee remark
     *
     * @param yearMonth
     * @param employeeName
     * @param employeeRemarks
     * @return
     */
    public static Boolean updateEmployeeMonthlyRemarks(int yearMonth, String employeeName, String employeeRemarks) {
        MonthlyRemarks mr = getMonthlyRemarks(yearMonth);
        // If there are no existing remarks for this year month
        if (mr == null) {
            return createMR(yearMonth, employeeName, employeeRemarks);

            // Else update existing Monthly Remark
        } else {
            Map<String, String> remarksMap = mr.getRemarksMap();
            remarksMap.put(employeeName, replaceValues(employeeRemarks));
            mr.setRemarks(remarksMap.toString().substring(1, remarksMap.toString().length() - 1));
        }
        return updateMonthlyRemarks(mr);
    }
}
