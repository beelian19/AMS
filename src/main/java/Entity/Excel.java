package Entity;

import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

/**
 *
 * A workbook is valid if it has its primary attributes.
 * It is only initialized if it is both valid and has proper line items
 * 
 */
public class Excel {

    public Boolean getIsValid() {
        return isValid;
    }

    public void setIsValid(Boolean isValid) {
        this.isValid = isValid;
    }

    public Boolean getInitialized() {
        return initialized;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getChargedAccountName() {
        return chargedAccountName;
    }

    public String getChargedAccountNumber() {
        return chargedAccountNumber;
    }

    public int getNumberOfInvoices() {
        return numberOfInvoices;
    }

    public String getFromDate() {
        return fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public Object[][] getLineItems() {
        return lineItems;
    }

    public int getLineItemsCount() {
        return lineItemsCount;
    }
    
    private Workbook workbook;
    private Boolean isValid;
    private Boolean initialized;
    private Sheet invoiceSheet;
    // Invoices primary attribute
    private String companyName;
    private String chargedAccountName;
    private String chargedAccountNumber;
    private int numberOfInvoices;
    private String fromDate;
    private String toDate;
    //Number of invoices should be equal to size of lineItems
    private Object[][] lineItems;
    private int lineItemsCount;
    
    //Temporary variables
    private Cell cell;
    private Row row;
    //This is the start of line items in the 0 based excel book
    private int lineStart = 5;
    private int rowNumber;
    private Double accountNumber;
    private Double amount;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private Boolean lineSuccess;
    private Object holder;
    
    /**
     * 
     * @param cell
     * @return string value of cell. If cell is not String based return null
     */
    public String getStringCellValue(Cell cell){
        if (null != cell.getCellTypeEnum()) switch (cell.getCellTypeEnum()) {
            case STRING:
                return cell.getStringCellValue();
            default:
                return null;
        } else return null;
    }
    
    /**
     * 
     * @param cell
     * @return null if cell is blank or null
     * @returns String, Double, Boolean or null
     */
    public Object getRawCellValue(Cell cell){
        if (cell==null) return null;
        CellType cellType = cell.getCellTypeEnum();
        if (cellType == CellType.FORMULA){
            cellType = cell.getCachedFormulaResultTypeEnum();
        }
        if (null != cellType) {
            switch (cellType) {
                case BLANK:
                    return null;
                case STRING:
                    return cell.getStringCellValue(); //returns String
                case NUMERIC:
                    return cell.getNumericCellValue(); //returns double
                case BOOLEAN:
                    return cell.getBooleanCellValue(); //returns boolean
                default:
                    return null;
            }
        }
        return null;
    }
    
    
    /**
     * Checks if workbook is valid for processing
     * 1. Exactly 2 sheets in the workbook
     * 2. Company name and account number are present
     * @return boolean
     */
    private Boolean checkWorkbook(){
        //Ensure exactly 2 sheets
        if (workbook == null || workbook.getNumberOfSheets() != 2) return false;
        invoiceSheet = workbook.getSheetAt(0);
        return (!isSheetEmpty(invoiceSheet));
    }
    
    /**
     * Cells to check in 0-based sheet are
     * Cell Row 1 Column 4 (String)
     * and Cell Row 2 Column 11 (Double)
     * @param sheet
     * @return boolean by checking certain cells are empty
     */
    private Boolean isSheetEmpty(Sheet sheet){
        Cell name;
        Cell accNumber;
        //Ensure that the row is not null

        if(sheet.getRow(1)==null || sheet.getRow(2)==null) return true;

        name = sheet.getRow(1).getCell(4);
        accNumber = sheet.getRow(2).getCell(11);
        //Ensure that the cells are not null
        if (name==null||accNumber==null) return true;

        //Ensure that the cell types are correct
        //Return false if not empty
        return (name.getCellTypeEnum()!=CellType.STRING | 
                        accNumber.getCellTypeEnum()!=CellType.FORMULA);
    }
    
    /**
     * Initializes primary invoices attributes 
     * @return success of initialization
     */
    public String initialize(){
        
        invoiceSheet = workbook.getSheetAt(0);
        
        if(!isValid | invoiceSheet==null) {
            initialized = false;
            return "Workbook is not valid/checked";
        }
        String errors = "";
        
        //Get company name
        cell = invoiceSheet.getRow(1).getCell(4);
        companyName = getStringCellValue(cell);
        if (companyName == null) errors += "|Null company name at row 2 Col 6|";
        
        //Get charged account name
        cell = invoiceSheet.getRow(1).getCell(11);
        chargedAccountName = getStringCellValue(cell);
        if (chargedAccountName == null) 
            errors += "|Null account name at row 2 Col 12|";
        
        //Get charged account number
        cell = invoiceSheet.getRow(2).getCell(11);
        if (cell.getCellTypeEnum() != CellType.FORMULA) {
            chargedAccountNumber = null;
            errors += "|Null account number at row 3 Col 12|";
        } else {
            holder = getRawCellValue(cell);
            if (holder instanceof Double){
                chargedAccountNumber = String.format("%.0f", (Double) holder);
            } else {
                chargedAccountNumber = holder.getClass().getName();
                errors += "|Account number at row 3 Col 12 are not numbers|";
            }
        }
        
        //Get number of invoices
        cell = invoiceSheet.getRow(1).getCell(25);
        if (cell.getCellTypeEnum() != CellType.FORMULA) {
            numberOfInvoices = 0;
            errors += "|Null number of invoice row 2 Col 26|";
        } else {
            holder = getRawCellValue(cell);
            if (holder instanceof Double){
                Double numInvoices = (Double) holder;
                numberOfInvoices = numInvoices.intValue();
            } else {
                numberOfInvoices = 0;
                errors += "|number of invoice row 2 Col 26 are not numbers|";
            }
        }
        
        //Get from date and to date
        cell = invoiceSheet.getRow(1).getCell(18);
        if (cell.getCellTypeEnum() != CellType.NUMERIC){
            fromDate = null;
            errors += "|Null from date at row 2 Col 19|";
        } else {
            Date date = cell.getDateCellValue();
            fromDate = sdf.format(date);
        }
        
        cell = invoiceSheet.getRow(2).getCell(18);
        if (cell.getCellTypeEnum() != CellType.NUMERIC){
            toDate = null;
            errors += "|Null at date at row 3 Col 19|";
        } else {
            Date date = cell.getDateCellValue();
            toDate = sdf.format(date);
        }
        
        /*
        0  - row numebr
        1  - transaction date
        2  - Account number
        3  - Account name
        4  - Expense Description
        5  - Payee/Vendor name
        6  - Reference number
        7  - Location
        8  - Payment Method
        9  - Amount (Excluding tax)
        10 - Tax Code
        11 - Amount (Including tax)
        12 - Memo
        13 - Line filled (1 for automation. 0 for manual)
        */
        lineItems = new String[200][14];
        lineItemsCount = 0;
        for (int i = 0; i < 200; i++){
            lineSuccess = true;
            rowNumber = i + lineStart;
            row = invoiceSheet.getRow(rowNumber);
            if (row == null) {
                errors += "|Unexpected row number encountered for line items|";
                break;
            }
            
            
            // transaction date
            cell = row.getCell(1);
            if (cell==null || cell.getCellTypeEnum() != CellType.NUMERIC) {
                break;
            } else if (cell.getNumericCellValue()>40000.0){
                Date date = cell.getDateCellValue();
                lineItems[i][1] = sdf.format(date);
            } else {
                lineItems[i][1] = cell.getNumericCellValue();
                lineSuccess = false;
            }            
            
            // row number
            lineItems[i][0] = (i+1)+"";
            
            // acount Number
            cell = row.getCell(3);
            if (cell==null || cell.getCellTypeEnum() != CellType.FORMULA) {
                lineSuccess = false;
                lineItems[i][2] = "not formmula";
            } else {
                holder = getRawCellValue(cell);
                if (holder instanceof Double) {
                    accountNumber = (Double) getRawCellValue(cell);
                    lineItems[i][2] = String.format("%.0f", accountNumber);
                } else {
                    lineSuccess = false;
                    lineItems[i][2] = "not numbers: " + 
                                        holder.getClass().getName();
                }
            }
            
            // account name
            cell = row.getCell(5);
            if (cell==null || cell.getCellTypeEnum() != CellType.STRING){
                lineSuccess = false;
            } else {
                lineItems[i][3] = getStringCellValue(cell);
            }
            
            // expense description
            cell = row.getCell(7);
            if (cell!=null){
                lineItems[i][4] = getStringCellValue(cell);
            }
            
            // payee/vendor name
            cell = row.getCell(11);
            if (cell==null|| cell.getCellTypeEnum() != CellType.STRING){
                lineSuccess = false;
            } else {
                lineItems[i][5] = getStringCellValue(cell);
            }
            
            // reference number
            cell = row.getCell(13);
            if (cell!=null){
                lineItems[i][6] = getStringCellValue(cell);
            } else {
                lineItems[i][6] = "";
            }
            
            // location
            cell = row.getCell(15);
            if (cell!=null){
                lineItems[i][7] = getStringCellValue(cell);
            } else {
                lineItems[i][7] = "";
            }
            
            // payment method
            cell = row.getCell(17);
            if (cell==null|| cell.getCellTypeEnum() != CellType.STRING){
                lineSuccess = false;
            } else {
                lineItems[i][8] = getStringCellValue(cell);
            }
            
            // amount excluding tax
            cell = row.getCell(19);
            if (cell==null || cell.getCellTypeEnum() != CellType.NUMERIC) {
                lineSuccess = false;
            } else {
                amount = (Double) getRawCellValue(cell);
                if (amount>0){
                    lineItems[i][9] = amount.toString();
                } else {
                    lineItems[i][9] = amount.toString();
                    lineSuccess = false;
                }
            }
            
            // tax code
            cell = row.getCell(21);
            if (cell==null|| cell.getCellTypeEnum() != CellType.STRING){
                lineSuccess = false;
            } else {
                lineItems[i][10] = getStringCellValue(cell);
            } 
            
            // amount including tax
            cell = row.getCell(23);
            if (cell==null || cell.getCellTypeEnum() != CellType.FORMULA) {
                lineSuccess = false;
            } else {
                amount = (Double) getRawCellValue(cell);
                if (amount>0){
                    lineItems[i][11] = amount.toString();
                } else {
                    lineItems[i][11] = amount.toString();
                    lineSuccess = false;
                }
            }
            
            // memo
            cell = row.getCell(25);
            if (cell!=null){
                lineItems[i][12] = getStringCellValue(cell);
            } else {
                lineItems[i][12] = null;
            }   
            /*
            Sets the value of the last array in the row to 1 if line is valid
            and 0 if not valid
            */
            lineItems[i][13] = (lineSuccess) ? "1":"0";
            if (lineSuccess) lineItemsCount += 1;
        }
        
        /*    
        //Number of invoices should be equal to size of lineItems
        private Object[][] lineItems;*/
        if (!errors.equals("")){
            initialized = false;
            return errors;
        } else{
            initialized = true;
            return "Success";
        }
    }

    
    /**
     * Sets the parsed workbook attribute for the Excel object
     * @param workbook 
     */
    public void setWorkbook(Workbook workbook){
        this.workbook = workbook;
    }
    
    /**
     * Initializes an empty Excel object
     */
    public Excel(){
        workbook = null;
        isValid = false;
        initialized = false;
    }
    
    /**
     * Initializes an Excel object and setting the isValid Boolean attribute
     * @param workbook 
     */
    public Excel(Workbook workbook){
        this.workbook = workbook;
        isValid = false;
        initialized = false;
    }

    
    
}
