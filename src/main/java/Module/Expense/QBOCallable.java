package Module.Expense;

import DAO.QBODAO;
import DAO.TokenDAO;
import Entity.Expense;
import Entity.Token;
import com.intuit.ipp.core.Context;
import com.intuit.ipp.core.ServiceType;
import com.intuit.ipp.exception.FMSException;
import com.intuit.ipp.security.IAuthorizer;
import com.intuit.ipp.security.OAuth2Authorizer;
import com.intuit.ipp.services.DataService;
import com.intuit.oauth2.client.OAuth2PlatformClient;
import com.intuit.oauth2.data.BearerTokenResponse;
import com.intuit.oauth2.exception.OAuthException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

public class QBOCallable implements Callable<ExpenseFactory> {

    private ExpenseFactory ef;

    public QBOCallable(ExpenseFactory ef) {
        this.ef = ef;
    }

    // Process and submit expenses to quickbooks
    @Override
    public ExpenseFactory call() throws Exception {
        // Get list of expenses
        List<Expense> expenses = ef.getExpenses();
        List<Expense> processedExpenses = null;

        // Set up connection
        List<String> processMessage = new ArrayList<>();
        Token token = ef.getToken();
        String refreshToken = token.getRefreshToken();
        String accessToken = "";
        String realmid = ef.getRealmid();
        QBOoauth2ClientFactory factory = new QBOoauth2ClientFactory(token);
        OAuth2PlatformClient client = factory.getOAuth2PlatformClient();
        try {
            BearerTokenResponse bearerTokenResponse = client.refreshToken(refreshToken);
            refreshToken = bearerTokenResponse.getRefreshToken();
            accessToken = bearerTokenResponse.getAccessToken();
            token.setRefreshToken(refreshToken);
            TokenDAO.updateToken(token);
            IAuthorizer oauth;
            oauth = new OAuth2Authorizer(accessToken);
            Context context = new Context(oauth, ServiceType.QBO, realmid);
            DataService service = new DataService(context);
            QBODAO qbodao = new QBODAO(service);
            String initErrors = qbodao.init();
            if (qbodao.getInitHasError()) {
                processMessage.add("QBO init errors: " + initErrors);
                // return ef
            } else {
                // Submit expenses
                processedExpenses = qbodao.submitListOfExpenses(expenses);
            }

            token.setInUse("0");
            TokenDAO.updateToken(token);

        } catch (OAuthException oae) {
            processMessage.add("Refresh token failed @ QBOCallable: " + oae.getMessage());
        } catch (FMSException ex) {
            List<com.intuit.ipp.data.Error> erlist = ex.getErrorList();
            erlist.stream().forEach((er) -> {
                processMessage.add("FMSException caught " + er.getMessage());
            });
        }

        // Return expense factory
        ef.setProcessMessages(processMessage);
        if (processedExpenses != null) {
            ef.setExpenses(processedExpenses);
        }
        return ef;
    }

}
