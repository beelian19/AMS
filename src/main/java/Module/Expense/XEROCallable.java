package Module.Expense;

import Entity.Expense;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

public class XEROCallable implements Callable<ExpenseFactory> {

    private ExpenseFactory ef;

    public XEROCallable(ExpenseFactory ef) {
        this.ef = ef;
    }

    @Override
    public ExpenseFactory call() throws Exception {
        // Get list of expenses
        List<Expense> expenses = ef.getExpenses();
        List<Expense> processedExpenses = null;
        
        // Set up connection
        List<String> processMessage = new ArrayList<>();
        
        return ef;
    }

}
