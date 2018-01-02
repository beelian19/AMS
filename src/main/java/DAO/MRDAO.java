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

    public static MonthlyRemarks getMonthlyRemarks(int yearMonth) {
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

    public static Boolean updateEmployeeMonthlyRemarks(int yearMonth, String employeeName, String employeeRemarks) {
        MonthlyRemarks mr = getMonthlyRemarks(yearMonth);
        Map<String, String> remarksMap = mr.getRemarksMap();
        remarksMap.put(employeeName, employeeRemarks);
        mr.setRemarks(remarksMap.toString().substring(1,  remarksMap.toString().length() - 1));
        
        return false;
    }
}
