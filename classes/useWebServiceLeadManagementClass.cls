public class useWebServiceLeadManagementClass {
    public static void callWebService() {
        //login and get session id from web service provider org using partnerWSDLFileclass
        partnerSoapSforceCom.soap sp = new partnerSoapSforceCom.soap ();
        partnerSoapSforceCom.loginResult loginResult = sp.login('sagar.haral10@gmail.com','espl!16689');
        
        //create sessionHeader by using webserviceWSDLClass
        soapSforceComSchemasClassLeadmanage.sessionHeader_Element sessionHeader = new soapSforceComSchemasClassLeadmanage.sessionHeader_Element();
        sessionHeader.sessionID = loginResult.sessionId;
        
        //create instance of webservice class that have web service method
        soapSforceComSchemasClassLeadmanage.leadManagementWebserviceClass obj = new soapSforceComSchemasClassLeadmanage.leadManagementWebserviceClass();
        obj.timeout_x=120000;
        obj.sessionHeader=sessionHeader;
        //call web service methods
        string leadCreatdResult = obj.createLead('LeadByExternal','LeadByExternal','Ex@gmail.com','11111');
            system.debug('leadCreatdResult :'+leadCreatdResult);
        string leadUpdateResult = obj.updateLead('LeadByExternal','LeadByExternal','Ex1@gmail.com','22222');
            system.debug('leadUpdateResult :'+leadUpdateResult );
        //string leadDeleteResult = obj.deleteLead('LeadByExternal','LeadByExternal','Ex1@gmail.com','22222');
        //    system.debug('leadDeleteResult :'+leadDeleteResult );
        
    }
}