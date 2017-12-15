/**
 * The expense object represents a single-lined expense
 */
package Entity;

import java.util.Date;

public class Expense {

    private Integer rowNumber;
    private Date date;
    private Integer chargedAccountNumber;
    private Integer accountNumber;
    private String accountName;
    private String description;
    private String vendor;
    private String reference;
    private String location;
    private String paymentMethod;
    private Double exTaxAmount;
    private Double incTaxAmount;
    private String tax;
    private String memo;
    private Boolean complete;
    // status of the expense object after processing
    private String status;

    public Expense() {
    }

    /**
     * Checks if the expense object has all the necessary information for being
     * processed
     *
     * @return
     */
    public Boolean checkComplete() {
        complete = date != null && accountNumber != null && chargedAccountNumber != null
                && vendor != null && exTaxAmount != null && incTaxAmount != null
                && tax != null;
        return complete;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getRowNumber() {
        return rowNumber;
    }

    public void setRowNumber(Integer rowNumber) {
        this.rowNumber = rowNumber;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Integer getChargedAccountNumber() {
        return chargedAccountNumber;
    }

    public void setChargedAccountNumber(Integer chargedAccountNumber) {
        this.chargedAccountNumber = chargedAccountNumber;
    }

    public Integer getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(Integer accountNumeber) {
        this.accountNumber = accountNumeber;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
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

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

}
