/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import Entity.Employee;
import Entity.Project;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import Utility.ConnectionManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 *
 * @author Bernitatowyg
 */
public class EmployeeDAO {

    private static String getEmployeeStatement = "SELECT * FROM EMPLOYEE WHERE employeeID = ? ";
    private static String getEmployeeStatementwithPassword = "SELECT * FROM EMPLOYEE WHERE employeeID = ? AND password = ? ";
    private static String getAllEmployeeStatement = "SELECT * FROM EMPLOYEE order by name";
    private static String getEmployeeFromNameStatement = "SELECT * FROM EMPLOYEE WHERE name = ?";
    private static String deleteEmployeeByNRICStatement = "DELETE FROM EMPLOYEE WHERE NRIC = ?";
    private static String insertEmployeeStatement = "INSERT INTO EMPLOYEE values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static String resetPasswordStatement = "UPDATE EMPLOYEE SET password = ? WHERE email = ?";
    private static String getEmployeeByEmailStatement = "SELECT * FROM EMPLOYEE WHERE email = ?";
    private static String deleteEmployeeByEmployeeIdStatement = "DELETE FROM EMPLOYEE WHERE employeeID = ?";
    private static String deleteEmployeeByEmployeeNameStatement = "DELETE FROM EMPLOYEE WHERE name = ?";
    private static String updateEmployeeStatement = "UPDATE EMPLOYEE SET password=?, email=?, isAdmin=?, monthlyOverhead=?, position=?, supervisor=?, bankAccount=?, name=?, number=?, dateJoined=?, dob=?, nationality=? WHERE NRIC=?";
    private static String getEmployeeNameStatement = "SELECT name FROM EMPLOYEE WHERE supervisor = ? AND position <> 'Ex-Employee'";
    private static String getAllSupervisorStatement = "SELECT name FROM EMPLOYEE WHERE supervisor = ? AND position <> 'Ex-Employee'";

