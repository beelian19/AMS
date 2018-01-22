package Entity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
    private String stringFinancialYearEnd;
    private Calendar financialYearEnd;
    private Calendar var;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public Timeline(Client client) {
        isCompany = client.getBusinessType().toLowerCase().equals("company");
        stringFinancialYearEnd = client.getFinancialYearEnd().trim();
        gst = client.getGstSubmission().toLowerCase().trim();
        mgt = client.getMgmtAcc().toLowerCase().trim();
    }

    public HashMap<String, String> getAllTimelines() {
        HashMap<String, String> hm = new HashMap<>();
        if (isValid) {
            hm.put("stringFinancialYearEnd", stringFinancialYearEnd);
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

    public JSONObject getAllTimelinesJSONObject() {
        return new JSONObject(getAllTimelines());
    }

    private Calendar getFinancialYearEnd(String yyyyMMdd) throws ParseException {
        Date date = sdf.parse(yyyyMMdd);
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        return cal;
    }

    public Boolean initAll() {
        try {
            isValid = false;

            String yyyyMMdd = getYearMonthDayString(stringFinancialYearEnd);
            if (yyyyMMdd == null || yyyyMMdd.contains("na")) {
                return false;
            }

            // Get the Calendar object of the final year end
            financialYearEnd = getFinancialYearEnd(yyyyMMdd);

            // Get the year of the financial year end
            int year = financialYearEnd.get(Calendar.YEAR);

            //Get Tax Timeline
            if (isCompany) {
                // actual tax timeline is 30 Nov
                actualTaxTimeline = year + "-11-30";
                // internal tax timeline is 3 months before actual
                taxTimeline = year + "-08-30";
                // actual eci timeline is 3 months after financial year end
                var = getFinancialYearEnd(yyyyMMdd);
                var.add(Calendar.MONTH, 3);
                actualEciTimeline = sdf.format(var.getTime());
                // internal eci timeline is 1 month before actial
                var.add(Calendar.MONTH, -1);
                eciTimeline = sdf.format(var.getTime());
            } else {
                // actual tax timelien is 31 march
                actualTaxTimeline = year + "-03-31";
                // internal tax timeline is 28 feb
                taxTimeline = year + "-02-28";
                // eci is na
                actualEciTimeline = "na";
                eciTimeline = "na";
            }

            //Get accounting timeline
            switch (gst) {
                case "m":
                    // get the last day of the current month
                    var = Calendar.getInstance();
                    int thisYear = var.get(Calendar.YEAR);
                    int thisMonth = var.get(Calendar.MONTH);
                    int maxDay = var.getActualMaximum(Calendar.DAY_OF_MONTH);
                    var.set(thisYear, thisMonth, maxDay);
                    actualGstTimeline = sdf.format(var.getTime());
                    // internal is 7 days before
                    var.add(Calendar.DAY_OF_MONTH, -7);
                    gstTimeline = sdf.format(var.getTime());
                    break;
                case "q":
                    // get next viable quater
                    var = getFinancialYearEnd(yyyyMMdd);
                    int day = var.get(Calendar.DAY_OF_MONTH);
                    int targetMonth = var.get(Calendar.MONTH);
                    int currentMonth = Calendar.getInstance().get(Calendar.MONTH);
                    int currentYear;
                    int nextMonth = nextQuarterMonth(currentMonth, targetMonth);
                    // set to next year if month crossover
                    var = Calendar.getInstance();
                    if (nextMonth < currentMonth) {
                        var.add(Calendar.YEAR, 1);
                        currentYear = var.get(Calendar.YEAR);
                    } else {
                        currentYear = var.get(Calendar.YEAR);
                    }
                    var.set(currentYear, nextMonth, day);
                    // gst deadline is a month after financial period
                    var.add(Calendar.MONTH, 1);
                    actualGstTimeline = sdf.format(var.getTime());
                    // internal deadline is 8 days before
                    var.add(Calendar.DAY_OF_MONTH, -8);
                    gstTimeline = sdf.format(var.getTime());
                    break;

                // THIS BROKE
                case "s":
                    var = getFinancialYearEnd(yyyyMMdd);
                    int sday = var.get(Calendar.DAY_OF_MONTH);
                    // stargetMonth is either month of financial year end date or 6 months after/before
                    int stargetMonth = var.get(Calendar.MONTH);
                    int scurrentMonth = Calendar.getInstance().get(Calendar.MONTH);
                    int scurrentYear = Calendar.getInstance().get(Calendar.YEAR);
                    int snextMonth;
                    if (scurrentMonth < stargetMonth) {
                        snextMonth = stargetMonth;
                    } else {
                        var.add(Calendar.MONTH, -6);
                        // add a year if crossover month
                        scurrentYear = var.get(Calendar.YEAR);
                        snextMonth = var.get(Calendar.MONTH);
                    }
                    var.set(scurrentYear, snextMonth, sday);
                    // deadline is a month after financial period
                    var.add(Calendar.MONTH, 1);
                    actualGstTimeline = sdf.format(var.getTime());
                    // internal deadline is 8 days before
                    var.add(Calendar.DAY_OF_MONTH, -8);
                    gstTimeline = sdf.format(var.getTime());
                    break;
                default:
                    gstTimeline = "na";
                    actualGstTimeline = "na";
                    break;

            }

            if (mgt.contains("na")) {
                mgtTimeline = "na";
                actualMgtTimeline = "na";
            } else {
                String managementDays = mgt.substring(2);
                int numDays = Integer.parseInt(managementDays);
                int mgtDays = 0;
                for(int i = 1; i <=31; i++){
                    if(i == numDays){
                        mgtDays = numDays; 
                        break;
                    }
                }
                /*switch (managementDays) {
                    case "7":
                        mgtDays = 7;
                        break;
                    case "15":
                        mgtDays = 15;
                        break;
                    case "21":
                        mgtDays = 21;
                        break;
                    default:
                        mgtDays = 28;
                        break;
                }*/
                mgt = mgt.substring(0, 1);

                switch (mgt) {
                    case "m":
                        // get the last day of the current month
                        var = Calendar.getInstance();
                        // var.add(Calendar.DAY_OF_MONTH, 1);
                        int thisYear = var.get(Calendar.YEAR);
                        int thisMonth = var.get(Calendar.MONTH);
                        var.set(thisYear, thisMonth, mgtDays);
                        actualMgtTimeline = sdf.format(var.getTime());
                        // internal is 7 days before
                        var.add(Calendar.DAY_OF_MONTH, -7);
                        mgtTimeline = sdf.format(var.getTime());
                        break;
                    case "q":
                        // get next viable quater
                        var = getFinancialYearEnd(yyyyMMdd);
                        int targetMonth = var.get(Calendar.MONTH);
                        int currentMonth = Calendar.getInstance().get(Calendar.MONTH);
                        int currentYear;
                        int nextMonth = nextQuarterMonth(currentMonth, targetMonth);
                        // set to next year if month crossover
                        var = Calendar.getInstance();
                        if (nextMonth < currentMonth) {
                            var.add(Calendar.YEAR, 1);
                            currentYear = var.get(Calendar.YEAR);
                        } else {
                            currentYear = var.get(Calendar.YEAR);
                        }
                        var.set(currentYear, nextMonth, mgtDays);
                        // gst deadline is a month after financial period
                        var.add(Calendar.MONTH, 1);
                        actualMgtTimeline = sdf.format(var.getTime());
                        // internal deadline is 8 days before
                        var.add(Calendar.DAY_OF_MONTH, -8);
                        mgtTimeline = sdf.format(var.getTime());
                        break;

                    default:
                        mgtTimeline = "na";
                        actualMgtTimeline = "na";
                        break;

                }
            }

            // final acc timeline
            if (isCompany) {
                var = getFinancialYearEnd(yyyyMMdd);
                var.add(Calendar.MONTH, 3);
                finTimeline = sdf.format(var.getTime());
                var.add(Calendar.MONTH, 3);
                actualFinTimeline = sdf.format(var.getTime());
            } else {
                var = getFinancialYearEnd(yyyyMMdd);
                actualFinTimeline = year + "-02-26";
                Date finDate = sdf.parse(actualFinTimeline);
                var.setTime(finDate);
                var.add(Calendar.MONTH, -3);
                finTimeline = sdf.format(var.getTime());
            }

            // sec timeline
            actualSecTimeline = "na";
            secTimeline = "na";
            if (isCompany) {
                var = getFinancialYearEnd(yyyyMMdd);
                var.add(Calendar.MONTH, 6);
                actualSecTimeline = sdf.format(var.getTime());
                var = getFinancialYearEnd(yyyyMMdd);
                var.add(Calendar.MONTH, 3);
                var.add(Calendar.DAY_OF_MONTH, 15);
                secTimeline = sdf.format(var.getTime());
            }
            isValid = true;
            return true;
        } catch (ParseException | NullPointerException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
    }

    private int nextQuarterMonth(int current, int target) {
        switch (target) {
            case 0:
            case 3:
            case 6:
            case 9:
                if (current <= 2) {
                    return 3;
                } else if (current <= 5) {
                    return 6;
                } else if (current <= 8) {
                    return 9;
                } else {
                    return 0;
                }
            case 1:
            case 4:
            case 7:
            case 10:
                if (current == 10 || current == 11 || current == 0) {
                    return 1;
                } else if (current <= 3) {
                    return 4;
                } else if (current <= 6) {
                    return 7;
                } else {
                    return 10;
                }
            default:
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

    private String getYearMonthDayString(String dayAndMonthName) {
        if (dayAndMonthName == null) {
            return null;
        }
        Calendar nextYear = Calendar.getInstance();
        String thisYearString = String.valueOf(nextYear.get(Calendar.YEAR));
        nextYear.add(Calendar.YEAR, 1);
        String nextYearString = String.valueOf(nextYear.get(Calendar.YEAR));
        String dayString = dayAndMonthName.substring(0, 2);
        String monthString;
        // Get monthString
        switch (dayAndMonthName.substring(3).toLowerCase()) {
            case "jan":
                monthString = "01";
                break;
            case "feb":
                monthString = "02";
                break;
            case "mar":
                monthString = "03";
                break;
            case "apr":
                monthString = "04";
                break;
            case "may":
                monthString = "05";
                break;
            case "jun":
                monthString = "06";
                break;
            case "jul":
                monthString = "07";
                break;
            case "aug":
                monthString = "08";
                break;
            case "sep":
                monthString = "09";
                break;
            case "oct":
                monthString = "10";
                break;
            case "nov":
                monthString = "11";
                break;
            case "dec":
                monthString = "12";
                break;
            default:
                monthString = "na";
                break;
        }
        //Check if current year end has passed
        String thisYearEnd = thisYearString + "-" + monthString + "-" + dayString;
        Calendar thisYear = Calendar.getInstance();
        Date date;
        try {
            date = sdf.parse(thisYearEnd);
            thisYear.setTime(date);
            if (Calendar.getInstance().before(thisYear)) {
                return thisYearEnd;
            } else {
                return nextYearString + "-" + monthString + "-" + dayString;
            }
        } catch (ParseException ex) {
            return null;
        }
    }
}
