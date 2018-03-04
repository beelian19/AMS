/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.xml.bind.annotation.adapters.XmlAdapter;

public class XmlToDateAdapter extends XmlAdapter<String, Date> {
    public static final DateFormat SKAT_DATE_FORMATTER = new SimpleDateFormat("yyyy-MM-dd");

    @Override
        public Date unmarshal(String v) throws Exception {
        Date date = SKAT_DATE_FORMATTER.parse(v);
        return date;
    }

    @Override
    public String marshal(Date v) throws Exception {
        return SKAT_DATE_FORMATTER.format(v);
    }

}