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
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class ExpenseFactory {

    private Workbook workbook;
    private List<Expense> expenses;
    private String UEN;
    private String chargedAccountName;
    private int chargedAccountNumber;

    /**
     * Initializes all the required information for expenses and returns a List
     * of Strings for status and error handling
     *
     * @return
     */
    public List<String> init() {
        //Version 1.0 only support xlsx file. Change here with more wrapper methods and
        //Switch statements to add in more file types
        return xlsxInit();
    }

    /**
     * Initializing method used by init() to read the data in a xlsx file
     * Creates a list of Expense objects that are in the variable expenses
     *
     * @return
     */
    private List<String> xlsxInit() {
        List<String> messages = new ArrayList<>();
        try {
            Sheet sh = workbook.getSheetAt(0);
            Cell cell = sh.getRow(0).getCell(0);

            // Get company UEN
            UEN = getStringValue(cell);
            
            // Get charged account name
            cell = sh.getRow(1).getCell(11);
            chargedAccountName = getStringValue(cell);
            
            // Get charged account number
            cell = sh.getRow(2).getCell(11);
            chargedAccountNumber = (getStringValue(cell)!=null) ? Integer.valueOf(getStringValue(cell).trim()) : 0;
            
            // Init expenses
            expenses = new ArrayList<>();
            
            // Create Expense objects
            for (int i = 0; i < 200; i++) {
                Expense expense = new Expense();
                
                // Set the row number
                expense.setRowNumber(i);
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
        if (cell.getCellTypeEnum() != null) {
            CellType ct = (cell.getCellTypeEnum() != CellType.FORMULA)
                    ? cell.getCellTypeEnum() : cell.getCachedFormulaResultTypeEnum();
            switch (ct) {
                case STRING:
                    return cell.getStringCellValue(); //returns String
                case NUMERIC:
                    double d = cell.getNumericCellValue(); //returns double
                    return (d % 1 == 0)
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
     * Getter method for the UEN number
     * @return String
     */
    public String getUEN() {
        return UEN;
    }

    /**
     * Getter method for the charged account name
     * @return 
     */
    public String getChargedAccountName() {
        return chargedAccountName;
    }
    
    

}