    public static Employee getEmployee(String name) {

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getEmployeeFromNameStatement);
            stmt.setString(1, name);

            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return null;
            }

            // else returns result
            String employeeID = rs.getString(1);
            String password = rs.getString(2);
            String email = rs.getString(3);
            String isAdmin = rs.getString(4);
            String monthlyOverhead = rs.getString(5);
            String position = rs.getString(6);
            String isSupervisor = rs.getString(7);
            String bankAccount = rs.getString(8);
            String nric = rs.getString(9);
            String empName = rs.getString(10);
            String phoneNum = rs.getString(11);
            Date dateJoined = rs.getDate(12);
            Date dob = rs.getDate(13);
            String nationality = rs.getString(14);

            return new Employee(employeeID, password, email, isAdmin, monthlyOverhead, position, isSupervisor, bankAccount, nric, empName, phoneNum, dateJoined, dob, nationality);
        } catch (SQLException e) {
            e.printStackTrace();

            return null;
        }
    }

    public static Employee getEmployeeByID(String userId) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getEmployeeStatement);
            stmt.setString(1, userId);

            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return null;
            }

            // else returns result
            String employeeID = rs.getString(1);
            String password = rs.getString(2);
            String email = rs.getString(3);
            String isAdmin = rs.getString(4);
            String monthlyOverhead = rs.getString(5);
            String position = rs.getString(6);
            String isSupervisor = rs.getString(7);
            String bankAccount = rs.getString(8);
            String nric = rs.getString(9);
            String empName = rs.getString(10);
            String phoneNum = rs.getString(11);
            Date dateJoined = rs.getDate(12);
            Date dob = rs.getDate(13);
            String nationality = rs.getString(14);

            return new Employee(employeeID, password, email, isAdmin, monthlyOverhead, position, isSupervisor, bankAccount, nric, empName, phoneNum, dateJoined, dob, nationality);
        } catch (SQLException e) {
            e.printStackTrace();
            //Returns empty staff, so that add new job can determine that the staff does note exist and it's a database error
            //a database error!
            //Will be checked by .getUserId method!
            return null;
        }
    }

    public static Employee getEmployeebyIDandPassword(String userId, String enteredPassword) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getEmployeeStatementwithPassword);
            stmt.setString(1, userId);
            stmt.setString(2, enteredPassword);

            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return null;
            }

            // else returns result
            String employeeID = rs.getString(1);
            String password = rs.getString(2);
            String email = rs.getString(3);
            String isAdmin = rs.getString(4);
            String monthlyOverhead = rs.getString(5);
            String position = rs.getString(6);
            String isSupervisor = rs.getString(7);
            String bankAccount = rs.getString(8);
            String nric = rs.getString(9);
            String empName = rs.getString(10);
            String phoneNum = rs.getString(11);
            Date dateJoined = rs.getDate(12);
            Date dob = rs.getDate(13);
            String nationality = rs.getString(14);
            //ArrayList<Job> currentJobs = rs.

            //ArrayList<Job> currentJobs, ArrayList<Job> pastJobs, String department
            //return new Staff(email, pw, isAdmin);
            return new Employee(employeeID, password, email, isAdmin, monthlyOverhead, position, isSupervisor, bankAccount, nric, empName, phoneNum, dateJoined, dob, nationality);
        } catch (SQLException e) {
            e.printStackTrace();
            //Returns empty staff, so that add new job can determine that the staff does note exist and it's a database error
            //a database error!
            //Will be checked by .getUserId method!
            return null;
        }
    }

    public static Employee getEmployeeByEmail(String email) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getEmployeeByEmailStatement);
            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return null;
            }

            // else returns result
            String employeeID = rs.getString(1);
            String password = rs.getString(2);
            String isAdmin = rs.getString(4);
            String monthlyOverhead = rs.getString(5);
            String position = rs.getString(6);
            String isSupervisor = rs.getString(7);
            String bankAccount = rs.getString(8);
            String nric = rs.getString(9);
            String empName = rs.getString(10);
            String phoneNum = rs.getString(11);
            Date dateJoined = rs.getDate(12);
            Date dob = rs.getDate(13);
            String nationality = rs.getString(14);
            //ArrayList<Job> currentJobs = rs.

            //ArrayList<Job> currentJobs, ArrayList<Job> pastJobs, String department
            //return new Staff(email, pw, isAdmin);
            return new Employee(employeeID, password, email, isAdmin, monthlyOverhead, position, isSupervisor, bankAccount, nric, empName, phoneNum, dateJoined, dob, nationality);
        } catch (SQLException e) {
            e.printStackTrace();
            //Returns empty staff, so that add new job can determine that the staff does note exist and it's a database error
            //a database error!
            //Will be checked by .getUserId method!
            return null;
        }
    }

    public static HashMap<String, String> getEmployeeEmails() {
        ArrayList<Employee> empList = getAllEmployees();
        HashMap<String, String> emailList = new HashMap<>();
        if (empList == null || empList.isEmpty()) {
            return emailList;
        }
        for (Employee e : empList) {
            if (emailList.get(e.getName()) == null) {
                emailList.put(e.getName(), e.getEmail());
            }
        }

        return emailList;
    }

    public static ArrayList<Employee> getAllEmployees() {
        ArrayList<Employee> empList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllEmployeeStatement);

            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return empList;
            }
            empList.add(new Employee(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getDate(12), rs.getDate(13), rs.getString(14)));
            while (rs.next()) {
                empList.add(new Employee(rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getDate(12), rs.getDate(13), rs.getString(14)));
            }
            return empList;
        } catch (SQLException e) {
            System.out.println("EmployeeDAO: (getAllEmployees) = " + e.toString());
            //Returns empty staff, so that add new job can determine that the staff does note exist and it's a database error
            //a database error!
            //Will be checked by .getUserId method!
        }
        return empList;
    }

    public boolean deleteEmployee(String nric) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(deleteEmployeeByNRICStatement);
            stmt.setString(1, nric);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEmployeeByEmployeeId(String employeeId) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(deleteEmployeeByEmployeeIdStatement);
            stmt.setString(1, employeeId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEmployeeByEmployeeName(String employeeName) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(deleteEmployeeByEmployeeNameStatement);
            stmt.setString(1, employeeName);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createEmployee(String employeeID, String password, String email, String isAdmin, String monthlyOverhead, String position, String supervisor, String bankAccount, String nric, String name, String phoneNum, Date dateJoined, Date dob, String nationality) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(insertEmployeeStatement);
            stmt.setString(1, employeeID);
            stmt.setString(2, password);
            stmt.setString(3, email);
            stmt.setString(4, isAdmin);
            stmt.setString(5, monthlyOverhead);
            stmt.setString(6, position);
            stmt.setString(7, supervisor);
            stmt.setString(8, bankAccount);
            stmt.setString(9, nric);
            stmt.setString(10, name);
            stmt.setString(11, phoneNum);
            sqlDate = new java.sql.Date(dateJoined.getTime());
            stmt.setDate(12, sqlDate);
            sqlDate = new java.sql.Date(dob.getTime());
            stmt.setDate(13, sqlDate);
            stmt.setString(14, nationality);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPassword(String pwd, String email) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(resetPasswordStatement);
            stmt.setString(1, pwd);
            stmt.setString(2, email);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateEmployeeDetails(Employee employee) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateEmployeeStatement);
            stmt.setString(1, employee.getPassword());
            stmt.setString(2, employee.getEmail());
            stmt.setString(3, employee.getIsAdmin());
            stmt.setString(4, employee.getMonthlyOverhead());
            stmt.setString(5, employee.getPosition());
            stmt.setString(6, employee.getIsSupervisor());
            stmt.setString(7, employee.getBankAccount());
            stmt.setString(8, employee.getName());
            stmt.setString(9, employee.getNumber());
            stmt.setDate(10, (Date) employee.getDateJoined());
            stmt.setDate(11, (Date) employee.getDob());
            stmt.setString(12, employee.getNationality());
            stmt.setString(13, employee.getNric());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<String> getAllEmployeeNames() {
        ArrayList<String> nameList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getEmployeeNameStatement);
            stmt.setString(1, "no");
            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return nameList;
            }
            nameList.add(rs.getString(1));
            while (rs.next()) {
                nameList.add(rs.getString(1));
            }
            return nameList;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nameList;
    }

    public ArrayList<String> getAllSupervisor() {
        ArrayList<String> supList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllSupervisorStatement);
            stmt.setString(1, "yes");
            ResultSet rs = stmt.executeQuery();

            // returns null if no records are returned
            if (!rs.next()) {
                return supList;
            }
            //System.out.println("ROW COUNT======="+rowCount);
            supList.add(rs.getString(1));
            while (rs.next()) {
                supList.add(rs.getString(1));
            }
            return supList;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return supList;
    }

    public boolean updateEmployeeProfile(String userID, String email, String number, String bankAccount, String nationality, String monthlyOverhead, String isAdmin, String position, String supervisor) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE EMPLOYEE SET email= ?, number = ?, bankAccount=?, nationality=?, monthlyOverhead=?, isAdmin =?, position=?, supervisor=? WHERE employeeID=?");
            stmt.setString(1, email);
            stmt.setString(2, number);
            stmt.setString(3, bankAccount);
            stmt.setString(4, nationality);
            stmt.setString(5, monthlyOverhead);
            stmt.setString(6, isAdmin);
            stmt.setString(7, position);
            stmt.setString(8, supervisor);
            stmt.setString(9, userID);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateOwnEmployeeProfile(String userID, String email, String number, String bankAccount, String password) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE EMPLOYEE SET email= ?, number = ?, bankAccount=?, password=? WHERE employeeID=?");
            stmt.setString(1, email);
            stmt.setString(2, number);
            stmt.setString(3, bankAccount);
            stmt.setString(4, password);
            stmt.setString(5, userID);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static HashMap<String, Double> getCostPerHourPerStaff() {
        ArrayList<Employee> empList = getAllEmployees();

        //To get cost per hour per Staff
        // Key = Name, Value = Cost Per Hour Per Staff (MonthlyOverhead/ [20*8])
        HashMap<String, Double> costPerHourPerStaff = new HashMap();

        for (int i = 0; i < empList.size(); i++) {
            Employee emp = empList.get(i);
            String key = emp.getName();
            Double monthlyOverhead = Double.parseDouble(emp.getMonthlyOverhead());
            Double value = monthlyOverhead / (20 * 8);
            costPerHourPerStaff.put(key, value);
        }
        return costPerHourPerStaff;
    }

    public static HashMap<String, ArrayList<Project>> getCompletedProjectList() {
        //Key = EmpName, Value = Completed Projects
        HashMap<String, ArrayList<Project>> projectList = new HashMap();

        //Key = EmpName, Value = CostPerHourPerStaff
        HashMap<String, Double> costPerHourPerStaffList = getCostPerHourPerStaff();

        for (String empName : costPerHourPerStaffList.keySet()) {
            ArrayList<ArrayList<Project>> list = ProjectDAO.getAllProjectsByEmployee(empName);
            projectList.put(empName, list.get(0));
        }
        return projectList;
    }

    public static HashMap<String, Double> getSales(String selectedYear) {
        //Key = Month, Value = Sales (Hours Assigned * CostPerHourPerStaff)
        HashMap<String, Double> salesList = new HashMap();

        HashMap<String, Double> costPerHourPerStaffList = getCostPerHourPerStaff();
        HashMap<String, ArrayList<Project>> projectList = getCompletedProjectList();

        for (String empName : projectList.keySet()) {
            ArrayList<Project> list = projectList.get(empName);

            //Key = Month, Value = HoursAssigned based on EmpName
            HashMap<String, Double> hoursAssignedList = new HashMap();

            String key = "";
            double value = 0.0;

            for (int i = 0; i < list.size(); i++) {
                Project p = list.get(i);
                
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String dateCompleted = df.format(p.getDateCompleted());
                String year = dateCompleted.substring(0, 4);
                String month = dateCompleted.substring(5,7);

                if (year.equals(selectedYear)) {
                    switch (month) {
                        case "01":
                            key = "01";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "02":
                            key = "02";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "03":
                            key = "03";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "04":
                            key = "04";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "05":
                            key = "05";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "06":
                            key = "06";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "07":
                            key = "07";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "08":
                            key = "08";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "09":
                            key = "09";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "10":
                            key = "10";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "11":
                            key = "11";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                        case "12":
                            key = "12";

                            if (hoursAssignedList.containsKey(key)) {
                                value += hoursAssignedList.get(key);
                            } else {
                                value = p.getPlannedHours();
                            }
                            hoursAssignedList.put(key, value);
                            break;
                    }
                }
            }
            if (!hoursAssignedList.isEmpty()) {
                double costPerHour = costPerHourPerStaffList.get(empName);
                for (String m : hoursAssignedList.keySet()) {
                    double hoursAssigned = hoursAssignedList.get(m);
                    double sales = hoursAssigned * costPerHour;
                    
                    if(salesList.containsKey(m)) {
                        sales += salesList.get(m);
                    }
                    salesList.put(m, sales);
                }
            }
        }
        return salesList;
    }
    
    public static HashMap<String, Double> getTotalActualCost(String selectedYear) {
        HashMap<String, Double> totalActualCostList = new HashMap();
        
        HashMap<String, Double> costPerHourPerStaffList = getCostPerHourPerStaff();
        HashMap<String, ArrayList<Project>> projectList = getCompletedProjectList();

        for (String empName : projectList.keySet()) {
            ArrayList<Project> list = projectList.get(empName);

            //Key = Month, Value = HoursAssigned based on EmpName
            HashMap<String, Double> hoursActualList = new HashMap();

            String key = "";
            double value = 0.0;

            for (int i = 0; i < list.size(); i++) {
                Project p = list.get(i);

                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String dateCompleted = df.format(p.getDateCompleted());
                String year = dateCompleted.substring(0, 4);
                String month = dateCompleted.substring(5,7);

                if (year.equals(selectedYear)) {
                    switch (month) {
                        case "01":
                            key = "01";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "02":
                            key = "02";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "03":
                            key = "03";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "04":
                            key = "04";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "05":
                            key = "05";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "06":
                            key = "06";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "07":
                            key = "07";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "08":
                            key = "08";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "09":
                            key = "09";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "10":
                            key = "10";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "11":
                            key = "11";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                        case "12":
                            key = "12";

                            if (hoursActualList.containsKey(key)) {
                                value += hoursActualList.get(key);
                            } else {
                                value = p.getEmployee1Hours() + p.getEmployee2Hours();
                            }
                            hoursActualList.put(key, value);
                            break;
                    }
                }
            }
            if (!hoursActualList.isEmpty()) {
                double costPerHour = costPerHourPerStaffList.get(empName);
                for (String m : hoursActualList.keySet()) {
                    double hoursAssigned = hoursActualList.get(m);
                    double sales = hoursAssigned * costPerHour;
                    
                    if(totalActualCostList.containsKey(m)) {
                        sales += totalActualCostList.get(m);
                    }
                    totalActualCostList.put(m, sales);
                }
            }
        }
        return totalActualCostList;
    }
    
    public static HashMap<String,Double> getProfit(String selectedYear) {
     HashMap<String, Double> profitList = new HashMap();
     
     HashMap<String, Double> salesList = getSales(selectedYear);
     HashMap<String, Double> totalActualCostList = getTotalActualCost(selectedYear);
     
     for(String m : salesList.keySet()) {
         double sales = salesList.get(m);
         double totalActualCost = totalActualCostList.get(m);
         
         double profit = sales - totalActualCost;
         profitList.put(m, profit);
     }
     return profitList;
    }
}
