/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import DAO.ClientDAO;
import DAO.ProjectDAO;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import org.apache.commons.lang.StringUtils;

/**
 *
 * @author Lin
 */
public class TestClass {
    
    private static void testTimeline() {

        Client c = ClientDAO.getClientByCompanyName("The Oakthree Group Pte. Ltd");
        System.out.println("===Testing timeline object===");
        System.out.println("Client type: " + c.getBusinessType());
        System.out.println("Client financial year end: " + c.getFinancialYearEnd());
        System.out.println("Client gst: " + c.getGstSubmission() + "; Cliet mgt: " + c.getMgmtAcc());
        Timeline t = new Timeline(c);
        if (t.initAll()) {
            HashMap<String, String> results = t.getAllTimelines();
            results.entrySet().stream().forEach((entry) -> {
                String key = entry.getKey();
                String value = entry.getValue();
                System.out.println(key + " -> " + value);
            });

        } else {
            System.out.println("Failed to initialize Timeline Object!");
        }
        System.out.println("===End of test===");
    }

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

    public static void testListPrint() {
        Arrays.asList(1, 2, 3, 4, 5).stream().forEach((i) -> {
            System.out.println(i + ":");
        });
    }

    public static void testSubString() {
        String s = "123456";
        System.out.println(StringUtils.substring(s, 0, 15));
    }
    
    public static void testOGProjectMap(){
        ArrayList<Project> pList = new ArrayList<>();
        for (int i = 1; i <= 2; i++){
            Project p = new Project();
            p.setProjectID(i);
            p.setProjectType("Test");
            pList.add(p);
        }
        
        HashMap<String, String> pIdUrl = ProjectDAO.getProjectTypeAsKeyAndURLAsValue(pList);
        for (String s: pIdUrl.keySet()){
            System.out.println("Key: " + s);
            System.out.println("Val: " + pIdUrl.get(s));
        }
        
    
    }

    public static void main(String[] args) {
        testOGProjectMap();
    }
}
