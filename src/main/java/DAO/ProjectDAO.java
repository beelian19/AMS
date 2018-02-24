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
20.  plannedHours - Double
 */
import static DAO.EmployeeDAO.getCompletedProjectList;
import static DAO.EmployeeDAO.getCostPerHourPerStaff;
import Entity.Client;
import Entity.Employee;
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
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.stream.Collectors;

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
            + "projectReviewer=?,projectReviewStatus=?,dateCompleted=?, monthlyHours=? , plannedHours = ? WHERE projectID=?";
    private static String updateProjectStatementWithSelectedFields = "UPDATE project SET title=?, start=?, end=?, projectRemarks=?, employee1=?,"
            + "employee2=?, projectReviewer=? WHERE projectID=?";
    private static String getAllIncompleteProjects = "SELECT * FROM project where projectStatus = 'incomplete' OR projectReviewStatus = 'incomplete'";
    private static String getAllIncompleteProjectsByCompanyName = "SELECT * FROM project where ( projectStatus = 'incomplete' OR projectReviewStatus = 'incomplete' ) AND companyName = ?";
    private static String getAllCompletedProjectsByCompanyName = "SELECT * FROM project where ( projectStatus = 'complete' AND projectReviewStatus = 'complete' ) AND companyName = ?";
    private static String getAllIncompleteAdhocProjects = "SELECT * FROM project where ( projectStatus = 'incomplete' OR projectReviewStatus = 'incomplete'  ) AND projectType='adhoc'";
    private static String getProjectByTitleAndCompanyNameStatement = "SELECT projectID FROM project WHERE title=? AND companyName=?";
    private static String createProjectStatement = "Insert into PROJECT values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
            System.out.println("SQLException at ProjectDAO getAllProjectTask method: " + e.getMessage());
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
            if (t.getTaskStatus().equals("complete")) {
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
            System.out.println("SQLException at ProjectDAO getTotalNumberOfProjects method: " + e.getMessage());
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
            sqlDate = new java.sql.Date(project.getDateCompleted().getTime());
            stmt.setDate(18, sqlDate);
            stmt.setString(19, project.getMonthlyHours());
            stmt.setDouble(20, project.getPlannedHours());
            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO createProject method: " + e.getMessage());
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
            String projectReviewStatus, Date dateCompleted, String monthlyHours, Double plannedHours) {
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
            sqlDate = new java.sql.Date(dateCompleted.getTime());
            stmt.setDate(18, sqlDate);
            stmt.setString(19, monthlyHours);
            stmt.setDouble(20, plannedHours);

            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO createProject method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllProjects method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllIncompleteProjects method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;
    }

    public static ArrayList<Project> getAllIncompleteProjectsByCompanyName(String companyName) {
        ArrayList<Project> projectList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllIncompleteProjectsByCompanyName);
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllIncompleteProjectsByCompanyName method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;

    }

    public static ArrayList<Project> getAllCompleteProjectsByCompanyName(String companyName) {
        ArrayList<Project> projectList = new ArrayList<>();
        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(getAllCompletedProjectsByCompanyName);
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllCompleteProjectsByCompanyName method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return projectList;

    }

    /**
     * Creates a HashMap with the key being the project type and value being the
     * URL that directs to the project info
     *
     * @param projects
     * @return
     */
    public static HashMap<String, String> getProjectTypeAsKeyAndURLAsValue(ArrayList<Project> projects) {
        HashMap<String, String> map = new HashMap<>();
        String profileUrl = "ProjectProfile.jsp?projectID=";
        for (Project p : projects) {
            if (map.get(p.getProjectType()) == null && !map.containsKey(p.getProjectType())) {
                map.put(p.getProjectType(), profileUrl + p.getProjectIDString());
            }
        }

        return map;
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllIncompleteAdhocProjects method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllProjectsByEmployee method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getAllProjectsByCompanyName method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                return project;
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getProjectByID method: " + e.getMessage());
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));
                return project;
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getProjectByTitleAndCompanyName method: " + e.getMessage());
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
            sqlDate = new java.sql.Date(project.getDateCompleted().getTime());
            stmt.setDate(17, sqlDate);
            stmt.setString(18, project.getMonthlyHours());
            stmt.setInt(20, project.getProjectID());
            stmt.setDouble(19, project.getPlannedHours());

            return (stmt.executeUpdate() == 1);
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO updateProject method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO updateProject method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO updateProjectStatus method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO updateProjectStatus method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO updateProjectRemarks method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO updateProjectRemarks method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO deleteProject method: " + e.getMessage());
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
            System.out.println("SQLException at ProjectDAO deleteProject method: " + e.getMessage());
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

    public double getHoursPerEmployeeByProject(int projectID, String employeeName) {
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
                if (rs.getString("employee1").equals(employeeName)) {
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

    public static void performRecur(String projectID) {
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
                Calendar cal4 = Calendar.getInstance();

                switch (frequency) {
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
                project.setDateCompleted(cal4.getTime());
                project.setMonthlyHours("0");
                project.setPlannedHours(rs.getDouble("plannedHours"));

                boolean status = createProject(project);
            }

        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO performRecur method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

    }

    public static ArrayList<Project> getStaffMonthlyReport(String employeeName, String year) {

        ArrayList<Project> projectList = new ArrayList<>();
        ArrayList<Project> incomplete = new ArrayList<>();
        ArrayList<Project> complete = new ArrayList<>();

        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM project WHERE employee1 = ? OR employee2 = ? and YEAR(end)=?");
            stmt.setString(1, employeeName);
            stmt.setString(2, employeeName);
            stmt.setString(3, year);
            //date for start
            //date for end 
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getStaffMonthlyReport method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

        if (projectList.isEmpty()) {
            return projectList;
        } else {
            for (Project proj : projectList) {
                if (proj.getProjectReviewStatus().equals("complete")) {
                    complete.add(proj);
                } else {
                    incomplete.add(proj);
                }
            }
            return complete;
        }
    }

    public static ArrayList<ArrayList<Integer>> getCompletedProjectMonthlyProfitability(String year) {

        //array of profit project count per month and array of loss project count per month
        int yearProfit[] = new int[12];
        int yearLoss[] = new int[12];

        Project project;
        //retrieve all fully completed project for a given year
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM project WHERE projectReviewStatus = ? and year(end)=?");
            stmt.setString(1, "complete");
            stmt.setString(2, year);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                //check the month of the project
                Date date = rs.getDate("end");
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                int month = cal.get(Calendar.MONTH);
                //create the project object
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                //check here if profit or loss 
                double status = getProfit(project);

                //add into respective month arraylist based on month retrieved 
                switch (month) {
                    case 0:
                        if (status > 0) {
                            yearProfit[0] += 1;
                        } else {
                            yearLoss[0] += 1;
                        }
                        break;
                    case 1:
                        if (status > 0) {
                            yearProfit[1] += 1;
                        } else {
                            yearLoss[1] += 1;
                        }
                        break;
                    case 2:
                        if (status > 0) {
                            yearProfit[2] += 1;
                        } else {
                            yearLoss[2] += 1;
                        }
                        break;
                    case 3:
                        if (status > 0) {
                            yearProfit[3] += 1;
                        } else {
                            yearLoss[3] += 1;
                        }
                        break;
                    case 4:
                        if (status > 0) {
                            yearProfit[4] += 1;
                        } else {
                            yearLoss[4] += 1;
                        }
                        break;
                    case 5:
                        if (status > 0) {
                            yearProfit[5] += 1;
                        } else {
                            yearLoss[5] += 1;
                        }
                        break;
                    case 6:
                        if (status > 0) {
                            yearProfit[6] += 1;
                        } else {
                            yearLoss[6] += 1;
                        }
                        break;
                    case 7:
                        if (status > 0) {
                            yearProfit[7] += 1;
                        } else {
                            yearLoss[7] += 1;
                        }
                        break;
                    case 8:
                        if (status > 0) {
                            yearProfit[8] += 1;
                        } else {
                            yearLoss[8] += 1;
                        }
                        break;
                    case 9:
                        if (status > 0) {
                            yearProfit[9] += 1;
                        } else {
                            yearLoss[9] += 1;
                        }
                        break;
                    case 10:
                        if (status > 0) {
                            yearProfit[10] += 1;
                        } else {
                            yearLoss[10] += 1;
                        }
                        break;
                    case 11:
                        if (status > 0) {
                            yearProfit[11] += 1;
                        } else {
                            yearLoss[11] += 1;
                        }
                        break;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getCompletedProjectMonthlyProfitability method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        //combine the 2 arrays

        ArrayList<Integer> yearProfitList = new ArrayList();
        ArrayList<Integer> yearLossList = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = yearProfit[i];
            yearProfitList.add(value);
        }

        for (int i = 0; i < 12; i++) {
            int value = yearLoss[i];
            yearLossList.add(value);
        }
        ArrayList<ArrayList<Integer>> complete = new ArrayList();

        complete.add(yearProfitList);
        complete.add(yearLossList);
        return complete;
    }

    public static int[] getOverdueProjectPerYear(String year) {

        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (dateCompleted > end) GROUP BY MONTH(end)");
            stmt.setString(1, year);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getOverdueProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static int[] getCompletedProjectPerYear(String year, String empName) {

        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and employee1=? or employee2=? and `projectReviewStatus` = 'completed' GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, empName);
            stmt.setString(3, empName);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getCompletedProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static Double[] getSales(String selectedYear) {
        Double[] totalSalesList = new Double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        HashMap<String, ArrayList<Project>> projectList = EmployeeDAO.getCompletedProjectList();
        HashMap<String, Double> costPerHourPerStaffList = EmployeeDAO.getCostPerHourPerStaff();

        DecimalFormat decimal = new DecimalFormat("#.##");

        for (String empName : projectList.keySet()) {
            ArrayList<Project> list = projectList.get(empName);

            double value = 0.0;

            for (int i = 0; i < list.size(); i++) {
                Project p = list.get(i);

                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String dateCompleted = df.format(p.getDateCompleted());
                String year = dateCompleted.substring(0, 4);
                String month = dateCompleted.substring(5, 7);
                if (year.equals(selectedYear)) {

                    switch (month) {
                        case "01":
                            if (!p.getEmployee2().equals("NA")) { //there are two employees
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else { // there is one employee which is employee1
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }

                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[0] += value;
                            break;
                        case "02":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }

                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[1] += value;
                            break;
                        case "03":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[2] += value;
                            break;
                        case "04":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[3] += value;
                            break;
                        case "05":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[4] += value;
                            break;
                        case "06":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }

                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[5] += value;
                            break;
                        case "07":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[6] += value;
                            break;
                        case "08":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[7] += value;
                            break;
                        case "09":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[8] += value;
                            break;
                        case "10":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[9] += value;
                            break;
                        case "11":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[10] += value;
                            break;
                        case "12":
                            if (!p.getEmployee2().equals("NA")) {
                                value = (p.getPlannedHours() / 2) * costPerHourPerStaffList.get(empName);
                            } else {
                                value = p.getPlannedHours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalSalesList[11] += value;
                            break;
                    }
                }
            }
        }
        return totalSalesList;
    }

    public static Double[] getActualCost(String selectedYear) {
        Double[] totalActualCostList = new Double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        HashMap<String, ArrayList<Project>> projectList = EmployeeDAO.getCompletedProjectList();
        HashMap<String, Double> costPerHourPerStaffList = EmployeeDAO.getCostPerHourPerStaff();

        DecimalFormat decimal = new DecimalFormat("#.##");
        for (String empName : projectList.keySet()) {
            ArrayList<Project> list = projectList.get(empName);

            double value = 0.0;

            for (int i = 0; i < list.size(); i++) {
                Project p = list.get(i);

                DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String dateCompleted = df.format(p.getDateCompleted());
                String year = dateCompleted.substring(0, 4);
                String month = dateCompleted.substring(5, 7);

                String emp1 = p.getEmployee1();
                String emp2 = p.getEmployee2();

                if (year.equals(selectedYear)) {

                    switch (month) {
                        case "01":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));
                            totalActualCostList[0] += value;
                            break;
                        case "02":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[1] += value;
                            break;
                        case "03":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[2] += value;
                            break;
                        case "04":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[3] += value;
                            break;
                        case "05":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[4] += value;
                            break;
                        case "06":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[5] += value;
                            break;
                        case "07":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[6] += value;
                            break;
                        case "08":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[7] += value;
                            break;
                        case "09":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[8] += value;
                            break;
                        case "10":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[9] += value;
                            break;
                        case "11":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[10] += value;
                            break;
                        case "12":
                            if (emp1.equals(empName)) {
                                value = p.getEmployee1Hours() * costPerHourPerStaffList.get(empName);
                            }
                            if (emp2.equals(empName)) {
                                value = p.getEmployee2Hours() * costPerHourPerStaffList.get(empName);
                            }
                            value = Double.valueOf(decimal.format(value));

                            totalActualCostList[11] += value;
                            break;
                    }
                }
            }
        }
        return totalActualCostList;
    }

    public static Double[] getProfit(String selectedYear) {
        Double[] totalProfitList = new Double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};

        Double[] salesList = getSales(selectedYear);
        Double[] actualCostList = getActualCost(selectedYear);

        for (int i = 0; i < 12; i++) {
            totalProfitList[i] = salesList[i] - actualCostList[i];
        }
        return totalProfitList;
    }

    public static int[] getOverdueProjectPerStaff(String year, String name) {

        int[] numList = new int[12];
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (dateCompleted > end) and employee1=? or employee2= ? GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, name);
            stmt.setString(3, name);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getOverdueProjectPerStaff method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

        return numList;
    }

    public static int[] getTimeExceededPerStaff(String year, String name) {

        int[] numList = new int[12];
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (employee1Hours > (plannedHours)/2) and employee1=? or employee2 =? GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, name);
            stmt.setString(3, name);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getTimeExceededPerStaff method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static double getTotalActualCost(Project project) {
        double totalActualCost = 0.0;

        HashMap<String, Double> costPerHourPerStaffList = EmployeeDAO.getCostPerHourPerStaff();

        String emp1 = project.getEmployee1();
        String emp2 = project.getEmployee2();

        double emp1CostPerHour = 0.0;
        double emp2CostPerHour = 0.0;

        double emp1ActualHours = 0.0;
        double emp2ActualHours = 0.0;

        if (emp1 != null && !emp1.equals("NA")) {
            emp1CostPerHour = costPerHourPerStaffList.get(emp1);
            emp1ActualHours = project.getEmployee1Hours();
        }
        if (emp2 != null && !emp2.equals("NA")) {
            emp2CostPerHour = costPerHourPerStaffList.get(emp2);
            emp2ActualHours = project.getEmployee2Hours();
        }

        totalActualCost = (emp1CostPerHour * emp1ActualHours) + (emp2CostPerHour * emp2ActualHours);
        DecimalFormat df = new DecimalFormat("#.##");
        totalActualCost = Double.valueOf(df.format(totalActualCost));

        return totalActualCost;
    }

    public static double getSales(Project project) {
        double sales = 0.0;

        HashMap<String, Double> costPerHourPerStaffList = EmployeeDAO.getCostPerHourPerStaff();
        
        String emp1 = project.getEmployee1();
        String emp2 = project.getEmployee2();
//        System.out.println("Employee 1 : " + emp1);
//        System.out.println("Employee 2 : " + emp2);
        double plannedHours = project.getPlannedHours();

        double emp1CostPerHour = 0.0;
        double emp2CostPerHour = 0.0;

        if (emp1 != null && !emp1.equals("NA")) {
            emp1CostPerHour = costPerHourPerStaffList.get(emp1);
        }
        if (emp2 != null && !emp2.equals("NA")) {
            emp2CostPerHour = costPerHourPerStaffList.get(emp2);
        }

        if (emp2.equals("NA")) {
            sales = emp1CostPerHour * plannedHours;
        } else {
            sales = (emp1CostPerHour * (plannedHours / 2.0)) + (emp2CostPerHour * (plannedHours / 2.0));
        }

        DecimalFormat df = new DecimalFormat("#.##");
        sales = Double.valueOf(df.format(sales));

        return sales;
    }

    public static double getProfit(Project project) {
        double profit = 0.0;

        double sales = getSales(project);
        double totalActualCost = getTotalActualCost(project);

        profit = sales - totalActualCost;
        DecimalFormat df = new DecimalFormat("#.##");
        profit = Double.valueOf(df.format(profit));

        return profit;
    }

    public static int[] getOnTimeProjectPerYear(String year) {

        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (dateCompleted < end) GROUP BY MONTH(end)");
            stmt.setString(1, year);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getOnTimeProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static int[] getTotalCompletedProjectPerYear(String year) {

        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (projectReviewStatus=?) GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, "complete");
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getTotalCompletedProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static ArrayList<ArrayList<Integer>> getCompanyMonthlyProfitability(String clientId, String year) {

        //array of profit project count per month and array of loss project count per month
        Client client = ClientDAO.getClientById(clientId);
        String companyName = client.getCompanyName();

        int yearProfit[] = new int[12];
        int yearLoss[] = new int[12];

        Project project;
        //retrieve all fully completed project for a given year
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM project WHERE projectReviewStatus = ? and companyName=? and year(end)=?");
            stmt.setString(1, "complete");
            stmt.setString(2, companyName);
            stmt.setString(3, year);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                //check the month of the project
                Date date = rs.getDate("end");
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                int month = cal.get(Calendar.MONTH);
                //create the project object
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                //check here if profit or loss 
                double status = getProfit(project);

                //add into respective month arraylist based on month retrieved 
                switch (month) {
                    case 0:
                        if (status > 0) {
                            yearProfit[0] += 1;
                        } else {
                            yearLoss[0] += 1;
                        }
                        break;
                    case 1:
                        if (status > 0) {
                            yearProfit[1] += 1;
                        } else {
                            yearLoss[1] += 1;
                        }
                        break;
                    case 2:
                        if (status > 0) {
                            yearProfit[2] += 1;
                        } else {
                            yearLoss[2] += 1;
                        }
                        break;
                    case 3:
                        if (status > 0) {
                            yearProfit[3] += 1;
                        } else {
                            yearLoss[3] += 1;
                        }
                        break;
                    case 4:
                        if (status > 0) {
                            yearProfit[4] += 1;
                        } else {
                            yearLoss[4] += 1;
                        }
                        break;
                    case 5:
                        if (status > 0) {
                            yearProfit[5] += 1;
                        } else {
                            yearLoss[5] += 1;
                        }
                        break;
                    case 6:
                        if (status > 0) {
                            yearProfit[6] += 1;
                        } else {
                            yearLoss[6] += 1;
                        }
                        break;
                    case 7:
                        if (status > 0) {
                            yearProfit[7] += 1;
                        } else {
                            yearLoss[7] += 1;
                        }
                        break;
                    case 8:
                        if (status > 0) {
                            yearProfit[8] += 1;
                        } else {
                            yearLoss[8] += 1;
                        }
                        break;
                    case 9:
                        if (status > 0) {
                            yearProfit[9] += 1;
                        } else {
                            yearLoss[9] += 1;
                        }
                        break;
                    case 10:
                        if (status > 0) {
                            yearProfit[10] += 1;
                        } else {
                            yearLoss[10] += 1;
                        }
                        break;
                    case 11:
                        if (status > 0) {
                            yearProfit[11] += 1;
                        } else {
                            yearLoss[11] += 1;
                        }
                        break;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getCompanyMonthlyProfitability method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        //combine the 2 arrays

        ArrayList<Integer> yearProfitList = new ArrayList();
        ArrayList<Integer> yearLossList = new ArrayList();

        for (int i = 0; i < 12; i++) {
            int value = yearProfit[i];
            yearProfitList.add(value);
        }

        for (int i = 0; i < 12; i++) {
            int value = yearLoss[i];
            yearLossList.add(value);
        }
        ArrayList<ArrayList<Integer>> complete = new ArrayList();

        complete.add(yearProfitList);
        complete.add(yearLossList);
        return complete;
    }

    public static int[] getClientOverdueProjectPerYear(String clientid, String year) {

        Client client = ClientDAO.getClientById(clientid);
        String companyName = client.getCompanyName();
        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (dateCompleted > end) and companyName = ? GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, companyName);

            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getClientOverdueProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static int[] getClientOnTimeProjectPerYear(String clientid, String year) {

        Client client = ClientDAO.getClientById(clientid);
        String companyName = client.getCompanyName();
        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT MONTH(end) MONTH, COUNT(*) COUNT FROM project WHERE YEAR(end)=? and (dateCompleted < end) and companyName = ? GROUP BY MONTH(end)");
            stmt.setString(1, year);
            stmt.setString(2, companyName);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getClientOnTimeProjectPerYear method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static int[] getOnTimeCompletedProjectEmployee(String empName, String year) {

        int[] numList = new int[12];

        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT month(end) month,count(*) count from project where employee1=? or employee2=? and year(end) =? and (end <= dateCompleted) GROUP by month(end)");
            stmt.setString(1, empName);
            stmt.setString(2, empName);
            stmt.setString(3, year);
            //date for start
            //date for end 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String month = rs.getString("MONTH");
                Integer monthInt = Integer.parseInt(month);
                String count = rs.getString("COUNT");
                Integer countInt = Integer.parseInt(count);
                numList[monthInt - 1] = countInt;

            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getOnTimeCompletedProjectEmployee method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }
        return numList;
    }

    public static ArrayList<Project> getSpecificStaffReport(String employeeName, String year) {

        ArrayList<Project> projectList = new ArrayList<>();
        ArrayList<Project> incomplete = new ArrayList<>();
        ArrayList<Project> complete = new ArrayList<>();

        Project project;
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM project WHERE employee1 = ? OR employee2 = ? and YEAR(end)=?");
            stmt.setString(1, employeeName);
            stmt.setString(2, employeeName);
            stmt.setString(3, year);
            //date for start
            //date for end 
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));

                projectList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getSpecificStaffReport method: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unexpected error at ProjectDAO: " + e.getMessage());
        }

        if (projectList.isEmpty()) {
            return projectList;
        } else {
            for (Project proj : projectList) {
                if (proj.getProjectReviewStatus().equals("complete")) {
                    complete.add(proj);
                } else {
                    incomplete.add(proj);
                }
            }
            return complete;
        }
    }

    public static ArrayList<Project> getProjectsWithinSelectedYear(String year) {
        ArrayList<Project> returnList = new ArrayList();
        try (Connection conn = ConnectionManager.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM project WHERE year(end) = ? AND projectStatus='complete' AND projectReviewStatus='complete'");
            stmt.setString(1, year);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                //create the project object
                Project project = new Project();
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
                project.setDateCompleted(rs.getDate("dateCompleted"));
                project.setMonthlyHours(rs.getString("monthlyHours"));
                project.setPlannedHours(rs.getDouble("plannedHours"));
                returnList.add(project);
            }
        } catch (SQLException e) {
            System.out.println("SQLException at ProjectDAO getProjectsWithinSelectedYear method: " + e.getMessage());
        }
        return returnList;
    }
}
