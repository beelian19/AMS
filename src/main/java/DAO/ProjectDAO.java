/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

/*
1.  projectID int
2.  title String
3.  companyName String
4.  businessType String
5.  start - Date
6.  end - Date
7.  projectRemarks String
8.  projectStatus -String
9.  actualDeadline - Date
10.  frequency - String
11.  projectType - String
12.  employee1 - String
13.  employee2 - String
14.  employee1Hours - Double
15.  employee2Hours - Double
16.  projectReviewer - String
17.  projectReviewStatus - String
18.  dateCompleted - int
19.  monthlyHours - String
 */
import Entity.Project;
import Entity.Task;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import Utility.ConnectionManager;

/**
 *
 * @author icon
 */
public class ProjectDAO {

    private static String viewProjectOrderByEndAsc = "SELECT * FROM PROJECT ORDER BY end asc";
    private static String getProjectByIDStatement = "SELECT * FROM project WHERE projectID=?";
    private static String updateCompleteProjectStatusStatment = "UPDATE project SET projectStatus='complete' WHERE projectID=?";
    private static String updateRemarksbyIDStatement = "UPDATE project SET projectRemarks = ? WHERE projectID = ?";
    private static String updateProjectStatement = "UPDATE project SET title=?, companyName=?, businessType=?,start=?,end=?,projectRemarks=?,"
            + "projectStatus=?,actualDeadline=?,frequency=?,projectType=?,employee1=?,employee2=?,employee1Hours=?,employee2Hours=?,"
            + "projectReviewer=?,projectReviewStatus=?,dateCompleted=?, monthlyHours=? WHERE projectID=?";
    private static String updateProjectStatementWithSelectedFields = "UPDATE project SET title=?, start=?, end=?, projectRemarks=?, employee1=?,"
            + "employee2=?, projectReviewer=? WHERE projectID=?";
    private static String getAllIncompleteProjects = "SELECT * FROM project where projectStatus = 'incomplete' OR projectReviewStatus = 'incomplete'";
    private static String getAllIncompleteAdhocProjects = "SELECT * FROM project where ( projectStatus = 'incomplete' OR projectReviewStatus = 'incomplete'  ) AND projectType='adhoc'";
    private static String getProjectByTitleAndCompanyNameStatement = "SELECT projectID FROM project WHERE title=? AND companyName=?";
    private static String createProjectStatement = "Insert into PROJECT values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static String getAllProjectByEmployee = "SELECT * FROM project WHERE employee1 = ? OR employee2 = ? or projectReviewer = ?";
    private static String getAllProjectByCompanyName = "SELECT * FROM project WHERE companyName = ?";
    private static String getAllProjectTaskStatement = "SELECT * FROM task WHERE projectID = ?";

    private static String updateReviewStatusStatement = "UPDATE PROJECT SET projectReviewStatus=? WHERE PROJECTID=?";
    private static String updateRecurringProjectStatement = "INSERT INTO PROJECT VALUES (?,?,?,?,?,?,?,?,?)";
    private static String getJobByIDStatement = "SELECT * FROM PROJECT WHERE PROJECTID=?";
    private static String viewIncompleteCompanyNameStatement = "SELECT companyName FROM PROJECT WHERE projectStatus = 'incomplete'";
    private static String viewIncompleteProjListStatement = "SELECT title FROM PROJECT WHERE projectStatus='incomplete'";
    private static String getProjectIDStatement1 = "SELECT projectID FROM PROJECT WHERE title=? AND companyName=?";
    private static String updateProjectStatement1 = "UPDATE PROJECT SET title=?, companyName=?, companyCategory=?, businessType=?, remarks=?, projectStatus=?, gstFrequency=?, mgmtFrequency=?, taxTimeline=?,eciTimeline=?,gstTimeline=?,finalAcc=?,secretarialTimeline=?, mgmtAccTimeline=?  WHERE projectID=?";
    private static String viewAllTaskStatement = "SELECT * FROM PROJECT WHERE REVIEWER=? ORDER BY end asc";
    private static String updateAdhocProjectStatement = "UPDATE PROJECT SET title=?, companyName=?, start=?, end=?, projectRemarks=?, employee1=?, employee2=?, projectReviewer=? WHERE projectID=?";

