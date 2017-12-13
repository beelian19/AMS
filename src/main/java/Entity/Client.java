package Entity;

public class Client {

    private int clientID;
    private String businessType;
    private String companyName;
    private String incorporation;
    private String UENNumber;
    private String officeContact;
    private String contactEmailAddress;
    private String officeAddress;
    private String financialYearEnd;
    private String gstSubmission;
    private String director;
    private String secretary;
    private String accountant;
    private String realmid;
    private String mgmtAcc;

    @Override
    public String toString() {
        return "Client{" + "clientID=" + clientID + ", businessType=" + businessType + ", companyName=" + companyName + ", incorporation=" + incorporation + ", UENNumber=" + UENNumber + ", officeContact=" + officeContact + ", contactEmailAddress=" + contactEmailAddress + ", officeAddress=" + officeAddress + ", financialYearEnd=" + financialYearEnd + ", gstSubmission=" + gstSubmission + ", director=" + director + ", secretary=" + secretary + ", accountant=" + accountant + ", realmid=" + realmid + ", mgmtAcc=" + mgmtAcc + '}';
    }

    public Client(int clientID, String businessType, String companyName, String incorporation, String UENNumber, String officeContact, String contactEmailAddress, String officeAddress, String financialYearEnd, String gstSubmission, String director, String secretary, String accountant, String realmid, String mgmtAcc) {
        this.clientID = clientID;
        this.businessType = businessType;
        this.companyName = companyName;
        this.incorporation = incorporation;
        this.UENNumber = UENNumber;
        this.officeContact = officeContact;
        this.contactEmailAddress = contactEmailAddress;
        this.officeAddress = officeAddress;
        this.financialYearEnd = financialYearEnd;
        this.gstSubmission = gstSubmission;
        this.director = director;
        this.secretary = secretary;
        this.accountant = accountant;
        this.realmid = realmid;
        this.mgmtAcc = mgmtAcc;
    }

    public int getClientID() {
        return clientID;
    }

    public void setClientID(int clientID) {
        this.clientID = clientID;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getIncorporation() {
        return incorporation;
    }

    public void setIncorporation(String incorporation) {
        this.incorporation = incorporation;
    }

    public String getUENNumber() {
        return UENNumber;
    }

    public void setUENNumber(String UENNumber) {
        this.UENNumber = UENNumber;
    }

    public String getOfficeContact() {
        return officeContact;
    }

    public void setOfficeContact(String officeContact) {
        this.officeContact = officeContact;
    }

    public String getContactEmailAddress() {
        return contactEmailAddress;
    }

    public void setContactEmailAddress(String contactEmailAddress) {
        this.contactEmailAddress = contactEmailAddress;
    }

    public String getOfficeAddress() {
        return officeAddress;
    }

    public void setOfficeAddress(String officeAddress) {
        this.officeAddress = officeAddress;
    }

    public String getFinancialYearEnd() {
        return financialYearEnd;
    }

    public void setFinancialYearEnd(String financialYearEnd) {
        this.financialYearEnd = financialYearEnd;
    }

    public String getGstSubmission() {
        return gstSubmission;
    }

    public void setGstSubmission(String gstSubmission) {
        this.gstSubmission = gstSubmission;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getSecretary() {
        return secretary;
    }

    public void setSecretary(String secretary) {
        this.secretary = secretary;
    }

    public String getAccountant() {
        return accountant;
    }

    public void setAccountant(String accountant) {
        this.accountant = accountant;
    }

    public String getRealmid() {
        return realmid;
    }

    public void setRealmid(String realmid) {
        this.realmid = realmid;
    }

    public String getMgmtAcc() {
        return mgmtAcc;
    }

    public void setMgmtAcc(String mgmtAcc) {
        this.mgmtAcc = mgmtAcc;
    }

}
