public with sharing class callWebServicefromRanjna  {
    public callWebServicefromRanjna(){
        
    }
public static void TestCallWebService (){
    partnerSoapSforceComRanjna.soap sp= new partnerSoapSforceComRanjna.soap();
    partnerSoapSforceComRanjna.loginResult loginResult=
                 sp.login('srivastava.abhishek0005@gmail.com','prembeena123!');
    
    soapSforceComSchemasClassSoaphAbhi.sessionHeader_element sessionHeader =
            new soapSforceComSchemasClassSoaphAbhi.sessionHeader_element();
    sessionHeader.sessionid=loginResult.sessionid;
    
    soapSforceComSchemasClassSoaphAbhi.soapHelloWorld1 obj 
            = new soapSforceComSchemasClassSoaphAbhi.soapHelloWorld1();
    obj.timeout_x = 120000;
    obj.sessionHeader = sessionHeader;
    string str = obj.testService();
} 
}