    public static ArrayList<Task> getAllProjectTask(int id) {
        ArrayList<Task> taskList = new ArrayList<>();
        Task task;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllProjectTaskStatement);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                task = new Task();
                task.setProjectID(rs.getInt(1));
                task.setTaskID(rs.getInt(2));
                task.setTaskTitle(rs.getString(3));
                task.setStart(rs.getDate(4));
                task.setEnd(rs.getDate(5));
                task.setTaskRemarks(rs.getString(6));
                task.setTaskStatus(rs.getString(7));
                task.setTaskID(rs.getInt(8));
                task.setReviewer(rs.getString(9));
                task.setReviewStatus(rs.getString(10));

                taskList.add(task);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return taskList;

    }

    public static ArrayList<ArrayList<Task>> getAllProjectTaskFiltered(int id) {
        Calendar deadline;
        ArrayList<Task> all = getAllProjectTask(id);
        ArrayList<Task> overdue = new ArrayList<>();
        ArrayList<Task> ongoing = new ArrayList<>();
        ArrayList<Task> completed = new ArrayList<>();
        ArrayList<ArrayList<Task>> returnList = new ArrayList<>();

        for (Task t : all) {
            deadline = Calendar.getInstance();
            deadline.setTime(t.getEnd());
            if (t.getTaskStatus().equals("completed")) {
                completed.add(t);
            } else if (Calendar.getInstance().before(deadline)) {
                ongoing.add(t);
            } else {
                overdue.add(t);
            }

        }
        returnList.add(overdue);
        returnList.add(ongoing);
        returnList.add(completed);
        return returnList;

    }

    /**
     * Gets the total number of rows from the project table. Does not add 1
     *
     * @return int
     */
    public static int getTotalNumberOfProjects() {
        try (Connection conn = ConnectionManager.getConnection()) {
            String query = "SELECT max(projectID) FROM project";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                return (rs.getInt("max(projectID)") + 1);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Method to insert a project into the date base, takes in the project
     * object to be inserted. Ignore project id in the project object since this
     * is taken care of backend.
     *
     * @param project
     * @return boolean if update is accurate
     */
    public static boolean createProject(Project project) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(createProjectStatement);
            // Add one to the current latests list
            int nextProjectId = getTotalNumberOfProjects() + 1;
            stmt.setInt(1, nextProjectId);
            stmt.setString(2, project.getProjectTitle());
            stmt.setString(3, project.getCompanyName());
            stmt.setString(4, project.getBusinessType());
            sqlDate = new java.sql.Date(project.getStart().getTime());
            stmt.setDate(5, sqlDate);
            sqlDate = new java.sql.Date(project.getEnd().getTime());
            stmt.setDate(6, sqlDate);
            stmt.setString(7, project.getProjectRemarks());
            stmt.setString(8, project.getProjectStatus());
            sqlDate = new java.sql.Date(project.getActualDeadline().getTime());
            stmt.setDate(9, sqlDate);
            stmt.setString(10, project.getFrequency());
            stmt.setString(11, project.getProjectType());
            stmt.setString(12, project.getEmployee1());
            stmt.setString(13, project.getEmployee2());
            stmt.setDouble(14, project.getEmployee1Hours());
            stmt.setDouble(15, project.getEmployee2Hours());
            stmt.setString(16, project.getProjectReviewer());
            stmt.setString(17, project.getProjectReviewStatus());
            stmt.setInt(18, project.getDateCompleted());
            stmt.setString(19,project.getMonthlyHours());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     *
     * @param projectTitle
     * @param companyName
     * @param businessType
     * @param start
     * @param end
     * @param projectRemarks
     * @param projectStatus
     * @param actualDeadline
     * @param frequency
     * @param projectType
     * @param employee1
     * @param employee2
     * @param employee1Hours
     * @param employee2Hours
     * @param projectReviewer
     * @param projectReviewStatus
     * @param dateCompleted
     * @param monthlyHours
     * @return boolean if creating project was successful
     */
    public static boolean createProject(String projectTitle, String companyName, String businessType, Date start, Date end,
            String projectRemarks, String projectStatus, Date actualDeadline, String frequency,
            String projectType, String employee1, String employee2,
            Double employee1Hours, Double employee2Hours, String projectReviewer,
            String projectReviewStatus, int dateCompleted, String monthlyHours) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(createProjectStatement);
            int nextProjectId = getTotalNumberOfProjects() + 1;
            stmt.setInt(1, nextProjectId);
            stmt.setString(2, projectTitle);
            stmt.setString(3, companyName);
            stmt.setString(4, businessType);
            sqlDate = new java.sql.Date(start.getTime());
            stmt.setDate(5, sqlDate);
            sqlDate = new java.sql.Date(end.getTime());
            stmt.setDate(6, sqlDate);
            stmt.setString(7, projectRemarks);
            stmt.setString(8, projectStatus);
            sqlDate = new java.sql.Date(actualDeadline.getTime());
            stmt.setDate(9, sqlDate);
            stmt.setString(10, frequency);
            stmt.setString(11, projectType);
            stmt.setString(12, employee1);
            stmt.setString(13, employee2);
            stmt.setDouble(14, employee1Hours);
            stmt.setDouble(15, employee2Hours);
            stmt.setString(16, projectReviewer);
            stmt.setString(17, projectReviewStatus);
            stmt.setInt(18, dateCompleted);
            stmt.setString(19, monthlyHours);
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    public static ArrayList<ArrayList<Project>> getAllProjectsFiltered() {
        ArrayList<Project> projectList = getAllProjects();
        ArrayList<Project> incomplete = new ArrayList<>();
        ArrayList<Project> complete = new ArrayList<>();
        ArrayList<ArrayList<Project>> returnList = new ArrayList<>();
        if (projectList.isEmpty()) {
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        } else {
            for (Project proj : projectList) {
                if (proj.getProjectStatus().equals("complete")) {
                    complete.add(proj);
                } else {
                    incomplete.add(proj);
                }

            }
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        }
    }

    /**
     *
     * @return AttayList<> of all projects ordered by end date
     */
    public static ArrayList<Project> getAllProjects() {
        ArrayList<Project> projectList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(viewProjectOrderByEndAsc);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;
    }

    /**
     *
     * @return ArrayList of projects that are incomplete
     */
    public static ArrayList<Project> getAllIncompleteProjects() {
        ArrayList<Project> projectList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllIncompleteProjects);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;
    }

    /**
     *
     * @return ArrayList of ad hoc projects that are incomplete
     */

    public static ArrayList<Project> getAllIncompleteAdhocProjects() {
        ArrayList<Project> projectList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllIncompleteAdhocProjects);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;
    }

    /**
     * Returns the projects of the given employee 0 index for complete projects
     * 1 index for incomplete projects
     *
     * @param employeeName
     * @return
     */
    public static ArrayList<ArrayList<Project>> getAllProjectsByEmployee(String employeeName) {
        ArrayList<Project> projectList = new ArrayList<>();
        ArrayList<Project> incomplete = new ArrayList<>();
        ArrayList<Project> complete = new ArrayList<>();
        ArrayList<ArrayList<Project>> returnList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllProjectByEmployee);
            stmt.setString(1, employeeName);
            stmt.setString(2, employeeName);
            stmt.setString(3, employeeName);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

        if (projectList.isEmpty()) {
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        } else {
            for (Project proj : projectList) {
                if (proj.getProjectReviewStatus().equals("complete")) {
                    complete.add(proj);
                } else {
                    incomplete.add(proj);
                }

            }
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        }
    }

    /**
     * 0 index for complete 1 index for incomplete
     *
     * @param companyName
     * @return ArrayList of ArrayList of projects
     */
    public static ArrayList<ArrayList<Project>> getAllProjectsByCompanyName(String companyName) {
        ArrayList<Project> projectList = new ArrayList<>();
        ArrayList<Project> incomplete = new ArrayList<>();
        ArrayList<Project> complete = new ArrayList<>();
        ArrayList<ArrayList<Project>> returnList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllProjectByCompanyName);
            stmt.setString(1, companyName);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

        if (projectList.isEmpty()) {
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        } else {
            for (Project proj : projectList) {
                if (proj.getProjectStatus().equals("complete")) {
                    complete.add(proj);
                } else {
                    incomplete.add(proj);
                }

            }
            returnList.add(complete);
            returnList.add(incomplete);
            return returnList;
        }
    }

    /**
     * returns 2 ArrayList of Strings The 0 index is companyName list The 1
     * index is the projectId List
     *
     * @return ArrayList<ArrayList<>>
     */
    public static ArrayList<ArrayList<String>> getIncompleteCompanyNameAndProjectID() {
        ArrayList<String> nameList = new ArrayList<>();
        ArrayList<String> projectIDList = new ArrayList<>();
        ArrayList<ArrayList<String>> returnList = new ArrayList<>();
        ArrayList<Project> incompleteProjectList = new ArrayList<>();
        incompleteProjectList = getAllIncompleteProjects();
        if (incompleteProjectList == null || incompleteProjectList.isEmpty()) {
            return returnList;
        }
        for (Project project : incompleteProjectList) {
            nameList.add(project.getCompanyName());
            projectIDList.add(project.getProjectID() + "");
        }
        returnList.add(nameList);
        returnList.add(projectIDList);
        return returnList;
    }

    /**
     * Returns the project by taking in the projectID On error, returned project
     * has an ID of 0
     *
     * @param projectID
     * @return
     */
    public static Project getProjectByID(String projectID) {
        Project project = new Project();
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getProjectByIDStatement);
            stmt.setInt(1, Integer.parseInt(projectID));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));

                return project;
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return project;

    }

    /**
     * Retreieves the project that has the title and companyName parsed in
     *
     * @param title
     * @param companyName
     * @return project object. If error, returned project has id of 0
     */
    public static Project getProjectByTitleAndCompanyName(String title, String companyName) {
        Project project = new Project();
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getProjectByTitleAndCompanyNameStatement);
            stmt.setString(1, title);
            stmt.setString(2, companyName);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                project = new Project();
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(rs.getDate("start"));
                project.setEnd(rs.getDate("end"));
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus(rs.getString("projectStatus"));
                project.setActualDeadline(rs.getDate("actualDeadline"));
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(rs.getDouble("employee1Hours"));
                project.setEmployee2Hours(rs.getDouble("employee2Hours"));
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus(rs.getString("projectReviewStatus"));
                project.setDateCompleted(rs.getInt("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                return project;
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return project;

    }

    /*"UPDATE project SET projectTitle=?, companyName=?, businessType=?,start=?,end=?,projectRemarks=?,"
    + "projectStatus=?,actualDeadline=?,frequency=?,projectType=?,assignedEmployee1=?,assignedEmployee2=?,employee1Hours=?,employee2Hours=?,"
    + "projectReviewer=?,projectReviewStatus=?numberOfInvoices=? WHERE projectID=?";*/
    /**
     * returns boolean if the update was successful
     *
     * @param project
     * @return boolean
     */
    public static boolean updateProject(Project project) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateProjectStatement);
            stmt.setString(1, project.getProjectTitle());
            stmt.setString(2, project.getCompanyName());
            stmt.setString(3, project.getBusinessType());
            sqlDate = new java.sql.Date(project.getStart().getTime());
            stmt.setDate(4, sqlDate);
            sqlDate = new java.sql.Date(project.getEnd().getTime());
            stmt.setDate(5, sqlDate);
            stmt.setString(6, project.getProjectRemarks());
            stmt.setString(7, project.getProjectStatus());
            sqlDate = new java.sql.Date(project.getActualDeadline().getTime());
            stmt.setDate(8, sqlDate);
            stmt.setString(9, project.getFrequency());
            stmt.setString(10, project.getProjectType());
            stmt.setString(11, project.getEmployee1());
            stmt.setString(12, project.getEmployee2());
            stmt.setDouble(13, project.getEmployee1Hours());
            stmt.setDouble(14, project.getEmployee2Hours());
            stmt.setString(15, project.getProjectReviewer());
            stmt.setString(16, project.getProjectReviewStatus());
            stmt.setInt(17, project.getDateCompleted());
            stmt.setString(18, project.getMonthlyHours());
            stmt.setInt(19, project.getProjectID());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * returns boolean if the update was successful
     *
     * @param project
     * @return boolean
     */
    public static boolean updateProject(String projectID, String projectTitle, Date startDate, Date endDate, String projectRemarks, String emp1, String emp2, String projectReviewer) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateProjectStatementWithSelectedFields);
            stmt.setString(1, projectTitle);
            sqlDate = new java.sql.Date(startDate.getTime());
            stmt.setDate(2, sqlDate);
            sqlDate = new java.sql.Date(endDate.getTime());
            stmt.setDate(3, sqlDate);
            stmt.setString(4, projectRemarks);
            stmt.setString(5, emp1);
            stmt.setString(6, emp2);
            stmt.setString(7, projectReviewer);
            stmt.setString(8, projectID);
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }
    public static boolean updateAdHocProject(int projectID, String title, String companyName, Date start, Date end, String emp, String emp1, String remarks, String reviewer) {
        java.sql.Date sqlDate;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateAdhocProjectStatement);

            stmt.setString(1, title);
            stmt.setString(2, companyName);
            sqlDate = new java.sql.Date(start.getTime());
            stmt.setDate(3, sqlDate);
            sqlDate = new java.sql.Date(end.getTime());
            stmt.setDate(4, sqlDate);
            stmt.setString(5, emp);
            stmt.setString(6, emp1);
            stmt.setString(7, remarks);
            stmt.setString(8, reviewer);
            stmt.setInt(9, projectID);
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO UpdateAdHocProject: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO UpdateAdHocProject: " + e.getMessage());
        }
        return false;
    }

    /**
     * Method to update only the status of the project.
     *
     * @param project
     * @return boolean if update was successful
     */
    public static boolean updateProjectStatus(Project project) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateCompleteProjectStatusStatment);
            stmt.setInt(1, project.getProjectID());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    public static boolean updateProjectStatus(String projectID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateCompleteProjectStatusStatment);
            stmt.setInt(1, Integer.parseInt(projectID));
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     * Method to update only the remarks of the project.
     *
     * @param project
     * @return boolean if update was successful
     */
    public static boolean updateProjectRemarks(Project project) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateRemarksbyIDStatement);
            stmt.setString(1, project.getProjectRemarks());
            stmt.setInt(2, project.getProjectID());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     *
     * @param remarks
     * @param id
     * @return boolean if update was successful
     */
    public static boolean updateProjectRemarks(String remarks, String id) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(updateRemarksbyIDStatement);
            stmt.setString(1, remarks);
            stmt.setInt(2, Integer.valueOf(id));
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     * Method to delete the parsed project. Only the projectId is needed in the
     * project.
     *
     * @param project
     * @return boolean if update was successful
     */
    public static boolean deleteProject(Project project) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM project where projectID=?");
            stmt.setInt(1, project.getProjectID());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     *
     * @param id
     * @return boolean if project was complete
     */
    public boolean deleteProject(String id) {
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM project where projectID=?");
            stmt.setInt(1, Integer.parseInt(id));
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return false;
    }

    /**
     *
     * @param projects
     * @return total hours in parsed projects
     */
    public static Double getTotalHours(ArrayList<Project> projects) {
        if (projects == null || projects.isEmpty()) {
            return 0.0;
        }
        Double total_hours = 0.0;
        for (Project project : projects) {
            total_hours += project.getEmployee1Hours();
            total_hours += project.getEmployee2Hours();
        }

        return total_hours;
    }

    /*public ArrayList<Project> viewEmployeeTasks(String name) {
        ArrayList<Project> projectList = new ArrayList<>();

        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = viewAllTaskStatement;
            PreparedStatement stmt = conn.prepareStatement(statement);
            stmt.setString(1, name);
            stmt.setString(2, name);
            stmt.setString(3, name);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getDate(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getDate(10));
                projectList.add(project);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projectList;
    }*/
