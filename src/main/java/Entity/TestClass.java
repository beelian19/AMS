/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import java.util.List;

/**
 *
 * @author Lin
 */
public class TestClass {
    public static void main(String[] args){
        List<Payment> pre = SampleData.loadPrePaymentList();
        List<Payment> post = SampleData.loadPostPaymentList();
        System.out.println("Printing Pre Payments");
        pre.stream().forEach((p) -> {
            System.out.println(p.toString());
        });
        System.out.println("Printing Post Payments");
        post.stream().forEach((p) -> {
            System.out.println(p.toString());
        });
        System.out.println("End");
    }
}
