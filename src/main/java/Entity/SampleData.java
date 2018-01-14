package Entity;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class SampleData {

    public static Date getCurrentDate() {
        return Calendar.getInstance().getTime();
    }

    public static Date getCurrentDate(int i) {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DAY_OF_MONTH, -i);
        return c.getTime();
    }

    // Use this class to test a single Payment to Abundant UAT
    public static Payment getSinglePrePayment() {
        Payment p = new Payment();

        p.setDate(getCurrentDate());
        p.setReferenceNumber("TestReferenceNumber");
        p.setChargedAccountNumber(11100);
        p.setMemo("TestMemo");
        p.setPaymentMethod("TestPaymentMethod");
        p.setVendor("TestVendor");

        List<PaymentLine> lines = new ArrayList<>();
        PaymentLine l = new PaymentLine();
        l.setAccountName("TestAccountName");
        l.setAccountNumber(123456);
        l.setLineDescription("TestLineDescription");
        l.setExTaxAmount(10.0);
        l.setIncTaxAmount(10.7);
        l.setTax("7% TestGst");
        l.setQBOLineClass("TestClass");
        l.setQBOLineCustomer("TestCustomer");
        lines.add(l);

        p.setLines(lines);

        return p;
    }

    public static List<Payment> loadPrePaymentList() {
        List<Payment> list = new ArrayList<>();
        // Add 3 valid Payments
        for (int i = 1; i <= 3; i++) {
            Payment p = new Payment();
            p.setDate(getCurrentDate(i));
            p.setReferenceNumber("TestReferenceNumber: " + i);
            p.setChargedAccountNumber(11100 + i);
            p.setMemo("TestMemo: " + i);
            p.setPaymentMethod("TestPaymentMethod: " + i);
            p.setVendor("TestVendor: " + i);

            List<PaymentLine> lines = new ArrayList<>();
            PaymentLine l = new PaymentLine();
            l.setAccountName("TestAccountName: " + i);
            l.setAccountNumber(123450 + i);
            l.setLineDescription("TestLineDescription: " + i);
            l.setExTaxAmount(10.0 + i);
            l.setIncTaxAmount(10.7 + i);
            l.setTax("7% TestGst: " + i);
            l.setQBOLineClass("TestClass: " + i);
            l.setQBOLineCustomer("TestCustomer: " + i);
            lines.add(l);
            p.setLines(lines);
            list.add(p);
        }

        // Add an invalid Payment
        Payment pError = new Payment();

        pError.setDate(getCurrentDate());
        pError.setReferenceNumber("TestReferenceNumberE");
        //pError.setChargedAccountNumber(11100);
        pError.setMemo("TestMemoE");
        pError.setPaymentMethod("TestPaymentMethodE");
        pError.setVendor("TestVendorE");

        List<PaymentLine> linesError = new ArrayList<>();
        PaymentLine lineError = new PaymentLine();
        lineError.setAccountName("TestAccountNameE");
        lineError.setAccountNumber(123456);
        lineError.setLineDescription("TestLineDescriptionE");
        lineError.setExTaxAmount(10.0);
        lineError.setIncTaxAmount(10.7);
        lineError.setTax("7% TestGstE");
        lineError.setQBOLineClass("TestClassE");
        lineError.setQBOLineCustomer("TestCustomerE");
        linesError.add(lineError);

        pError.setLines(linesError);
        list.add(pError);

        // Add a multi-lined (2) Payment
        Payment pMulti = new Payment();
        pMulti.setDate(getCurrentDate());
        pMulti.setReferenceNumber("TestReferenceNumberM");
        pMulti.setChargedAccountNumber(11100);
        pMulti.setMemo("TestMemoM");
        pMulti.setPaymentMethod("TestPaymentMethodM");
        pMulti.setVendor("TestVendorM");

        List<PaymentLine> linesMulti = new ArrayList<>();
        PaymentLine linesMulti1 = new PaymentLine();
        linesMulti1.setAccountName("TestAccountNameM1");
        linesMulti1.setAccountNumber(123456);
        linesMulti1.setLineDescription("TestLineDescriptionM1");
        linesMulti1.setExTaxAmount(10.0);
        linesMulti1.setIncTaxAmount(10.7);
        linesMulti1.setTax("7% TestGstM1");
        linesMulti1.setQBOLineClass("TestClassM1");
        linesMulti1.setQBOLineCustomer("TestCustomerM1");
        linesMulti.add(linesMulti1);

        PaymentLine linesMulti2 = new PaymentLine();
        linesMulti2.setAccountName("TestAccountNameM2");
        linesMulti2.setAccountNumber(123456);
        linesMulti2.setLineDescription("TestLineDescriptionM2");
        linesMulti2.setExTaxAmount(10.0);
        linesMulti2.setIncTaxAmount(10.7);
        linesMulti2.setTax("7% TestGstM2");
        linesMulti2.setQBOLineClass("TestClassM2");
        linesMulti2.setQBOLineCustomer("TestCustomerM2");
        linesMulti.add(linesMulti2);

        pMulti.setLines(linesMulti);
        list.add(pMulti);

        return list;
    }

    public static List<Payment> loadPostPaymentList() {
        List<Payment> pre = loadPrePaymentList();
        List<Payment> post = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Payment p = pre.get(i - 1);
            if (i != 3) {
                p.setStatus("Success " + i);
            } else {
                p.setStatus("Error: failed");
            }
            post.add(p);
        }

        return post;
    }

}
