package Entity;

import java.util.Date;

public class Task {
    
    private int projectID; 
    private int taskID; 
    private String taskTitle; 
    private Date start; 
    private Date end;
    private String taskRemarks; 
    private String taskStatus;
    private int uniqueTaskID;
    private String reviewer; 
    private String reviewStatus; 

    public Task(int projectID, int taskID, String taskTitle, Date start, Date end, String taskRemarks, String taskStatus, int uniqueTaskID, String reviewer, String reviewStatus) {
        this.projectID = projectID;
        this.taskID = taskID;
        this.taskTitle = taskTitle;
        this.start = start;
        this.end = end;
        this.taskRemarks = taskRemarks;
        this.taskStatus = taskStatus;
        this.uniqueTaskID = uniqueTaskID;
        this.reviewer = reviewer;
        this.reviewStatus = reviewStatus;
    }
    
    public Task(){
        
    }

    @Override
    public String toString() {
        return "Task{" + "projectID=" + projectID + ", taskID=" + taskID + ", taskTitle=" + taskTitle + ", start=" + start + ", end=" + end + ", taskRemarks=" + taskRemarks + ", taskStatus=" + taskStatus + ", uniqueTaskID=" + uniqueTaskID + ", reviewer=" + reviewer + ", reviewStatus=" + reviewStatus + '}';
    }

    public int getProjectID() {
        return projectID;
    }

    public void setProjectID(int projectID) {
        this.projectID = projectID;
    }

    public int getTaskID() {
        return taskID;
    }

    public void setTaskID(int taskID) {
        this.taskID = taskID;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
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

    public String getTaskRemarks() {
        return taskRemarks;
    }

    public void setTaskRemarks(String taskRemarks) {
        this.taskRemarks = taskRemarks;
    }

    public String getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
    }

    public int getUniqueTaskID() {
        return uniqueTaskID;
    }

    public void setUniqueTaskID(int uniqueTaskID) {
        this.uniqueTaskID = uniqueTaskID;
    }

    public String getReviewer() {
        return reviewer;
    }

    public void setReviewer(String reviewer) {
        this.reviewer = reviewer;
    }

    public String getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    

    
}
