/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utility;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import java.io.PrintWriter;

/**
 *
 * @author G3T3
 */

public class JsonFormatter {
    
    /**
     * Convert any object into JsonElement
     * @param value object that need to convert into JsonElement
     * @return JsonElement of the input object
     */
    public static JsonElement convertObjectToElement(Object value) {
        JsonParser parser = new JsonParser();
        Gson gson = new Gson();
        JsonElement je = parser.parse(gson.toJson(value).toString());
        return je;
    }

    /**
     * Print out the JsonObject using the print writer
     * @param outputRequest JsonObject that need to be printed
     * @param out PrintWriter for the browser
     */
    public static void printJSON(JsonObject outputRequest, PrintWriter out) {
        Gson gson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create();
        try {
            String prettyJsonString = gson.toJson(outputRequest);
            out.print(prettyJsonString);
        } catch (JsonSyntaxException ex) {
            System.out.println("Bootstrap (printJSON): " + ex.toString());
        }
    }
}
