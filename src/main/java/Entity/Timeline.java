/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entity;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import org.json.simple.JSONObject;

public class Timeline {

    private Boolean isCompany;
    private Boolean isValid;
    private String gst;
    private String mgt;
    private String actualEciTimeline;
    private String eciTimeline;
    private String actualTaxTimeline;
    private String taxTimeline;
    private String actualGstTimeline;
    private String gstTimeline;
    private String actualMgtTimeline;
    private String mgtTimeline;
    private String actualFinTimeline;
    private String finTimeline;
    private String actualSecTimeline;
    private String secTimeline;
    private String fye;
    private final SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
    private String errors;

    private Calendar nov30;
    private Calendar mar31;
    private Calendar feb26;
    private Calendar fyeDate;
    private Calendar var;
    private final Calendar currentCalendar = Calendar.getInstance();

    private String FYEmonth;
    private String FYEday;

    private Integer currentYear;

    public Timeline(Client client) {
        isCompany = client.getBusinessType().toLowerCase().contains("company");
        fye = client.getFinancialYearEnd().trim();
        gst = client.getGstSubmission().toLowerCase().trim();
        mgt = client.getMgmtAcc().toLowerCase().trim();

        this.currentYear = currentCalendar.get(Calendar.YEAR);

        nov30 = Calendar.getInstance();
        nov30.set(currentYear, 10, 30);

        mar31 = Calendar.getInstance();
        mar31.set(currentYear, 2, 31);

        feb26 = Calendar.getInstance();
        feb26.set(currentYear, 1, 26);
    }

    /**
     * Returns the FYE based on which year is required Parameters are -1, 0, 1
     * -1 for last year, 0 for current year and 1 for next year
     *
     * @param base
     * @return
     */
    public Calendar getFYE(int base) {
        Calendar varC;
        varC = Calendar.getInstance();
        int zeroBasedMonth = Integer.valueOf(FYEmonth) - 1;
        int year = currentYear + base;
        varC.set(year, zeroBasedMonth, Integer.valueOf(FYEday));
        return varC;
    }

