/*
 * The general design is that the QBODAO will load all the accounts, taxcode etc
 * so as to return a Purchase Object so that we can do row by row processing as
 * efficiently as possible. It would require another DAO to process each excel 
 * line to parse into QBODAO to return the Purcahse object, where data 
 * validation is performed on both sides to ensure maximum security
 */
package DAO;

import Entity.Expense;
import com.intuit.ipp.core.IEntity;
import com.intuit.ipp.data.Account;
import com.intuit.ipp.data.AccountBasedExpenseLineDetail;
import com.intuit.ipp.data.AccountTypeEnum;
import com.intuit.ipp.data.Department;
import com.intuit.ipp.data.GlobalTaxCalculationEnum;
import com.intuit.ipp.data.Line;
import com.intuit.ipp.data.LineDetailTypeEnum;
import com.intuit.ipp.data.PaymentMethod;
import com.intuit.ipp.data.PaymentTypeEnum;
import com.intuit.ipp.data.Purchase;
import com.intuit.ipp.data.ReferenceType;
import com.intuit.ipp.data.TaxCode;
import com.intuit.ipp.data.Vendor;
import com.intuit.ipp.exception.FMSException;
import com.intuit.ipp.services.DataService;
import com.intuit.ipp.services.QueryResult;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author Icon
 */
public class QBODAO {

    // DataService
    private DataService dataService;
    private List<Vendor> vendors;
    private List<Account> bankAccounts;
    private List<Account> expenseAccounts;
    private List<TaxCode> taxCodes;
    private List<PaymentMethod> paymentMethods;
    private List<Department> departments;
    private String initError = "";
    private Boolean initHasError = false;

    // Double values for the various taxes
    private Double taxValue = 0.07;
    private Double noTaxValue = 0.00;

    // Fields for a complete Purchase object
    private ReferenceType reference;
    private ReferenceType imReference;
    private ReferenceType txReference;
    private ReferenceType nrReference;
    private PaymentTypeEnum pte;
    private int rowNumber;
    private Date date;
    private String txnDate;
    private String txnReferenceNumber;
    private String txnLocation;
    private String txnMemo;
    private String txnDescription;
    private String txnAccountChargedNumber;
    private String txnPaymentMethod;
    private String txnSupplierName;
    private String txnTaxCode;
    private String txnAmountString;
    private String txnTotalAmountString;
    private Double txnAmount;

    String[][] returnList;

    public String[][] getReturnList() {
        return returnList;
    }

    // Queries
    private final String ACCOUNT_TYPE_QUERY = "select * from account where accounttype = '%s'";

    /**
     * Type-generic query method which returns the whole list from a query and
     * casts it to the desired type.
     *
     * @param dataService
     * @param query
     * @param qboType
     * @return List<IEntity>
     */
    private List<? extends IEntity> executeQueryList(DataService dataService,
            String query, Class<?> qboType) {
        try {
            final QueryResult queryResult = dataService.executeQuery(query);
            final List<? extends IEntity> entities = queryResult.getEntities();
            if (entities.isEmpty()) {
                return null;
            } else {
                return entities;
            }
        } catch (FMSException ex) {
            throw new RuntimeException("Failed to execute list query: "
                    + query, ex);
        }
    }

    public Boolean getInitHasError() {
        return initHasError;
    }

    /**
     * Type-generic query method which returns only the first result from a
     * query and casts it to the desired type.
     */
    private <T extends IEntity> T executeQuery(String query, Class<T> qboType) {
        try {
            final QueryResult queryResult = dataService.executeQuery(query);
            final List<? extends IEntity> entities = queryResult.getEntities();
            if (entities.isEmpty()) {
                return null;
            } else {
                final IEntity entity = entities.get(0);
                return (T) entity;
            }
        } catch (FMSException e) {
            throw new RuntimeException("Failed to execute an entity query: "
                    + query, e);
        }
    }

    /**
     * Finds a List of Accounts based on the accountType
     *
     * @param accountType
     * @return
     */
    private List<Account> findAccountsByType(AccountTypeEnum accountType) {
        String query = String.format(ACCOUNT_TYPE_QUERY, accountType.value());
        return (List<Account>) executeQueryList(dataService,
                query, com.intuit.ipp.data.Account.class);
    }

    /**
     * 
     */
    private List<Department> findAllDepartments(){
        String query = "select * from department";
        return (List<Department>) executeQueryList(dataService, query,
                com.intuit.ipp.data.Department.class);
    }
    
