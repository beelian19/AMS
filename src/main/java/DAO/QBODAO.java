/*
 * The general design is that the QBODAO will load all the accounts, taxcode etc
 * so as to return a Purchase Object so that we can do row by row processing as
 * efficiently as possible. It would require another DAO to process each excel 
 * line to parse into QBODAO to return the Purcahse object, where data 
 * validation is performed on both sides to ensure maximum security
 */
package DAO;

import Entity.Expense;
import Entity.Payment;
import Entity.PaymentLine;
import com.intuit.ipp.core.IEntity;
import com.intuit.ipp.data.Account;
import com.intuit.ipp.data.AccountBasedExpenseLineDetail;
import com.intuit.ipp.data.AccountTypeEnum;
import com.intuit.ipp.data.Customer;
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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Icon
 */
public class QBODAO {

    // DataService
    private DataService dataService;
    // List Data objects to reduce number of query to quickbooks
    private List<Account> allAccounts;
    private List<Vendor> vendors;
    private List<TaxCode> taxCodes;
    private List<PaymentMethod> paymentMethods;
    private List<Department> departments;
    private List<com.intuit.ipp.data.Class> classes;
    private List<Customer> customers;
    private ReferenceType imReference;
    private ReferenceType txReference;
    private ReferenceType nrReference;

    private List<Account> bankAccounts;
    private List<Account> expenseAccounts;
    private String initError;
    private Boolean initHasError = false;
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
    private final String ACCOUNT_ALL = "select * from account";

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

    private List<Account> findAllAccounts() {
        String query = ACCOUNT_ALL;
        return (List<Account>) executeQueryList(dataService,
                query, com.intuit.ipp.data.Account.class);
    }

    /**
     *
     */
    private List<Department> findAllDepartments() {
        String query = "select * from department";
        return (List<Department>) executeQueryList(dataService, query,
                com.intuit.ipp.data.Department.class);
    }

    private List<com.intuit.ipp.data.Class> findAllClasses() {
        String query = "select * from class";
        return (List<com.intuit.ipp.data.Class>) executeQueryList(dataService, query,
                com.intuit.ipp.data.Class.class);
    }