    public Boolean initAll() {
        try {

            errors = "";

            // Get FYEmonth and FYEday
            if (getFYEMonthAndDay() == null) {
                throw new IllegalArgumentException("Invalid financial year end found: " + fye);
            }

            // Set Tax, Eci, Fin, Sec Timeline
            if (isCompany) {

                // Set Tax
                if (currentCalendar.after(nov30)) {
                    actualTaxTimeline = "11-30-" + (currentYear + 1);
                    taxTimeline = "08-30-" + (currentYear + 1);
                } else {
                    actualTaxTimeline = "11-30-" + currentYear;
                    taxTimeline = "08-30-" + currentYear;
                }

                fyeDate = getFYE(0);
                // Set Eci (3 months after FYE)
                fyeDate.add(Calendar.MONTH, 3);
                // If this year Eci Timeline is after current date, set as next year
                if (currentCalendar.after(fyeDate)) {
                    fyeDate.add(Calendar.YEAR, 1);
                }
                actualEciTimeline = sdf.format(fyeDate.getTime());
                fyeDate.add(Calendar.MONTH, -1);
                eciTimeline = sdf.format(fyeDate.getTime());

                // Set Sec and Fin (6 months after FYE)
                fyeDate = getFYE(0);
                fyeDate.add(Calendar.MONTH, 6);
                // If this year Eci Timeline is after current date, set as next year
                if (currentCalendar.after(fyeDate)) {
                    fyeDate.add(Calendar.YEAR, 1);
                }
                actualFinTimeline = sdf.format(fyeDate.getTime());
                actualSecTimeline = sdf.format(fyeDate.getTime());
                fyeDate.add(Calendar.MONTH, -3);
                finTimeline = sdf.format(fyeDate.getTime());
                fyeDate.set(Calendar.DAY_OF_MONTH, 15);
                secTimeline = sdf.format(fyeDate.getTime());
            } else {
                // If not company type

                // Set Tax
                if (currentCalendar.after(mar31)) {
                    actualTaxTimeline = "02-31-" + (currentYear + 1);
                    taxTimeline = "01-28-" + (currentYear + 1);
                } else {
                    actualTaxTimeline = "02-31-" + currentYear;
                    taxTimeline = "01-28-" + currentYear;
                }
                // Set eci
                actualEciTimeline = "na";
                eciTimeline = "na";

                // Set sec
                actualSecTimeline = "na";
                secTimeline = "na";

                // Set fin
                if (currentCalendar.after(feb26)) {
                    feb26.add(Calendar.YEAR, 1);
                }
                actualFinTimeline = sdf.format(feb26.getTime());
                feb26.add(Calendar.MONTH, -3);
                finTimeline = sdf.format(feb26.getTime());
            }

            int currentMonth = currentCalendar.get(Calendar.MONTH);

            // Set Gst
            switch (gst) {
                case "m":
                    // get the last day of the current month
                    var = Calendar.getInstance();
                    int thisYear = var.get(Calendar.YEAR);
                    int thisMonth = var.get(Calendar.MONTH);
                    int maxDay = var.getActualMaximum(Calendar.DAY_OF_MONTH);
                    // Set var as the last day of the current month
                    var.set(thisYear, thisMonth, maxDay);
                    // If it is currently the last day of the month set the project as next year
                    if (currentCalendar.get(Calendar.DAY_OF_MONTH) == maxDay) {
                        var.add(Calendar.MONTH, 1);
                    }
                    actualGstTimeline = sdf.format(var.getTime());
                    // internal is 7 days before
                    var.add(Calendar.DAY_OF_MONTH, -7);
                    gstTimeline = sdf.format(var.getTime());
                    break;
                case "q":

                    var = Calendar.getInstance();

                    // get next viable quater
                    int nextMonth = nextQuarterMonth(currentMonth, Integer.parseInt(FYEmonth));
                    var.set(Calendar.MONTH, nextMonth);
                    var.set(Calendar.DAY_OF_MONTH, Integer.parseInt(FYEday));
                    // set to next year if month crossover
                    if (nextMonth < currentMonth) {
                        var.add(Calendar.YEAR, 1);
                    }
                    // gst deadline is a month after financial period
                    var.add(Calendar.MONTH, 1);

                    actualGstTimeline = sdf.format(var.getTime());
                    // internal deadline is 8 days before
                    var.add(Calendar.DAY_OF_MONTH, -8);
                    gstTimeline = sdf.format(var.getTime());
                    break;

                // THIS BROKE
                case "s":
                    if (Integer.parseInt(FYEmonth) < currentMonth) {
                        if (Integer.parseInt(FYEmonth) + 6 < currentMonth) {
                            fyeDate = getFYE(0);
                            fyeDate.add(Calendar.MONTH, 1);
                            fyeDate.add(Calendar.YEAR, 1);
                            actualGstTimeline = sdf.format(fyeDate.getTime());
                            fyeDate.add(Calendar.DAY_OF_MONTH, -8);
                            gstTimeline = sdf.format(fyeDate.getTime());
                        } else {
                            fyeDate = getFYE(0);
                            fyeDate.add(Calendar.MONTH, 7);
                            actualGstTimeline = sdf.format(fyeDate.getTime());
                            fyeDate.add(Calendar.DAY_OF_MONTH, -8);
                            gstTimeline = sdf.format(fyeDate.getTime());
                        }

                    } else {
                        // 1 month after FYE
                        fyeDate = getFYE(0);
                        fyeDate.add(Calendar.MONTH, 1);
                        actualGstTimeline = sdf.format(fyeDate.getTime());
                        fyeDate.add(Calendar.DAY_OF_MONTH, -8);
                        gstTimeline = sdf.format(fyeDate.getTime());
                    }
                    break;
                default:
                    gstTimeline = "na";
                    actualGstTimeline = "na";
                    break;
            }

            if (mgt.toLowerCase().contains("na")) {
                mgtTimeline = "na";
                actualMgtTimeline = "na";
            } else {
                int mgtDays = Integer.parseInt(mgt.substring(1));

                switch (mgt.substring(0, 1)) {
                    case "m":
                        // get the last day of the current month
                        fyeDate = Calendar.getInstance();
                        int thisYear = fyeDate.get(Calendar.YEAR);
                        int thisMonth = fyeDate.get(Calendar.MONTH);
                        fyeDate.set(Calendar.DAY_OF_MONTH, mgtDays);
                        var = Calendar.getInstance();

                        if (var.after(fyeDate)) {
                            fyeDate.add(Calendar.MONTH, 1);
                            actualMgtTimeline = sdf.format(fyeDate.getTime());
                            fyeDate.add(Calendar.DAY_OF_MONTH, -7);
                            mgtTimeline = sdf.format(fyeDate.getTime());
                        } else {
                            actualMgtTimeline = sdf.format(fyeDate.getTime());
                            fyeDate.add(Calendar.DAY_OF_MONTH, -7);
                            mgtTimeline = sdf.format(fyeDate.getTime());
                        }
                        break;

                    case "q":
                        var = Calendar.getInstance();
                        // get next viable quater
                        int nextMonth = nextQuarterMonth(currentMonth, Integer.parseInt(FYEmonth));
                        var.set(Calendar.MONTH, nextMonth);
                        var.set(Calendar.DAY_OF_MONTH, mgtDays);
                        // set to next year if month crossover
                        if (nextMonth < currentMonth) {
                            var.add(Calendar.YEAR, 1);
                        }
                        // gst deadline is a month after financial period
                        var.add(Calendar.MONTH, 1);
                        actualMgtTimeline = sdf.format(var.getTime());
                        var.add(Calendar.DAY_OF_MONTH, -8);
                        mgtTimeline = sdf.format(var.getTime());
                        break;

                    default:
                        mgtTimeline = "na";
                        actualMgtTimeline = "na";
                        break;

                }
            }

        } catch (IllegalArgumentException | NullPointerException iae) {
            errors += ("-Exception found: " + iae.getMessage() + "-");
        }

        // If errors is empty, return true
        isValid = errors.equals("");
        return isValid;
    }

