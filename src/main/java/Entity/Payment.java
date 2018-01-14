/**
 * Payment object represents 1 invoice for expenses
 * Each Payment object must have at least 1 line and has several business logic to follow before being valid for submission
 */
package Entity;

import java.util.Date;
import java.util.List;

public class Payment {

    /**
     * Payment data that is consistent for all the line items
     */
    private Date date;
    private String referenceNumber;
    private Integer chargedAccountNumber;
    private String memo; // not compulsory
    private String paymentMethod; //default is cash
    private String vendor;
    private List<PaymentLine> lines;
    
    private String status;
    
    public boolean checkPayment(){
        // Multi-lined expenses has to have a reference number
        if (lines != null && lines.size() > 1) {
            return referenceNumber != null && date != null  && vendor != null && chargedAccountNumber != null;
        }
        return date != null && chargedAccountNumber != null  && vendor != null;
    }

    @Override
    public String toString() {
        return "Payment{" + "date=" + date + ", referenceNumber=" + referenceNumber + ", chargedAccountNumber=" + chargedAccountNumber + ", memo=" + memo + ", paymentMethod=" + paymentMethod + ", vendor=" + vendor + ", lines=" + lines + ", status=" + status + '}';
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getReferenceNumber() {
        return referenceNumber;
    }

    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public Integer getChargedAccountNumber() {
        return chargedAccountNumber;
    }

    public void setChargedAccountNumber(Integer chargedAccountNumber) {
        this.chargedAccountNumber = chargedAccountNumber;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public List<PaymentLine> getLines() {
        return lines;
    }

    public void setLines(List<PaymentLine> lines) {
        this.lines = lines;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
    
    
}
