package Entity;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class Project {

    private int projectID;
    private String projectTitle;
    private String companyName;
    private String businessType;
    private Date start;
    private Date end;
    private String projectRemarks;
    private String projectStatus;
    private Date actualDeadline;
    private String frequency;
    private String projectType;
    private String employee1;
    private String employee2;
    private Double employee1Hours;
    private Double employee2Hours;
    private String projectReviewer;
    private String projectReviewStatus;
    private int dateCompleted;
    private String monthlyHours;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Returns the employee position (either 1 or 2) of the project based on the
     * employee name that is parsed in. Returns 0 if there is no match in name
     *
     * @param employeeName
     * @return
     */
    public int getEmployeeNumber(String employeeName) {
        if (employeeName.equals(employee1)) {
            return 1;
        } else if (employeeName.equals(employee2)) {
            return 2;
        } else {
            return 0;
        }
    }

    /**
     * Parse in the employee's name and the new total number of hours The method
     * will update the total hours in either employee1Hours or employee2Hours
     * and monthlyHours for tracking. Use ProjectDAO to reflect changes in the
     * database Returns boolean if update to the Project object was executed
     *
     * @param employee
     * @param newTotalHours
     * @return
     */
    public boolean updateHours(String employee, Double newTotalHours) {
        // Ensure that newTotalHours is in 1 decimal placing
        BigDecimal bd = new BigDecimal(newTotalHours);
        bd = bd.setScale(1, BigDecimal.ROUND_DOWN);
        newTotalHours = bd.doubleValue();

        // Get the index of the employee
        int empIndex = getEmployeeNumber(employee);

        // Ensure that monthlyHours is initialized
        if (empIndex > 0 && monthlyHours != null && !monthlyHours.trim().equals("")) {

            // This is to access the correct emplyee's hours in a 0-based list
            empIndex -= 1;

            // Get the current year and month
            int yearMonth = getYearMonth();

            // Convert current monthlyHours into a hashmap
            Map<Integer, String> hours = Arrays.stream(monthlyHours.split(","))
                    .collect(
                            Collectors.toMap(
                                    (String key) -> Integer.valueOf(key.substring(0, key.indexOf("=")).trim()),
                                    (String value) -> value.substring(value.indexOf("=") + 1).trim()
                            )
                    );
            // Get all the month's hour entries for this project
            Set<Integer> entries = hours.keySet();

            Double totalPreviousMonthHours = 0.0;
            int otherEmpIndex = (empIndex == 0) ? 1 : 0;
            Double otherEmpHours = 0.0;
            //The hour to inpute for the current months hour is newTotalHours - totalPreviousMonthHours
            //Sum up all the previous months hours
            for (Integer yrMth : entries) {

                String value = hours.get(yrMth);
                List<Double> values = Arrays.stream(value.split("-")).map(Double::valueOf).collect(Collectors.toList());
                if (yrMth != yearMonth) {
                    totalPreviousMonthHours += values.get(empIndex);
                } else {
                    otherEmpHours = values.get(otherEmpIndex);
                }
            }
            Double newMonthHours = newTotalHours - totalPreviousMonthHours;

            // Depending if employee is employee1 or employee2
            String newMonthValue = (empIndex == 0) ? newMonthHours + "-" + otherEmpHours : otherEmpHours + "-" + newMonthHours;

            // Update the hashmap
            hours.put(yearMonth, newMonthValue);

            // Update either employee1Hours or employee2Hours to newTotalHours
            if (empIndex == 0) {
                employee1Hours = newTotalHours;
            } else {
                employee2Hours = newTotalHours;
            }

            // Update monthlyHours, substring to remove {} from the .toString() of a hashmap
            monthlyHours = hours.toString().substring(1, hours.toString().length() - 1);

            return true;
        }
        return false;
    }

    /**
     * Gets the current year and month and converts it into a 4 digit integer in
     * the format yyMM Example: December 2017 -> 1712
     *
     * @return
     */
    public static int getYearMonth() {
        Calendar now = Calendar.getInstance();
        int month = now.get(Calendar.MONTH) + 1;
        int year = now.get(Calendar.YEAR) % 1000 * 100;
        System.out.println(year + month);
        return year + month;
    }

    /**
     * Gets the parsed date object's year and month and converts it into a 4
     * digit integer in the format yyMM Example: December 2017 -> 1712
     *
     * @param date
     * @return
     */
    public static int getYearMonth(Date date) {
        Calendar now = Calendar.getInstance();
        now.setTime(date);
        int month = now.get(Calendar.MONTH) + 1;
        int year = now.get(Calendar.YEAR) % 1000 * 100;
        System.out.println(year + month);
        return year + month;
    }

    /**
     * Gets the parsed string year and month and converts it into a 4 digit
     * integer in the format yyMM Example: December 2017 -> 1712
     *
     * @param yyyyMMdd
     * @return
     * @throws java.text.ParseException
     */
    public static int getYearMonth(String yyyyMMdd) throws ParseException {
        Calendar now = Calendar.getInstance();
        Date date = sdf.parse(yyyyMMdd);
        now.setTime(date);
        int month = now.get(Calendar.MONTH) + 1;
        int year = now.get(Calendar.YEAR) % 1000 * 100;
        System.out.println(year + month);
        return year + month;
    }

    public Project(int projectID, String projectTitle, String companyName, String businessType, Date start, Date end, String projectRemarks, String projectStatus, Date actualDeadline, String frequency, String projectType, String employee1, String employee2, Double employee1Hours, Double employee2Hours, String projectReviewer, String projectReviewStatus, int dateCompleted, String monthlyHours) {
        this.projectID = projectID;
        this.projectTitle = projectTitle;
        this.companyName = companyName;
        this.businessType = businessType;
        this.start = start;
        this.end = end;
        this.projectRemarks = projectRemarks;
        this.projectStatus = projectStatus;
        this.actualDeadline = actualDeadline;
        this.frequency = frequency;
        this.projectType = projectType;
        this.employee1 = employee1;
        this.employee2 = employee2;
        this.employee1Hours = employee1Hours;
        this.employee2Hours = employee2Hours;
        this.projectReviewer = projectReviewer;
        this.projectReviewStatus = projectReviewStatus;
        this.dateCompleted = dateCompleted;
        this.monthlyHours = monthlyHours;
    }

    public Project() {
    }

    @Override
    public String toString() {
        return "Project{" + "projectID=" + projectID + ", projectTitle=" + projectTitle + ", companyName=" + companyName + ", businessType=" + businessType + ", start=" + start + ", end=" + end + ", projectRemarks=" + projectRemarks + ", projectStatus=" + projectStatus + ", actualDeadline=" + actualDeadline + ", frequency=" + frequency + ", projectType=" + projectType + ", employee1=" + employee1 + ", employee2=" + employee2 + ", employee1Hours=" + employee1Hours + ", employee2Hours=" + employee2Hours + ", projectReviewer=" + projectReviewer + ", projectReviewStatus=" + projectReviewStatus + ", dateCompleted=" + dateCompleted + ", monthlyHours=" + monthlyHours + '}';
    }

    public int getProjectID() {
        return projectID;
    }

    public void setProjectID(int projectID) {
        this.projectID = projectID;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public String getProjectRemarks() {
        return projectRemarks;
    }

    public void setProjectRemarks(String projectRemarks) {
        this.projectRemarks = projectRemarks;
    }

    public String getProjectStatus() {
        return projectStatus;
    }

    public void setProjectStatus(String projectStatus) {
        this.projectStatus = projectStatus;
    }

    public Date getActualDeadline() {
        return actualDeadline;
    }

    public void setActualDeadline(Date actualDeadline) {
        this.actualDeadline = actualDeadline;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public String getEmployee1() {
        return employee1;
    }

    public void setEmployee1(String employee1) {
        this.employee1 = employee1;
    }

    public String getEmployee2() {
        return employee2;
    }

    public void setEmployee2(String employee2) {
        this.employee2 = employee2;
    }

    public Double getEmployee1Hours() {
        return employee1Hours;
    }

    public void setEmployee1Hours(Double employee1Hours) {
        this.employee1Hours = employee1Hours;
    }

    public Double getEmployee2Hours() {
        return employee2Hours;
    }

    public void setEmployee2Hours(Double employee2Hours) {
        this.employee2Hours = employee2Hours;
    }

    public String getProjectReviewer() {
        return projectReviewer;
    }

    public void setProjectReviewer(String projectReviewer) {
        this.projectReviewer = projectReviewer;
    }

    public String getProjectReviewStatus() {
        return projectReviewStatus;
    }

    public void setProjectReviewStatus(String projectReviewStatus) {
        this.projectReviewStatus = projectReviewStatus;
    }

    public int getDateCompleted() {
        return dateCompleted;
    }

    public void setDateCompleted(int dateCompleted) {
        this.dateCompleted = dateCompleted;
    }

    public String getMonthlyHours() {
        return monthlyHours;
    }

    public void setMonthlyHours(String monthlyHours) {
        this.monthlyHours = monthlyHours;
    }

}