    private String getFYEMonthAndDay() {
        if (fye == null || fye.isEmpty() || fye.length() < 6) {
            return null;
        }

        this.FYEday = fye.substring(0, 2);

        switch (fye.substring(3).toLowerCase()) {
            case "jan":
                this.FYEmonth = "01";
                break;
            case "feb":
                this.FYEmonth = "02";
                break;
            case "mar":
                this.FYEmonth = "03";
                break;
            case "apr":
                this.FYEmonth = "04";
                break;
            case "may":
                this.FYEmonth = "05";
                break;
            case "jun":
                this.FYEmonth = "06";
                break;
            case "jul":
                this.FYEmonth = "07";
                break;
            case "aug":
                this.FYEmonth = "08";
                break;
            case "sep":
                this.FYEmonth = "09";
                break;
            case "oct":
                this.FYEmonth = "10";
                break;
            case "nov":
                this.FYEmonth = "11";
                break;
            case "dec":
                this.FYEmonth = "12";
                break;
            default:
                return null;
        }
        return FYEday;
    }

    /**
     * Returns the company's financial year end month and the current month,
     * return the next quarter (3 months) month's deadline from 0-11
     *
     * @param current
     * @param financialYearEndMonth
     * @return
     */
    private int nextQuarterMonth(int current, int financialYearEndMonth) {
        switch (financialYearEndMonth) {
            case 0: //Jan
            case 3: //Apr
            case 6: //Jul
            case 9: //Oct
                if (current <= 2) {
                    return 3;
                } else if (current <= 5) {
                    return 6;
                } else if (current <= 8) {
                    return 9;
                } else {
                    return 0;
                }

            case 1: //Feb
            case 4: //May
            case 7: //Aug
            case 10://Nov
                if (current == 10 || current == 11 || current == 0) {
                    return 1;
                } else if (current <= 3) {
                    return 4;
                } else if (current <= 6) {
                    return 7;
                } else {
                    return 10;
                }
            default: //Mar Jun Sep Dec
                if (current <= 1 || current == 11) {
                    return 2;
                } else if (current <= 4) {
                    return 5;
                } else if (current <= 7) {
                    return 8;
                } else {
                    return 11;
                }
        }

    }

    public JSONObject getAllTimelinesJSONObject() {
        return new JSONObject(getAllTimelines());
    }

    public HashMap<String, String> getAllTimelines() {
        HashMap<String, String> hm = new HashMap<>();
        if (isValid) {
            hm.put("stringFinancialYearEnd", fye);
            hm.put("actualEciTimeline", actualEciTimeline);
            hm.put("eciTimeline", eciTimeline);
            hm.put("actualTaxTimeline", actualTaxTimeline);
            hm.put("taxTimeline", taxTimeline);
            hm.put("actualGstTimeline", actualGstTimeline);
            hm.put("gstTimeline", gstTimeline);
            hm.put("actualMgtTimeline", actualMgtTimeline);
            hm.put("mgtTimeline", mgtTimeline);
            hm.put("actualFinTimeline", actualFinTimeline);
            hm.put("finTimeline", finTimeline);
            hm.put("actualSecTimeline", actualSecTimeline);
            hm.put("secTimeline", secTimeline);
            return hm;
        } else {
            hm.put("stringFinancialYearEnd", "na");
            hm.put("actualEciTimeline", "na");
            hm.put("eciTimeline", "na");
            hm.put("actualTaxTimeline", "na");
            hm.put("taxTimeline", "na");
            hm.put("actualGstTimeline", "na");
            hm.put("gstTimeline", "na");
            hm.put("actualMgtTimeline", "na");
            hm.put("mgtTimeline", "na");
            hm.put("actualFinTimeline", "na");
            hm.put("finTimeline", "na");
            hm.put("actualSecTimeline", "na");
            hm.put("secTimeline", "na");
            return hm;
        }
    }

    public String getErrors() {
        return errors;
    }
    
    
}
