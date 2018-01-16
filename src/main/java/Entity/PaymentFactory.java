/**
 * Version 2.0
 * - only xlsx file is supported. This factory takes in an xlsx file and converts it into Abundant Payment Object
 *  The Payment Object should be able to hold various accounting software, to be built in future iterations
 */
package Entity;

import java.util.Calendar;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Workbook;

public class PaymentFactory {
    private Workbook workbook;
    private String excelClientName;
    private String realmid;
    private String UEN;
    private Calendar creationDate;
    private List<Payment> prePayments;
    private String chargedAccountName;
    private int chargedAccountNumber;
    private List<String> messages;
    private Token token;
    
    
    
    /**
     * Get the string value of the cell. If cell is a double or boolean, returns
     * a string representation of the cell value Returns null if invalid cell is
     * parsed
     *
     * @param cell
     * @return
     */
    public String getStringValue(Cell cell) {
        
        if (cell == null) return null;
        
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
}
