/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import java.util.Date;

public class Employee {
    private String employeeID;
    private String password;
    private String email;
    private String isAdmin;
    private String monthlyOverhead;
    private String position;
    private String isSupervisor;
    private String bankAccount;
    private String nric;
    private String name;
    private String number;
    private Date dateJoined;
    private Date dob;
    private String nationality;

    @Override
    public String toString() {
        return "Employee{" + "employeeID=" + employeeID + ", password=" + password + ", email=" + email + ", isAdmin=" + isAdmin + ", monthlyOverhead=" + monthlyOverhead + ", position=" + position + ", isSupervisor=" + isSupervisor + ", bankAccount=" + bankAccount + ", nric=" + nric + ", name=" + name + ", number=" + number + ", dateJoined=" + dateJoined + ", dob=" + dob + ", nationality=" + nationality + '}';
    }
    

    public Employee(String employeeID, String password, String email, String isAdmin, String monthlyOverhead, String position, String isSupervisor, String bankAccount, String nric, String name, String number, Date dateJoined, Date dob, String nationality) {
        this.employeeID = employeeID;
        this.password = password;
        this.email = email;
        this.isAdmin = isAdmin;
        this.monthlyOverhead = monthlyOverhead;
        this.position = position;
        this.isSupervisor = isSupervisor;
        this.bankAccount = bankAccount;
        this.nric = nric;
        this.name = name;
        this.number = number;
        this.dateJoined = dateJoined;
        this.dob = dob;
        this.nationality = nationality;
    }
    
    public String getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(String employeeID) {
        this.employeeID = employeeID;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(String isAdmin) {
        this.isAdmin = isAdmin;
    }

    public String getMonthlyOverhead() {
        return monthlyOverhead;
    }

    public void setMonthlyOverhead(String monthlyOverhead) {
        this.monthlyOverhead = monthlyOverhead;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getIsSupervisor() {
        return isSupervisor;
    }

    public void setIsSupervisor(String isSupervisor) {
        this.isSupervisor = isSupervisor;
    }

    public String getBankAccount() {
        return bankAccount;
    }

    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount;
    }

    public String getNric() {
        return nric;
    }

    public void setNric(String nric) {
        this.nric = nric;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Date getDateJoined() {
        return dateJoined;
    }

    public void setDateJoined(Date dateJoined) {
        this.dateJoined = dateJoined;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }
    
    
}
