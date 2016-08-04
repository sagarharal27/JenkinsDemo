Public class TestCallSoapHello {

    public String testSoapLogin()
    {
            partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
            String username = 'sagar.haral10@gmail.com';
            String password = 'espl!16689';
            partnerSoapSforceCom.LoginResult loginResult = sp.login(username, password);
    
            system.debug('loginResult:::' + loginResult);
                    
            soapSforceComSchemasClassSoaphellow.SessionHeader_element sessionHeader = new soapSforceComSchemasClassSoaphellow.SessionHeader_element();
            sessionHeader.sessionId = loginResult.sessionId;
            
            soapSforceComSchemasClassSoaphellow.SoapHelloWorld soapHelloMethod = new soapSforceComSchemasClassSoaphellow.SoapHelloWorld();
    
            
            // The Web services have a maximum timeout of 2 minutes. The timeout value is in milliseconds.
            soapHelloMethod.timeout_x = 120000;
            soapHelloMethod.SessionHeader = sessionHeader;
            
            String callResult = soapHelloMethod.testService();
            system.debug('callResult :::' + callResult );
            
            return callResult;
        
    }
      
        
}