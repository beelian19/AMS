/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Module.Expense;


import com.intuit.oauth2.client.OAuth2PlatformClient;
import com.intuit.oauth2.config.Environment;
import com.intuit.oauth2.config.OAuth2Config;
import Entity.Token;

public class QBOoauth2ClientFactory {
    
    private OAuth2PlatformClient client;
    private OAuth2Config oauth2Config;
    private String redirectUri;
    private String clientId;
    private String clientSecret;
    
    public QBOoauth2ClientFactory(Token token) {
        clientId = token.getClientId();
        clientSecret = token.getClientSecret();
        redirectUri = token.getRedirectUri();
        this.oauth2Config = new OAuth2Config.OAuth2ConfigBuilder(clientId,clientSecret).callDiscoveryAPI(Environment.PRODUCTION).buildConfig();
        this.client = new OAuth2PlatformClient(oauth2Config);
    }
    
    public OAuth2PlatformClient getOAuth2PlatformClient()  {
	return client;
    }
    
    public OAuth2Config getOAuth2Config()  {
	return oauth2Config;
    }
    
    public String getRedirectUri() {
        return redirectUri;
    }
    
    public String getClientId() {
        return clientId;
    }
    
    public String getClientSecret() {
        return clientSecret;
    }
}
