package Entity;

import DAO.MRDAO;
import DAO.ProjectDAO;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Dashboard {

    // Key is the project's id and value is the Project with the respective ID
    private HashMap<String, Project> allProjectsMap;

    // Key if the yearMonth and value is the list of projects that have one of the months in the yearMonth
    private HashMap<Integer, List<Project>> yearMonthMap;

    // Key is the employee's name as listed in a project. Value is a list of the projects that the employee was part of
    private HashMap<String, List<Project>> employeeNameMap;

    // Key is the yearMonth and value is all the remarks by employees that have given a remark for that specific yearMonth. 
    private HashMap<Integer, Map<String, String>> yearMonthEmployeeRemarks;

    // Error message for any failed initializaion. Ignore if not errors
    private String initErrorMessage;

    // boolean to check if the initilization is correct
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

            yearMonthEmployeeRemarks = MRDAO.getAllMonthlyRemarksMap();

            initSuccess = true;
        } catch (Exception e) {
            initSuccess = false;
            initErrorMessage = e.getMessage();
        }
    }

    public List<Project> filterByCompanyName(String companyName) {
        List<Project> returnList = new ArrayList<>();
        allProjectsMap.entrySet().stream().map((entry) -> entry.getValue()).forEach((Project p) -> {
            if (p.getCompanyName().toLowerCase().equals(companyName.toLowerCase())) {
                returnList.add(p);
            }
        });
        return returnList;
    }
    

    public List<Project> filterByYearMonthAndEmployeeName(Integer yearMonth, String employeeName) {
        List<Project> returnList = new ArrayList<>();
        List<String> yearMonthProjects = new ArrayList<>();
        List<String> employeeProjects = new ArrayList<>();

        if (yearMonthMap.get(yearMonth) == null) {
            return returnList;
        }

        yearMonthMap.get(yearMonth).stream().forEach((p) -> {
            yearMonthProjects.add(p.getProjectIDString());
        });

        if (employeeNameMap.get(employeeName) == null) {
            return returnList;
        }

        employeeNameMap.get(employeeName).stream().forEach((p) -> {
            employeeProjects.add(p.getProjectIDString());
        });

        // Get all common projects
        yearMonthProjects.retainAll(employeeProjects);

        yearMonthProjects.stream().forEach((s) -> {
            returnList.add(allProjectsMap.get(s));
        });

        return returnList;
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
