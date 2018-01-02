/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import DAO.ProjectDAO;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Lin
 */
public class Dashboard {

    private HashMap<String, Entity.Project> allProjectsMap;
    private HashMap<Integer, List<Project>> yearMonthMap;
    private HashMap<String, List<Project>> employeeNameMap;
    private HashMap<Integer, Map<String, String>> yearMonthEmployeeRemarks;
    private String initErrorMessage;
    private boolean initSuccess;

    public Dashboard() {

        allProjectsMap = new HashMap<>();
        yearMonthMap = new HashMap<>();
        employeeNameMap = new HashMap<>();
        yearMonthEmployeeRemarks = new HashMap<>();

        try {
            // Init all projects into a hashmap
            ProjectDAO.getAllProjects().stream().forEach((p) -> {
                allProjectsMap.put(p.getProjectIDString(), p);
            });

            // Init hashmap with yearMonth as the key and a list of projects that contain that yearMonth
            allProjectsMap.entrySet().stream().map((entry) -> entry.getValue()).forEach((p) -> {
                List<Integer> yearMonths = p.getYearMonths();
                yearMonths.stream().forEach((yearMonth) -> {
                    List<Project> value = yearMonthMap.get(yearMonth);
                    if (value != null) {
                        value.add(p);
                    } else {
                        value = Arrays.asList(p);
                    }
                    yearMonthMap.put(yearMonth, value);
                });
            });

            // Init hashmap with employeeName as key with all the projects that belongs to this employee
            allProjectsMap.entrySet().stream().map((entry) -> entry.getValue()).forEach((p) -> {
                String emp1 = p.getEmployee1();
                String emp2 = p.getEmployee2();
                List<Project> emp1projs = employeeNameMap.get(emp1);
                List<Project> emp2projs = employeeNameMap.get(emp2);
                if (emp1projs != null) {
                    emp1projs.add(p);
                } else {
                    emp1projs = Arrays.asList(p);
                }
                employeeNameMap.put(emp1, emp1projs);
                if (emp2projs != null) {
                    emp2projs.add(p);
                } else {
                    emp2projs = Arrays.asList(p);
                }
                // Ensure not to impute a "NA" employee
                if (!emp2.toLowerCase().trim().equals("na")) {
                    employeeNameMap.put(emp2, emp2projs);
                }
            });

            
            
            initSuccess = true;
        } catch (Exception e) {
            initSuccess = false;
            initErrorMessage = e.getMessage();
        }
    }

    public HashMap<String, Project> getAllProjectsMap() {
        return allProjectsMap;
    }

    public void setAllProjectsMap(HashMap<String, Project> allProjectsMap) {
        this.allProjectsMap = allProjectsMap;
    }

    public HashMap<Integer, List<Project>> getYearMonthMap() {
        return yearMonthMap;
    }

    public void setYearMonthMap(HashMap<Integer, List<Project>> yearMonthMap) {
        this.yearMonthMap = yearMonthMap;
    }

    public HashMap<String, List<Project>> getEmployeeNameMap() {
        return employeeNameMap;
    }

    public void setEmployeeNameMap(HashMap<String, List<Project>> employeeNameMap) {
        this.employeeNameMap = employeeNameMap;
    }

    public boolean isInitSuccess() {
        return initSuccess;
    }

    public void setInitSuccess(boolean initSuccess) {
        this.initSuccess = initSuccess;
    }

    public String getInitErrorMessage() {
        return initErrorMessage;
    }

    public void setInitErrorMessage(String initErrorMessage) {
        this.initErrorMessage = initErrorMessage;
    }

    public HashMap<Integer, Map<String, String>> getYearMonthEmployeeRemarks() {
        return yearMonthEmployeeRemarks;
    }

    public void setYearMonthEmployeeRemarks(HashMap<Integer, Map<String, String>> yearMonthEmployeeRemarks) {
        this.yearMonthEmployeeRemarks = yearMonthEmployeeRemarks;
    }

}
