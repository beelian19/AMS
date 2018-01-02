/**
 * Version 1.0
 * - only xlsx file supported
 * This object replaces the excel object
 * Parse the excel file or whatever medium that is used to process all digital expenses into this object to hold the information.
 * This is to facilitate multiple accounting software to utilize this object
 * More constructor methods can be created to initialize other types of files
 */
package Module.Expense;

import Entity.Expense;
import Entity.Token;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class ExpenseFactory {

    private Workbook workbook;
    private String clientName;
    private String realmid;
    private Calendar created;
    private List<Expense> expenses;
    private List<String> messages;
    private List<String> processMessages;
    private String UEN;
    private String chargedAccountName;
    private int chargedAccountNumber;
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
        xlsxInit();
        created = Calendar.getInstance();

        return UEN != null && expenses != null && chargedAccountNumber != 0;
    }

    /**
     * Initializing method used by init() to read the data in a xlsx file
     * Creates a list of Expense objects that are in the variable expenses
     *
     * @return
     */
    private void xlsxInit() {
        messages = new ArrayList<>();
        try {
            Sheet sh = workbook.getSheetAt(0);
            Cell cell = sh.getRow(0).getCell(0);

            // Get company UEN
            UEN = getStringValue(cell);
            if (UEN == null) {
                messages.add("UEN not detected");
            }

            // Get charged account name
            cell = sh.getRow(1).getCell(11);
            chargedAccountName = getStringValue(cell);
            if (chargedAccountName == null) {
                messages.add("Charged account name not detected");
            }

            // Get charged account number
            cell = sh.getRow(2).getCell(11);
            chargedAccountNumber = (getStringValue(cell) != null) ? Integer.valueOf(getStringValue(cell).trim()) : 0;
            if (chargedAccountNumber == 0) {
                messages.add("Charged account name not detected");
            }

            // Init expenses
            expenses = new ArrayList<>();

            int xlRowNumber;
            Row row;
            String strValue;
            // Create Expense objects
            for (int i = 0; i < 200; i++) {

                try {
                    xlRowNumber = i + 5;
                    row = sh.getRow(xlRowNumber);

                    if (row == null) {
                        messages.add("Unexpected row number encountered: " + xlRowNumber);
                        break;
                    }

                    // Initialize a new expense object
                    Expense expense = new Expense();

                    // Set charged account numebr
                    if (chargedAccountNumber != 0) {
                        expense.setChargedAccountNumber(chargedAccountNumber);
                    }

                    // Set the row number
                    expense.setRowNumber(i + 1);

                    // Set the transaction date
                    Date date = getDate(row.getCell(1));
                    if (date != null) {
                        expense.setDate(date);
                    }

                    // Set charged account number
                    strValue = getStringValue(row.getCell(3));
                    if (strValue != null) {
                        expense.setAccountNumber(Integer.valueOf(strValue));
                    }

                    // Set charged account name
                    strValue = getStringValue(row.getCell(5));
                    if (strValue != null) {
                        expense.setAccountName(strValue);
                    }

                    // Set description
                    strValue = getStringValue(row.getCell(7));
                    if (strValue != null) {
                        expense.setDescription(strValue);
                    }

                    // Set vendor
                    strValue = getStringValue(row.getCell(11));
                    if (strValue != null) {
                        expense.setVendor(strValue);
                    }

                    // Set reference number
                    strValue = getStringValue(row.getCell(13));
                    if (strValue != null) {
                        expense.setReference(strValue);
                    }

                    // Set location
                    strValue = getStringValue(row.getCell(15));
                    if (strValue != null) {
                        expense.setLocation(strValue);
                    }

                    // Set payment method
                    strValue = getStringValue(row.getCell(17));
                    if (strValue != null) {
                        expense.setPaymentMethod(strValue);
                    }

                    // Set tax code
                    strValue = getStringValue(row.getCell(21));
                    if (strValue != null) {
                        expense.setTax(strValue);
                    }

                    try {
                        // Set amount excluding tax
                        strValue = getStringValue(row.getCell(19));
                        if (strValue != null) {
                            expense.setExTaxAmount(Double.valueOf(strValue.trim()));
                        }

                        // Set amount including tax
                        strValue = getStringValue(row.getCell(23));
                        if (strValue != null) {
                            expense.setIncTaxAmount(Double.valueOf(strValue.trim()));
                        }
                    } catch (NumberFormatException nfe) {
                        messages.add("NumberFormatException found at xl row " + (xlRowNumber + 1));
                    }

                    // Set memo
                    strValue = getStringValue(row.getCell(25));
                    if (strValue != null) {
                        expense.setMemo(strValue);
                    }

                    if (!expense.checkComplete()) {
                        messages.add("Incomplete expense at xl row " + (xlRowNumber + 1));
                    }
                } catch (IndexOutOfBoundsException ibe) {
                    messages.add("Out of bounds error: " + ibe.getMessage());
                }
            }

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
     * Gets the String value of a cell only if the CellType is STRING, else
     * returns null
     *
     * @param cell
     * @return
     */
    public String getStringValuedCell(Cell cell) {
        if (cell.getCellTypeEnum() == CellType.STRING) {
            return getStringValue(cell);
        } else {
            return null;
        }
    }

    /**
     * Constructor for ExpenseFactory
     *
     * @param workbook
     */
    public ExpenseFactory(Workbook workbook) {
        this.workbook = workbook;
    }

    /**
     * Getter method for the list of expenses Ensure to init() the expenses list
     * first
     *
     * @return
     */
    public List<Expense> getExpenses() {
        return expenses;
    }

    /**
     * Setter method for the list of expenses after execution
     *
     * @param expenses
     */
    public void setExpenses(List<Expense> expenses) {
        this.expenses = expenses;
    }

    /**
     * Getter method for the UEN number
     *
     * @return String
     */
    public String getUEN() {
        return UEN;
    }

    /**
     * Getter method for the charged account name
     *
     * @return
     */
    public String getChargedAccountName() {
        return chargedAccountName;
    }

    /**
     * Getter method for init() messages
     *
     * @return
     */
    public List<String> getMessages() {
        return messages;
    }

    /**
     * Getter method for the charged account number
     *
     * @return
     */
    public int getChargedAccountNumber() {
        return chargedAccountNumber;
    }

    /**
     * Getter method for the the date the expense factory was initialized
     *
     * @return
     */
    public Calendar getCreated() {
        return created;
    }

    /**
     * Getter method for the client name
     *
     * @return
     */
    public String getClientName() {
        return clientName;
    }

    /**
     * Setter method for the client name
     *
     * @param clientName
     */
    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public Token getToken() {
        return token;
    }

    public void setToken(Token token) {
        this.token = token;
    }

    public List<String> getProcessMessages() {
        return processMessages;
    }

    public void setProcessMessages(List<String> processMessages) {
        this.processMessages = processMessages;
    }

    public String getRealmid() {
        return realmid;
    }

    public void setRealmid(String realmid) {
        this.realmid = realmid;
    }
    
    

    
    
}
