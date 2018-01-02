package Entity;

import java.util.Arrays;
import java.util.Map;
import java.util.stream.Collectors;

public class MonthlyRemarks {

    private Integer yearMonth;
    private String remarks;
    private Map<String, String> remarksMap;

    public MonthlyRemarks(Integer yearMonth, String remarks) {
        this.yearMonth = yearMonth;
        this.remarks = remarks;
        // Convert single string remarks into hashmap of employee names' remarks
        this.remarksMap = Arrays.stream(remarks.split(","))
                .collect(
                        Collectors.toMap(
                                (String key) -> key.substring(0, key.indexOf("=")).trim(),
                                (String value) -> value.substring(value.indexOf("=") + 1).trim()
                        )
                );
    }

    public Integer getYearMonth() {
        return yearMonth;
    }

    public void setYearMonth(Integer yearMonth) {
        this.yearMonth = yearMonth;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Map<String, String> getRemarksMap() {
        return remarksMap;
    }

    public void setRemarksMap(Map<String, String> remarksMap) {
        this.remarksMap = remarksMap;
    }


}
