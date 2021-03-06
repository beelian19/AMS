package Entity;

public class PaymentLine {

    private String accountName;
    private Integer accountNumber;
    private String lineDescription;
    private Double exTaxAmount;
    private Double incTaxAmount;
    private String tax;
    private String QBOLineClass;
    private String QBOLineCustomer;
    
    private String initStatus;

    /**
     * Check is this line has the required information to be processed
     *
     * @return
     */
    public boolean checkPaymentLine() {
        return accountNumber != null && exTaxAmount != null && incTaxAmount != null && tax != null;
    }

    @Override
    public String toString() {
        return "PaymentLine{" + "accountName=" + accountName + ", accountNumber=" + accountNumber + ", lineDescription=" + lineDescription + ", exTaxAmount=" + exTaxAmount + ", incTaxAmount=" + incTaxAmount + ", tax=" + tax + ", QBOLineClass=" + QBOLineClass + ", QBOLineCustomer=" + QBOLineCustomer + ", initStatus=" + initStatus + '}';
    }
    
    

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public Integer getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(Integer accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getLineDescription() {
        return lineDescription;
    }

    public void setLineDescription(String lineDescription) {
        this.lineDescription = lineDescription;
    }

    public Double getExTaxAmount() {
        return exTaxAmount;
    }

    public void setExTaxAmount(Double exTaxAmount) {
        this.exTaxAmount = exTaxAmount;
    }

    public Double getIncTaxAmount() {
        return incTaxAmount;
    }

    public void setIncTaxAmount(Double incTaxAmount) {
        this.incTaxAmount = incTaxAmount;
    }

    public String getTax() {
        return tax;
    }

    public void setTax(String tax) {
        this.tax = tax;
    }

    public String getQBOLineClass() {
        return QBOLineClass;
    }

    public void setQBOLineClass(String QBOLineClass) {
        this.QBOLineClass = QBOLineClass;
    }

    public String getQBOLineCustomer() {
        return QBOLineCustomer;
    }

    public void setQBOLineCustomer(String QBOLineCustomer) {
        this.QBOLineCustomer = QBOLineCustomer;
    }

    public String getInitStatus() {
        return initStatus;
    }

    public void setInitStatus(String initStatus) {
        this.initStatus = initStatus;
    }

    
    

}
