package Entity;


public class Token {
    
    private String accType;
    private String ClientId;
    private String ClientSecret;
    private String redirectUri; 
    private String refreshToken;
    private String xeroToken;
    private String xeroTokenSecret;
    private String xeroTokenHandle;
    private String inUse;
    private int companyId;

    public Token(String accType, String ClientId, String ClientSecret, String redirectUri, String refreshToken, String inUse, int companyId) {
        this.accType = accType;
        this.ClientId = ClientId;
        this.ClientSecret = ClientSecret;
        this.redirectUri = redirectUri;
        this.refreshToken = refreshToken;
        this.inUse = inUse;
        this.companyId = companyId;
    }

    public Token(String accType, String ClientId, String ClientSecret, String redirectUri, String refreshToken, String xeroToken, String xeroTokenSecret, String xeroTokenHandle, String inUse, int companyId) {
        this.accType = accType;
        this.ClientId = ClientId;
        this.ClientSecret = ClientSecret;
        this.redirectUri = redirectUri;
        this.refreshToken = refreshToken;
        this.xeroToken = xeroToken;
        this.xeroTokenSecret = xeroTokenSecret;
        this.xeroTokenHandle = xeroTokenHandle;
        this.inUse = inUse;
        this.companyId = companyId;
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

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public void setInUse(String inUse){
        if (inUse.equals("1")){
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
    
    public String getInUseString(){
        return inUse;
    }

}