//need to update this shit!!!!!!!
    //this method has not reflected change from 30th October Yet
    /*public boolean insertRecurringTask(String title, String companyName, String companyCat, String businessType, Date end, String remarks, String reviewer, String reviewStatus) {
    
    try (Connection conn = ConnectionManager.getConnection()) {
    String statement = updateRecurringProjectStatement;
    PreparedStatement stmt = conn.prepareStatement(statement);
    
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    String endDate = df.format(end);
    
    stmt.setInt(1, getCounter());
    stmt.setString(2, title);
    stmt.setString(3, companyName);
    stmt.setString(4, companyCat);
    stmt.setString(5, businessType);
    stmt.setString(6, endDate);
    stmt.setString(7, remarks);
    stmt.setString(8, reviewer);
    stmt.setString(9, reviewStatus);
    
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
    
    try (Connection conn = ConnectionManager.getConnection()) {
    PreparedStatement stmt = conn.prepareStatement("Select max(projectID) from project");
    ResultSet rs = stmt.executeQuery();
    rs.last();
    int temp = rs.getInt("max(projectID)");
    int counter = temp + 1;
    return counter;
    
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return 0;
    }*/
 /*    public ArrayList<Project> viewAllTasks() {
    ArrayList<Project> projectList = new ArrayList<>();
    
    try (Connection conn = ConnectionManager.getConnection()) {
    String statement = viewProjectOrderByEndAsc;
    PreparedStatement stmt = conn.prepareStatement(statement);
    
    ResultSet rs = stmt.executeQuery();
    while (rs.next()) {
    Project project = new Project(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getDate(7), rs.getString(8), rs.getString(9), rs.getDate(10), rs.getString(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15), rs.getString(16), rs.getString(17), rs.getString(18), rs.getString(19));
    projectList.add(project);
    }
    } catch (SQLException e) {
    e.printStackTrace();
    }
    return projectList;
    }*/
    public boolean updateReviewStatus(String projectID) {
        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = updateReviewStatusStatement;
            PreparedStatement stmt = conn.prepareStatement(statement);

            stmt.setString(1, "complete");
            stmt.setString(2, projectID);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public double getHoursPerEmployeeByProject(int projectID,String employeeName){
        try (Connection conn = ConnectionManager.getConnection()) {
            String statement = "select * from project where projectID=? and (employee1=? or employee2=?)";
            PreparedStatement stmt = conn.prepareStatement(statement);

            stmt.setInt(1, projectID);
            stmt.setString(2, employeeName);
            stmt.setString(3, employeeName);

            ResultSet rs = stmt.executeQuery();
            double hours1 = 0.0;
            double hours2 = 0.0;
            while (rs.next()) {
                hours1 = rs.getDouble("employee1Hours");
                hours2 = rs.getDouble("employee2Hours");
                if (rs.getString("employee1").equals(employeeName) ) {
                    return hours1;
                } else {
                    return hours2;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public static void performRecur(String projectID){
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("Select * from project where projectID=?");
            stmt.setInt(1, Integer.parseInt(projectID));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                project = new Project();
                String frequency = rs.getString("frequency");
                Date startDate = rs.getDate("start");
                Date endDate = rs.getDate("end");
                Date actualDeadline = rs.getDate("actualDeadline");
                
                Calendar cal = Calendar.getInstance();
                cal.setTime(startDate);
                Calendar cal2 = Calendar.getInstance();
                cal2.setTime(endDate);
                Calendar cal3 = Calendar.getInstance();
                cal3.setTime(actualDeadline);
                
                switch(frequency){
                    case "m":
                        cal.add(Calendar.MONTH, 1);
                        cal2.add(Calendar.MONTH, 1);
                        cal3.add(Calendar.MONTH, 1);
                        break;
                    case "q":
                        cal.add(Calendar.MONTH, 3);
                        cal2.add(Calendar.MONTH, 3);
                        cal3.add(Calendar.MONTH, 3);
                        break;
                    case "s":
                        cal.add(Calendar.MONTH, 6);
                        cal2.add(Calendar.MONTH, 6);
                        cal3.add(Calendar.MONTH, 6);
                        break;
                    case "y":
                        cal.add(Calendar.MONTH, 12);
                        cal2.add(Calendar.MONTH, 12);
                        cal3.add(Calendar.MONTH, 12);
                        break;
                }
               
                project.setProjectID(rs.getInt("projectID"));
                project.setProjectTitle(rs.getString("title"));
                project.setCompanyName(rs.getString("companyName"));
                project.setBusinessType(rs.getString("businessType"));
                project.setStart(cal.getTime());
                project.setEnd(cal2.getTime());
                project.setProjectRemarks(rs.getString("projectRemarks"));
                project.setProjectStatus("incomplete");
                project.setActualDeadline(cal3.getTime());
                project.setFrequency(rs.getString("frequency"));
                project.setProjectType(rs.getString("projectType"));
                project.setEmployee1(rs.getString("employee1"));
                project.setEmployee2(rs.getString("employee2"));
                project.setEmployee1Hours(0.0);
                project.setEmployee2Hours(0.0);
                project.setProjectReviewer(rs.getString("projectReviewer"));
                project.setProjectReviewStatus("incomplete");
                project.setDateCompleted(0000);
                project.setMonthlyHours("0");
                
                boolean status = createProject(project);
            }
            
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        
    }
    
}