    /**
     * Finds all the vendors (suppliers) from the parsed QBO account
     *
     * @return List<Vendor>
     */
    private List<Vendor> findAllVendors() {
        String query = "select * from vendor";
        return (List<Vendor>) executeQueryList(dataService, query,
                com.intuit.ipp.data.Vendor.class);
    }

    /**
     * Finds all the tax codes from the parsed QBO account
     *
     * @return List<TaxCode>
     */
    private List<TaxCode> findAllTaxCodes() {
        String query = "select * from taxcode";
        return (List<TaxCode>) executeQueryList(dataService, query,
                com.intuit.ipp.data.TaxCode.class);
    }

    /**
     * Finds all the tax codes from the parsed QBO account
     *
     * @return List<PaymentMethod>
     */
    private List<PaymentMethod> findAllPaymentMethods() {
        String query = "select * from paymentmethod";
        return (List<PaymentMethod>) executeQueryList(dataService, query,
                com.intuit.ipp.data.PaymentMethod.class);
    }

    /**
     *
     * @param txnSupplierName
     * @return
     */
    private ReferenceType getVendorReference(String txnSupplierName) {
        if (!vendors.isEmpty()) {
            Iterator<Vendor> itr = vendors.iterator();
            while (itr.hasNext()) {
                Vendor ven = itr.next();
                if (ven != null && ven.getDisplayName() != null) {
                    if (ven.getDisplayName().equals(txnSupplierName)) {
                        ReferenceType venref = new ReferenceType();
                        venref.setValue(ven.getId());
                        return venref;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getBankReference(String txnAccountChargedNumber) {
        if (!bankAccounts.isEmpty()) {
            Iterator<Account> itr = bankAccounts.iterator();
            while (itr.hasNext()) {
                Account account = itr.next();
                if (account != null && account.getAcctNum() != null) {
                    if (account.getAcctNum().equals(txnAccountChargedNumber)) {
                        ReferenceType bankRef = new ReferenceType();
                        bankRef.setValue(account.getId());
                        return bankRef;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getExpenseAccountReference(String expenseAccountNumber) {
        if (!expenseAccounts.isEmpty()) {
            Iterator<Account> itr = expenseAccounts.iterator();
            while (itr.hasNext()) {
                Account account = itr.next();
                if (account != null && account.getAcctNum() != null) {
                    if (account.getAcctNum().equals(expenseAccountNumber)) {
                        ReferenceType accRef = new ReferenceType();
                        accRef.setValue(account.getId());
                        return accRef;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getPaymentMethodReference(String paymentMethod) {
        if (!paymentMethods.isEmpty()) {
            Iterator<PaymentMethod> itr = paymentMethods.iterator();
            while (itr.hasNext()) {
                PaymentMethod pm = itr.next();
                if (pm != null && pm.getName() != null) {
                    if (pm.getName().equals(paymentMethod)) {
                        ReferenceType pmRef = new ReferenceType();
                        pmRef.setValue(pm.getId());
                        return pmRef;
                    }
                }
            }
        }
        return null;
    }

    private Boolean initializeTaxcodeReferences() {
        if (!taxCodes.isEmpty()) {
            Iterator<TaxCode> itr = taxCodes.iterator();
            while (itr.hasNext()) {
                TaxCode tc = itr.next();
                if (tc != null && tc.getName() != null) {
                    if (tc.getName().contains("NR") && nrReference == null) {
                        nrReference = new ReferenceType();
                        nrReference.setValue(tc.getId());
                    } else if (tc.getName().contains("TX") && txReference == null) {
                        txReference = new ReferenceType();
                        txReference.setValue(tc.getId());
                    } else if (tc.getName().contains("IM") && imReference == null) {
                        imReference = new ReferenceType();
                        imReference.setValue(tc.getId());
                    }
                }
            }
        }
        return imReference != null && txReference != null && nrReference != null;
    }

    public List<Expense> submitListOfExpenses(List<Expense> expenses) {
        List<Expense> processedExpenses = new ArrayList<>();
        
        if (!initializeTaxcodeReferences()) {
            processedExpenses.add(new Expense("Tax Code init failed"));
        }
        
        ReferenceType bankReference;
        
        Expense e = expenses.get(0);
        bankReference = getBankReference(String.valueOf(e.getChargedAccountNumber()));
        
        if (bankReference == null) {
            processedExpenses.add(new Expense("No bank reference with account number: " + e.getChargedAccountNumber()));
        }
        
        // if there are errors
        if (!processedExpenses.isEmpty()) {
            return processedExpenses;
        }
        
        for (Expense ex : expenses) {
            
        
        }
        
        return processedExpenses;
    }
    
    /**
     * PaymentTypeEnum is hard coded for now Returns a multi dimension array of
     * 3 0 - row number 1 - 0 for failed, non 0 for success 2 - Reasons, if any,
     * for failure
     *
     * @param lineItems
     * @param chargedAccountNumber
     * @return
     */
    public String[][] submitLineItemsForAccount(Object[][] lineItems, String chargedAccountNumber) {
        // Returns initialization errors
        if (initHasError) {
            returnList = new String[1][1];
            returnList[0][0] = initError;
            return returnList;
        }
        if (!initializeTaxcodeReferences()) {
            returnList = new String[1][1];
            returnList[0][0] = "Tax Code init failed";
            return returnList;
        }
        int processed = 0;
        int error = 0;
        ReferenceType bankReference;
        ReferenceType vendorReference;
        ReferenceType pmReference;
        ReferenceType expenseAccountReference;
        Boolean hasTax;
        BigDecimal excTaxAmount;
        BigDecimal totalAmount;
        BigDecimal taxedAmount;

        //Load bank account
        bankReference = getBankReference(chargedAccountNumber);
        if (bankReference == null) {
            returnList = new String[1][1];
            returnList[0][0] = "Null bank account number";
            return returnList;
        }

        //Load tax codes
        // the addition of 1 is to let returnList[0] be empty for comments
        returnList = new String[lineItems.length + 1][3];

        for (Object[] lineRow : lineItems) {
            String debug = "";
            hasTax = false;
            if (lineRow[1] == null || lineRow[13] == null) {
                break;
            }
            //Set the row number
            rowNumber = Integer.parseInt((String) lineRow[0]);
            //Set the row number
            returnList[rowNumber][0] = String.valueOf(rowNumber);
            if (Integer.parseInt((String) lineRow[13]) == 1) {

                txnDate = (String) lineRow[1];
                txnAccountChargedNumber = (String) lineRow[2];
                txnDescription = (lineRow[4] == null) ? "" : (String) lineRow[4];
                txnSupplierName = (String) lineRow[5];
                txnReferenceNumber = (lineRow[6] == null) ? "" : (String) lineRow[6];
                txnLocation = (lineRow[7] == null) ? "" : (String) lineRow[7];
                txnPaymentMethod = (String) lineRow[8];
                txnAmountString = (String) lineRow[9];
                txnTaxCode = (String) lineRow[10];
                txnTotalAmountString = (String) lineRow[11];
                txnMemo = (lineRow[12] == null) ? "" : (String) lineRow[12];

                Purchase purchase = new Purchase();

                purchase.setDomain("QBO");

                //Set payment method & payment type
                pmReference = getPaymentMethodReference(txnPaymentMethod);
                if (pmReference != null) {
                    purchase.setPaymentMethodRef(pmReference);
                } else {
                    debug += "-paymentmethodref-";
                }

                if (txnPaymentMethod.contains("redit")) {
                    purchase.setPaymentType(PaymentTypeEnum.CREDIT_CARD);
                } else if (txnPaymentMethod.contains("ash")) {
                    purchase.setPaymentType(PaymentTypeEnum.CASH);
                } else if (txnPaymentMethod.contains("heque")) {
                    purchase.setPaymentType(PaymentTypeEnum.CHECK);
                } else {
                    purchase.setPaymentType(PaymentTypeEnum.CASH);
                }

                //Set bank account
                purchase.setAccountRef(bankReference);

                //Set memo
                purchase.setPrivateNote(txnMemo);

                //Set reference
                purchase.setDocNumber(txnReferenceNumber);

                //location - incomplete
                //Set vendor
                vendorReference = getVendorReference(txnSupplierName);
                if (vendorReference != null) {
                    purchase.setEntityRef(vendorReference);
                } else {
                    debug += "-vendorreference-";
                }

                //Set tax
                purchase.setGlobalTaxCalculation(GlobalTaxCalculationEnum.TAX_EXCLUDED);

                Line line = new Line();

                excTaxAmount = new BigDecimal(txnAmountString).setScale(2, BigDecimal.ROUND_HALF_UP);
                totalAmount = new BigDecimal(txnTotalAmountString).setScale(2, BigDecimal.ROUND_HALF_UP);
                
                line.setDescription(txnDescription);
                
                
                line.setAmount(excTaxAmount);
                line.setDetailType(LineDetailTypeEnum.ACCOUNT_BASED_EXPENSE_LINE_DETAIL);
                AccountBasedExpenseLineDetail abeld = new AccountBasedExpenseLineDetail();

                expenseAccountReference = getExpenseAccountReference(txnAccountChargedNumber);
                if (expenseAccountReference != null) {
                    abeld.setAccountRef(expenseAccountReference);
                } else {
                    debug += "-expenseaccountreference-";
                }

                if (txnTaxCode.contains("TX")) {
                    abeld.setTaxCodeRef(txReference);
                    hasTax = true;
                } else if (txnTaxCode.contains("NR")) {
                    abeld.setTaxCodeRef(nrReference);
                } else if (txnTaxCode.contains("IM")) {
                    abeld.setTaxCodeRef(imReference);
                    hasTax = true;
                } else {
                    debug += "-taxcode-";
                }

                if (hasTax) {
                    taxedAmount = totalAmount.subtract(excTaxAmount);
                    abeld.setTaxAmount(taxedAmount);
                    abeld.setTaxInclusiveAmt(totalAmount);
                    //update totalAmount
                }

                purchase.setTotalAmt(totalAmount);
                line.setAccountBasedExpenseLineDetail(abeld);
                List<Line> lineList = new ArrayList<Line>();
                lineList.add(line);
                purchase.setLine(lineList);

                try {
                    //Set transaction date
                    date = new SimpleDateFormat("yyyy-MM-dd").parse(txnDate);
                    purchase.setTxnDate(date);

                    //Debug
                    if (!debug.equals("")) {
                        returnList[rowNumber][1] = "debug";
                        returnList[rowNumber][2] = debug;
                        error += 1;
                        continue;
                    }

                    Purchase savedPurchase = dataService.add(purchase);
                    returnList[rowNumber][1] = savedPurchase.getId();
                    returnList[rowNumber][2] = "Success";
                    processed += 1;
                } catch (FMSException ex) {
                    returnList[rowNumber][1] = "0";
                    returnList[rowNumber][2] = "Error in adding this row: ";
                    List<com.intuit.ipp.data.Error> list = ex.getErrorList();
                    for (com.intuit.ipp.data.Error er : list) {
                        returnList[rowNumber][2] += er.getMessage();
                    }
                    error += 1;
                } catch (ParseException ex) {
                    returnList[rowNumber][1] = "0";
                    returnList[rowNumber][2] = "Error in adding this row: Parse Date";
                    error += 1;
                } catch (NullPointerException ex) {
                    returnList[rowNumber][1] = "0";
                    returnList[rowNumber][2] = "Error in adding this row: Null Value - " + ex.getMessage();
                    error += 1;
                }
            } else {
                returnList[rowNumber][1] = "0";
                returnList[rowNumber][2] = "Manual insertion needed";
            }
        }
        returnList[0][0] = "0";
        returnList[0][1] = processed + "";
        returnList[0][2] = error + "";
        return returnList;
    }

    public String init() {
        // Initialize all vendors
        vendors = findAllVendors();
        bankAccounts = findAccountsByType(AccountTypeEnum.BANK);
        expenseAccounts = findAccountsByType(AccountTypeEnum.EXPENSE);
        paymentMethods = findAllPaymentMethods();
        taxCodes = findAllTaxCodes();
        departments = findAllDepartments();

        // Check for valid lists
        if (vendors == null) {
            initError += "|vendors list is null|";
        }
        if (bankAccounts == null) {
            initError += "|bankAccounts list is null|";
        }
        if (expenseAccounts == null) {
            initError += "|expenseAccounts list is null|";
        }
        if (!initializeTaxcodeReferences()) {
            initError += "|taxCode init fail|";
        }
        if (paymentMethods == null) {
            initError += "|paymentMethods list is null|";
        }
        if (departments == null) {
            initError += "|departments list is null|";
        }
        if (!initError.equals("")) {
            initHasError = true;
        }
        return initError;
    }

    /**
     * Initialize all the list of accounts, tax codes etc with the QBO accounts
     * DataService
     *
     * @param dataService
     */
    public QBODAO(DataService dataService) {
        if (dataService == null) {
            throw new IllegalArgumentException("Null DataService parsed at QBODAO");
        } else {
            this.dataService = dataService;
        }
    }
}
