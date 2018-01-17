/**
 * Version 2.0
 * - only xlsx file is supported. This factory takes in an xlsx file and converts it into Abundant Payment Object
 *  The Payment Object should be able to hold various accounting software, to be built in future iterations
 */
package Entity;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class PaymentFactory {

    private Workbook workbook;
    private final int paymentStartLine = 3;
    private String excelClientName;
    private String realmid;
    private String UEN;
    private Calendar creationDate;
    private Calendar completionDate;
    private List<Payment> prePayments;
    private List<Payment> postPayments;
    private String chargedAccountName;
    private int chargedAccountNumber;
    private long timeElapsed;
    private List<String> initMessages;
    private List<String> processMessages;
    private Token token;

    /**
     * Initializes all the required information for expenses and returns a List
     * of Strings for status and error handling. Returns boolean on proper
     * initialization of key information
     *
     * @return
     */
    public Boolean init() {
        //Version 1.0 only support xlsx file. Change here with more wrapper methods and
        //Switch statements to add in more file types

        initMessages = excelInit();
        creationDate = Calendar.getInstance();

        return UEN != null && prePayments != null && chargedAccountNumber != 0;
    }

    /**
     * Initializing method for excel file to read the workbook contents to
     * extract Payment information Excel cell positioning is 0-based
     *
     * @return
     */
    private List<String> excelInit() {
        List<String> messages = new ArrayList<>();
        if (workbook == null) {
            messages.add("Null workbook. No workbook has been parsed to PaymentFactory");
            return messages;
        }

        try {

            Sheet sh = workbook.getSheetAt(0);

            // Retreive company UEN for identification and token retreival 
            Cell uenCell = sh.getRow(0).getCell(1);
            UEN = getStringValue(uenCell);
            if (UEN == null || UEN.isEmpty()) {
                messages.add("Company UEN not detected in cell B1");
            }

            // Get Client name
            Cell clientNameCell = sh.getRow(0).getCell(4);
            excelClientName = getStringValue(clientNameCell);
            if (excelClientName == null || excelClientName.isEmpty()) {
                messages.add("Client name not detected in cell E1");
            }

            // Get charged account name 
            Cell chargedAccountNameCell = sh.getRow(0).getCell(7);
            chargedAccountName = getStringValue(chargedAccountNameCell);
            if (chargedAccountName == null || chargedAccountName.isEmpty()) {
                messages.add("Charged account name not detected in cell H1");
            }

            // Get charged account number
            Cell chargedAccountNumberCell = sh.getRow(0).getCell(8);
            chargedAccountNumber = (getStringValue(chargedAccountNumberCell) != null) ? Integer.valueOf(getStringValue(chargedAccountNumberCell).trim()) : 0;
            if (chargedAccountNumber == 0) {
                messages.add("Charged account number not detected in cell I1");
            }

            /**
             * To initialize all the Payment as single lined into a holding list
             * before iterating into a HashMap to combine multi-lined Payment
             * before returning into a list of Payment in prePayments
             */
            List<Payment> holdingList = new ArrayList<>();

            for (int i = 0; i < 1000; i++) {
                int xlRow = i + paymentStartLine;
                try {
                    // Initialize row
                    Row row = sh.getRow(xlRow);
                    Cell varCell;
                    if (row == null) {
                        messages.add("Unexpected empty row encounted in row " + xlRow + 1);
                        break;
                    }

                    // Create a new payment object
                    String paymentInitMessage = "Init: ";
                    Payment paymentObject = new Payment();
                    // Create PaymentLine
                    PaymentLine paymentLine = new PaymentLine();

                    // Set the chargedAccountNumber (required)
                    paymentObject.setChargedAccountNumber(chargedAccountNumber);
                    if (chargedAccountNumber == 0) {
                        paymentInitMessage += "Missing charged account number: ";
                    }

                    // Set the transaction date (required)
                    // If no dates, assume end of list
                    Date date = getDate(row.getCell(1));
                    if (date != null) {
                        paymentObject.setDate(date);
                    } else {
                        break;
                    }

                    // Set reference number (optional)
                    varCell = row.getCell(2);
                    String referenceNumber = getStringValue(varCell);
                    if (referenceNumber != null) {
                        paymentObject.setReferenceNumber(referenceNumber.trim());
                    }

                    // Set vendor (optional)
                    varCell = row.getCell(5);
                    String vendor = getStringValue(varCell);
                    if (vendor != null) {
                        paymentObject.setVendor(vendor);
                    }

                    // Set payment method (optional, null value will be defaulted to cash
                    varCell = row.getCell(xlRow);
                    String paymentMethod = getStringValue(varCell);
                    if (paymentMethod != null) {
                        paymentObject.setPaymentMethod(paymentMethod);
                    } else {
                        paymentObject.setPaymentMethod("Cash");
                    }

                    // Set memo (optional)
                    varCell = row.getCell(14);
                    String memo = getStringValue(varCell);
                    if (memo != null) {
                        paymentObject.setMemo(memo);
                    }

                    /**
                     * Payment Line Data
                     */
                    // Set Account Name (optional)
                    varCell = row.getCell(3);
                    String accountName = getStringValue(varCell);
                    if (accountName != null) {
                        paymentLine.setAccountName(accountName);
                    }

                    // Set Account Number (required)
                    varCell = row.getCell(4);
                    String accountNumber = getStringValue(varCell);
                    if (accountName != null) {
                        paymentLine.setAccountNumber(Integer.parseInt(accountNumber));
                    } else {
                        paymentLine.setAccountNumber(0);
                        paymentInitMessage += "Missing account number: ";
                    }

                    // Set line description (optional)
                    varCell = row.getCell(9);
                    String lineDescription = getStringValue(varCell);
                    if (lineDescription != null) {
                        paymentLine.setLineDescription(lineDescription);
                    }

                    // Set excl and incl line amounts (required)
                    try {
                        // Set amount excluding tax
                        String exclAmount = getStringValue(row.getCell(7));
                        if (exclAmount != null) {
                            paymentLine.setExTaxAmount(Double.valueOf(exclAmount.trim()));
                        } else {
                            paymentLine.setExTaxAmount(0.0);
                        }

                        // Set amount including tax
                        String inclAmount = getStringValue(row.getCell(8));
                        if (inclAmount != null) {
                            paymentLine.setIncTaxAmount(Double.valueOf(inclAmount.trim()));
                        } else {
                            paymentLine.setIncTaxAmount(0.0);
                        }
                    } catch (NumberFormatException nfe) {
                        paymentInitMessage += "Wrong number format: ";
                    }

                    // Set tax code (required)
                    varCell = row.getCell(6);
                    String taxCode = getStringValue(varCell);
                    if (taxCode != null) {
                        paymentLine.setTax(taxCode);
                    } else {
                        paymentInitMessage += "Missing tax number: ";
                    }

                    // Set line class (optional)
                    varCell = row.getCell(12);
                    String lineClass = getStringValue(varCell);
                    if (lineClass != null) {
                        paymentLine.setQBOLineClass(lineClass);
                    }

                    // Set line customer (optional)
                    varCell = row.getCell(13);
                    String lineCustomer = getStringValue(varCell);
                    if (lineCustomer != null) {
                        paymentLine.setQBOLineCustomer(lineCustomer);
                    }
                    
                    // Set init message
                    paymentLine.setInitStatus(paymentInitMessage);

                    // Add line to Payment
                    // Add status to Payment
                    List<PaymentLine> line = new ArrayList<>();
                    line.add(paymentLine);
                    paymentObject.setLines(line);

                    // Add Payment to holding list
                    holdingList.add(paymentObject);
                } catch (IndexOutOfBoundsException ibe) {
                    messages.add("Out of bounds error: " + ibe.getMessage());
                }
            }

            // Combine same reference number Payments
            Map<String, Payment> paymentMap = new HashMap<>();
            // Count the number of Payments with no reference number
            int nullReferenced = 0;
            for (Payment p2 : holdingList) {
                String ref = p2.getReferenceNumber();
                if (ref == null) {
                    paymentMap.put("amsNull" + nullReferenced, p2);
                    nullReferenced ++;
                } else {
                    Payment p1 = paymentMap.get(ref);
                    if (p1 == null) {
                        paymentMap.put(ref, p2);
                    } else {
                        List<PaymentLine> p1Lines = p1.getLines();
                        p1Lines.add(p2.getLines().get(0));
                        p1.setLines(p1Lines);
                        paymentMap.put(ref, p1);
                    }
                }
            }
            
            prePayments = new ArrayList<>(paymentMap.values());

        } catch (NullPointerException npe) {
            messages.add("NullPointerException found: " + npe.getMessage());
        } catch (Exception e) {
            messages.add("Exception found: " + e.getMessage());
        } finally {
            try {
                workbook.close();
            } catch (IOException IOE) {
                messages.add("IOException found: " + IOE.getMessage());
            }
        }

        return messages;
    }

    /**
     * Get the string value of the cell. If cell is a double or boolean, returns
     * a string representation of the cell value Returns null if invalid cell is
     * parsed
     *
     * @param cell
     * @return
     */
    public String getStringValue(Cell cell) {

        if (cell == null) {
            return null;
        }

        if (cell.getCellTypeEnum() != null) {
            CellType ct = (cell.getCellTypeEnum() != CellType.FORMULA)
                    ? cell.getCellTypeEnum() : cell.getCachedFormulaResultTypeEnum();
            switch (ct) {
                case STRING:
                    return cell.getStringCellValue(); //returns String
                case NUMERIC:
                    double d = cell.getNumericCellValue(); //returns double
                    return (d % 1 == 0.0)
                            ? String.format("%.0f", d) : String.valueOf(d);
                case BOOLEAN:
                    return String.valueOf(cell.getBooleanCellValue()); //returns boolean
                default:
                    return null;
            }
        }
        return null;
    }

    /**
     * Gets the date value of the cell. Utilizes excel double to date feature
     *
     * @param cell
     * @return
     */
    public Date getDate(Cell cell) {
        if (cell != null && cell.getCellTypeEnum() == CellType.NUMERIC) {
            return cell.getDateCellValue();
        } else {
            return null;
        }
    }

    /**
     * Returns a string representation of the date in the parsed cell. Return
     * null if the cell does not have a valid date
     *
     * @param cell
     * @return
     */
    public String getDateString(Cell cell) {
        Date date = getDate(cell);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return (date == null) ? null : sdf.format(date);
    }

    /**
     * Returns the number of payments objects in
     *
     * @return
     */
    public int getNumberOfPaymentObjects() {
        if (prePayments == null) {
            return 0;
        } else {
            return prePayments.size();
        }
    }

    /**
     * Constructor method for PaymentFactory
     *
     * @param workbook
     */
    public PaymentFactory(Workbook workbook) {
        this.workbook = workbook;
    }

    /**
     * Get the number of hours spent processing the Payment objects in this
     * object
     *
     * @return
     */
    public long getHoursTaken() {
        long hours;
        try {
            hours = ChronoUnit.HOURS.between(creationDate.toInstant(), completionDate.toInstant());
        } catch (NullPointerException npe) {
            npe.printStackTrace();
            return 0;
        }
        return hours;
    }

    public String getExcelClientName() {
        return excelClientName;
    }

    public void setExcelClientName(String excelClientName) {
        this.excelClientName = excelClientName;
    }

    public String getRealmid() {
        return realmid;
    }

    public void setRealmid(String realmid) {
        this.realmid = realmid;
    }

    public String getUEN() {
        return UEN;
    }

    public void setUEN(String UEN) {
        this.UEN = UEN;
    }

    public Calendar getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(Calendar completionDate) {
        this.completionDate = completionDate;
    }

    public List<Payment> getPrePayments() {
        return prePayments;
    }

    public void setPrePayments(List<Payment> prePayments) {
        this.prePayments = prePayments;
    }

    public List<Payment> getPostPayments() {
        return postPayments;
    }

    public void setPostPayments(List<Payment> postPayments) {
        this.postPayments = postPayments;
    }

    public String getChargedAccountName() {
        return chargedAccountName;
    }

    public void setChargedAccountName(String chargedAccountName) {
        this.chargedAccountName = chargedAccountName;
    }

    public int getChargedAccountNumber() {
        return chargedAccountNumber;
    }

    public void setChargedAccountNumber(int chargedAccountNumber) {
        this.chargedAccountNumber = chargedAccountNumber;
    }

    public long getTimeElapsed() {
        return timeElapsed;
    }

    public void setTimeElapsed(long timeElapsed) {
        this.timeElapsed = timeElapsed;
    }

    public List<String> getInitMessages() {
        return initMessages;
    }

    public void setInitMessages(List<String> initMessages) {
        this.initMessages = initMessages;
    }

    public List<String> getProcessMessages() {
        return processMessages;
    }

    public void setProcessMessages(List<String> processMessages) {
        this.processMessages = processMessages;
    }

    public Token getToken() {
        return token;
    }

    public void setToken(Token token) {
        this.token = token;
    }

    
    
}
