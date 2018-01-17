/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Lin
 */
public class TestClass {

    public static void testPaymentObjects() {
        List<Payment> pre = SampleData.loadPrePaymentList();
        List<Payment> post = SampleData.loadPostPaymentList();
        System.out.println("Printing Pre Payments");
        pre.stream().forEach((p) -> {
            System.out.println(p.toString());
            System.out.println("Payment success: " + p.checkPayment());
            p.getLines().forEach(
                    (li) -> {
                        System.out.println("Payment Status: " + li.getInitStatus());
                        System.out.println("PaymentLine success: " + li.checkPaymentLine());
                    }
            );
        });
        System.out.println("\n Printing Post Payments \n");
        post.stream().forEach((p) -> {
            System.out.println(p.toString());
            System.out.println("Status: " + p.getStatus());

        });
        System.out.println("End");
    }
    
    public static void testListPrint(){
        Arrays.asList(1, 2, 3, 4, 5).stream().forEach((i) -> {
            System.out.println(i + ":");
        });
    }

    public static void main(String[] args) {
        testListPrint();
    }
}