    private List<Customer> findAllCustomers() {
        String query = "select * from customer";
        return (List<Customer>) executeQueryList(dataService, query,
                com.intuit.ipp.data.Customer.class);
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
        if (txnSupplierName == null) {
            return null;
        }
        if (!vendors.isEmpty()) {
            Iterator<Vendor> itr = vendors.iterator();
            while (itr.hasNext()) {
                Vendor ven = itr.next();
                if (ven != null && ven.getDisplayName() != null) {
                    if (ven.getDisplayName().toLowerCase().equals(txnSupplierName.toLowerCase())) {
                        ReferenceType venref = new ReferenceType();
                        venref.setValue(ven.getId());
                        return venref;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getCustomerReference(String customer) {
        if (customer == null) {
            return null;
        }
        if (!customers.isEmpty()) {
            Iterator<Customer> itr = customers.iterator();
            while (itr.hasNext()) {
                Customer c = itr.next();
                if (c != null && c.getDisplayName() != null) {
                    if (c.getDisplayName().trim().toLowerCase().equals(customer.toLowerCase().trim())) {
                        ReferenceType cref = new ReferenceType();
                        cref.setValue(c.getId());
                        return cref;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getClassReference(String classn) {
        if (classn == null) {
            return null;
        }
        if (!classes.isEmpty()) {
            Iterator<com.intuit.ipp.data.Class> itr = classes.iterator();
            while (itr.hasNext()) {
                com.intuit.ipp.data.Class c = itr.next();
                if (c != null && c.getName() != null) {
                    if (c.getName().trim().toLowerCase().equals(classn.toLowerCase().trim())) {
                        ReferenceType cref = new ReferenceType();
                        cref.setValue(c.getId());
                        return cref;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getLocationReference(String location) {
        if (location == null) {
            return null;
        }
        if (!departments.isEmpty()) {
            Iterator<Department> itr = departments.iterator();
            while (itr.hasNext()) {
                Department d = itr.next();
                if (d != null && d.getName() != null) {
                    if (d.getName().toLowerCase().equals(location.toLowerCase())) {
                        ReferenceType dref = new ReferenceType();
                        dref.setValue(d.getId());
                        return dref;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getBankReference(String txnAccountChargedNumber) {
        if (!allAccounts.isEmpty()) {
            Iterator<Account> itr = allAccounts.iterator();
            while (itr.hasNext()) {
                Account account = itr.next();
                if (account != null) {
                    if (account.getAcctNum() != null && account.getAcctNum().equals(txnAccountChargedNumber)) {
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
                if (account != null) {
                    if (account.getAcctNum() != null && account.getAcctNum().equals(expenseAccountNumber)) {
                        ReferenceType accRef = new ReferenceType();
                        accRef.setValue(account.getId());
                        return accRef;
                    }
                }
            }
        }
        return null;
    }

    private ReferenceType getAccountReference(String accountNumber) {
        if (!allAccounts.isEmpty()) {
            Iterator<Account> itr = allAccounts.iterator();
            while (itr.hasNext()) {
                Account account = itr.next();
                if (account != null) {
                    if (account.getAcctNum() != null && account.getAcctNum().equals(accountNumber)) {
                        ReferenceType accRef = new ReferenceType();
                        accRef.setValue(account.getId());
                        return accRef;
                    } else if (account.getName().contains(accountNumber.trim())) {
                        ReferenceType accRef = new ReferenceType();
                        accRef.setValue(account.getId());
                        return accRef;
                    }
                }
            }
        }
        return null;

    }

    private ReferenceType getAccountReferenceName(String accountName) {
        if (!allAccounts.isEmpty()) {
            Iterator<Account> itr = allAccounts.iterator();
            while (itr.hasNext()) {
                Account account = itr.next();
                if (account != null) {
                    if (account.getName() != null && account.getName().toLowerCase().trim().contains(accountName.toLowerCase().trim())) {
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
        if (paymentMethod == null) {
            return null;
        }
        if (!paymentMethods.isEmpty()) {
            Iterator<PaymentMethod> itr = paymentMethods.iterator();
            while (itr.hasNext()) {
                PaymentMethod pm = itr.next();
                if (pm != null && pm.getName() != null) {
                    if (pm.getName().toLowerCase().equals(paymentMethod.toLowerCase())) {
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
                    String tcName = tc.getName().replaceAll("[^a-zA-Z]", "");
                    if (tcName.equals("NR") && nrReference == null) {
                        nrReference = new ReferenceType();
                        nrReference.setValue(tc.getId());
                    } else if (tcName.equals("TX") && txReference == null) {
                        txReference = new ReferenceType();
                        txReference.setValue(tc.getId());
                    } else if (tcName.equals("IM") && imReference == null) {
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
        allAccounts = findAllAccounts();
        vendors = findAllVendors();
        taxCodes = findAllTaxCodes();
        paymentMethods = findAllPaymentMethods();
        departments = findAllDepartments();
        classes = findAllClasses();
        customers = findAllCustomers();

        /*
        for (Account a: allAccounts) {
            System.out.println("Name" + a.getName());
            System.out.println("Number:" + a.getAcctNum());
            System.out.println("numberextn:" + a.getAcctNumExtn());
            System.out.println("type" + a.getAccountType());
            System.out.println("id" + a.getId());
            System.out.println("banknum" + a.getBankNum());
            System.out.println("" + a.toString());
        }
        
        /*
        System.out.println("Class!!!!!!!");
        for (com.intuit.ipp.data.Class c: classes) {
            System.out.println("Name" + c.getName());
        }
        System.out.println("Customer!!!!!!");
        for (Customer cu : customers){
            System.out.println("Name" + cu.getDisplayName());
        }
         */
        for (TaxCode t : taxCodes) {
            System.out.println("Name" + t.getName());
            System.out.println("string " + t.toString());
        }

        initError = "";
        // Check for valid lists
        if (vendors == null) {
            initError += "|vendors list is null|";
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

    /**
     * Returns processed Payment objects
     *
     * @param prePayments
     * @param chargedAccountNumber
     * @return
     */
    public List<Payment> submitPrePayments(List<Payment> prePayments, int chargedAccountNumber) {
        List<Payment> postPayments = new ArrayList<>();
        // Get the charged account reference
        ReferenceType bankReference = getAccountReference(String.valueOf(chargedAccountNumber));

        for (Payment pre : prePayments) {
            String status = "";
            //process purchase

            Purchase purchase = new Purchase();

            // Set charged account (required)
            if (bankReference != null) {
                purchase.setAccountRef(bankReference);
            } else {
                status += "-" + chargedAccountNumber + " account number invalid-";
            }

            // Set date (required)
            if (pre.getDate() != null) {
                purchase.setTxnDate(pre.getDate());
            } else {
                status += "-No Date-";
            }

            // Set reference number (optional)
            if (pre.getReferenceNumber() != null || !pre.getReferenceNumber().isEmpty()) {
                purchase.setDocNumber(pre.getReferenceNumber());
            }

            // Set memo (optional)
            if (pre.getMemo() != null) {
                purchase.setPrivateNote(pre.getMemo());
            }

            // Set payment method (optional)
            purchase.setPaymentType(PaymentTypeEnum.CASH);
            if (pre.getPaymentMethod() != null) {
                ReferenceType paymentMethodReference = getPaymentMethodReference(pre.getPaymentMethod().trim());
                if (paymentMethodReference != null) {
                    purchase.setPaymentMethodRef(paymentMethodReference);
                }
            }

            // Set vendor (required)
            if (pre.getVendor() != null) {
                ReferenceType vendorReference = getVendorReference(pre.getVendor().trim());
                if (vendorReference != null) {
                    purchase.setEntityRef(vendorReference);
                } else {
                    status += "-" + pre.getVendor() + "vendor invalid-";
                }
            } else {
                status += "-No Vendor-";
            }

            // Set location (optional)
            if (pre.getLocation() != null) {
                ReferenceType locationReference = getLocationReference(pre.getLocation().trim());
                if (locationReference != null) {
                    purchase.setDepartmentRef(locationReference);
                }
            }

            purchase.setGlobalTaxCalculation(GlobalTaxCalculationEnum.TAX_INCLUSIVE);
            
            
            List<PaymentLine> paymentLines = pre.getLines();
            List<Line> lineList = new ArrayList<>();

            for (PaymentLine pl : paymentLines) {
                Line line = new Line();

                line.setDetailType(LineDetailTypeEnum.ACCOUNT_BASED_EXPENSE_LINE_DETAIL);

                // Set line description (optional)
                if (pl.getLineDescription() != null) {
                    line.setDescription(pl.getLineDescription());
                }

                BigDecimal exclTaxAmount = BigDecimal.valueOf(0.0);
                BigDecimal incTaxAmount = BigDecimal.valueOf(0.0);
                if (pl.getExTaxAmount() == 0.0 || pl.getIncTaxAmount() == 0.0) {
                    status += "-Missing Amounts-";
                } else {
                    exclTaxAmount = BigDecimal.valueOf(pl.getExTaxAmount()).setScale(2, BigDecimal.ROUND_HALF_UP);
                    incTaxAmount = BigDecimal.valueOf(pl.getIncTaxAmount()).setScale(2, BigDecimal.ROUND_HALF_UP);
                }

                // Set line amount (required)
                line.setAmount(exclTaxAmount);

                AccountBasedExpenseLineDetail abeld = new AccountBasedExpenseLineDetail();

                // Customer (optional)
                if (pl.getQBOLineCustomer() != null) {
                    ReferenceType customerReference = getCustomerReference(pl.getQBOLineCustomer());
                    if (customerReference != null) {
                        abeld.setCustomerRef(customerReference);
                    }
                }

                //Class (optional)
                if (pl.getQBOLineClass() != null) {
                    ReferenceType classReference = getClassReference(pl.getQBOLineClass());
                    if (classReference != null) {
                        abeld.setClassRef(classReference);
                    }
                }

                //AccountRef (required)
                if (pl.getAccountNumber() == 0) {
                    status += "-Missing expense account-";
                } else {
                    ReferenceType accReference = getAccountReference(String.valueOf(pl.getAccountNumber()));
                    if (accReference != null) {
                        abeld.setAccountRef(accReference);
                    } else if (pl.getAccountName() != null) {
                        accReference = getAccountReferenceName(pl.getAccountName());
                        if (accReference != null) {
                            abeld.setAccountRef(accReference);
                        }
                    }
                    if (accReference == null) {
                        status += "-Invalid expense account" + pl.getAccountNumber() + "-";
                    }
                }

                Boolean hasTax = false;

                //Tax Code (optional?)
                if (pl.getTax() != null) {
                    String taxCode = pl.getTax();
                    if (taxCode.contains("TX")) {
                        abeld.setTaxCodeRef(txReference);
                        hasTax = true;
                    } else if (taxCode.contains("NR")) {
                        abeld.setTaxCodeRef(nrReference);
                    } else if (taxCode.contains("IM")) {
                        abeld.setTaxCodeRef(imReference);
                        hasTax = true;
                    } else if (taxCode.contains("No")) {
                        hasTax = false;
                    }else {
                        status += "-Invalid Tax Code-";
                    }
                } else {
                    status += "-Missing Tax Code-";
                }

                //Tax Amount (Only if have tax)
                if (hasTax && pl.getExTaxAmount() != 0.0) {
                    BigDecimal taxed = incTaxAmount.subtract(exclTaxAmount);
                    abeld.setTaxAmount(taxed);
                    abeld.setTaxInclusiveAmt(incTaxAmount);
                }

                line.setAccountBasedExpenseLineDetail(abeld);
                lineList.add(line);
            }

            purchase.setLine(lineList);

            if (status.isEmpty()) {
                try {
                    Purchase savedPurchase = dataService.add(purchase);
                } catch (FMSException ex) {
                    List<com.intuit.ipp.data.Error> list = ex.getErrorList();
                    status = "error: ";
                    for (com.intuit.ipp.data.Error er : list) {
                        status += er.getMessage();
                    }
                    pre.setStatus(status);
                }
                pre.setStatus("success");
            } else {
                String notProcessed = "Not processed due to " + status;
                pre.setStatus(notProcessed);
            }
            //set results into status
            postPayments.add(pre);
        }

        return postPayments;
    }
}
