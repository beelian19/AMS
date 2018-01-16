package Entity;

public class Token {

    private String accType;
    private String ClientId;
    private String ClientSecret;
    private String redirectUri;
    private String refreshToken;
    private String inUse;
    private int companyId;
    private String xeroToken;
    private String xeroTokenSecret;
    private String xeroTokenHandle;

    /**
     * Generic constructor. Only used for retrieving all tokens from database
     * 
     * @param accType
     * @param ClientId
     * @param ClientSecret
     * @param redirectUri
     * @param refreshToken
     * @param inUse
     * @param companyId
     * @param xeroToken
     * @param xeroTokenSecret
     * @param xeroTokenHandle 
     */
    public Token(String accType, String ClientId, String ClientSecret, String redirectUri, String refreshToken, String inUse, int companyId, String xeroToken, String xeroTokenSecret, String xeroTokenHandle) {
        this.accType = accType;
        this.ClientId = ClientId;
        this.ClientSecret = ClientSecret;
        this.redirectUri = redirectUri;
        this.refreshToken = refreshToken;
        this.inUse = inUse;
        this.companyId = companyId;
        this.xeroToken = xeroToken;
        this.xeroTokenSecret = xeroTokenSecret;
        this.xeroTokenHandle = xeroTokenHandle;
    }
    
    /**
     * Constructor for QBO Token
     * @param accType
     * @param ClientId
     * @param ClientSecret
     * @param redirectUri
     * @param refreshToken
     * @param inUse
     * @param companyId 
     */
    public Token(String accType, String ClientId, String ClientSecret, String redirectUri, String refreshToken, String inUse, int companyId) {
        this.accType = accType;
        this.ClientId = ClientId;
        this.ClientSecret = ClientSecret;
        this.redirectUri = redirectUri;
        this.refreshToken = refreshToken;
        this.inUse = inUse;
        this.companyId = companyId;
        this.xeroToken = "NA";
        this.xeroTokenSecret = "NA";
        this.xeroTokenHandle = "NA";
    }

    /**
     * Constructor for XERO Token
     * @param accType
     * @param redirectUri
     * @param inUse
     * @param companyId
     * @param xeroToken
     * @param xeroTokenSecret
     * @param xeroTokenHandle 
     */
    public Token(String accType, String redirectUri, String inUse, int companyId, String xeroToken, String xeroTokenSecret, String xeroTokenHandle) {
        this.accType = accType;
        this.ClientId = "NA";
        this.ClientSecret = "NA";
        this.redirectUri = redirectUri;
        this.refreshToken = "NA";
        this.inUse = inUse;
        this.companyId = companyId;
        this.xeroToken = xeroToken;
        this.xeroTokenSecret = xeroTokenSecret;
        this.xeroTokenHandle = xeroTokenHandle;
    }

    public String getAccType() {
        return accType;
    }

    public String getClientId() {
        return ClientId;
    }

    public String getClientSecret() {
        return ClientSecret;
    }

    public String getRedirectUri() {
        return redirectUri;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setClientId(String ClientId) {
        this.ClientId = ClientId;
    }

    public void setClientSecret(String ClientSecret) {
        this.ClientSecret = ClientSecret;
    }

    public void setRedirectUri(String redirectUri) {
        this.redirectUri = redirectUri;
    }

    
    
    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public void setInUse(String inUse) {
        if (inUse.equals("1")) {
            this.inUse = "1";
        } else {
            this.inUse = "0";
        }
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getXeroToken() {
        return xeroToken;
    }

    public void setXeroToken(String xeroToken) {
        this.xeroToken = xeroToken;
    }

    public String getXeroTokenSecret() {
        return xeroTokenSecret;
    }

    public void setXeroTokenSecret(String xeroTokenSecret) {
        this.xeroTokenSecret = xeroTokenSecret;
    }

    public String getXeroTokenHandle() {
        return xeroTokenHandle;
    }

    public void setXeroTokenHandle(String xeroTokenHandle) {
        this.xeroTokenHandle = xeroTokenHandle;
    }

    /**
     *
     * @return true if token is in use
     */
    public Boolean getInUse() {
        return inUse.equals("1");
    }

    public String getInUseString() {
        return inUse;
    }

}
