/**
 * Class Name: DynamicTriggerGenerator 
 * @Description: This is Helper class for class "UltraTrackContainerHandler".
                 This class check the trigger is exist or not for sObject.if trigger is not exist then generate the trigger.
  
  ========================================================================================================================
        Version   | Date        | Author             | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 16-11-2015  | Eternus Solution   | 1.Created Class
        1.2       | 29-11-2015  | Eternus Solution   | 1.removed UpdateTrigger method
   ========================================================================================================================
 */
public with sharing class DynamicTriggerGenerator {
     /**
        * @Author: Eternus Solutions
        * @Description : Method to create body of trigger in JSON form.
                        added @Future Annotation to call method asynchronous mode.
        * @Param : it takes object Name for creating the trigger on it and user session ID.
        * @Return : 
        * @Date:16/11/2015
    */ 
    public static HttpResponse res;
    @future(callout=true)
    public static void generateDynamicTrigger(String strSobjName,String strSessionId){
      if(String.isNotBlank(strSobjName) && String.isNotBlank(strSessionId)){
          String strTriggerName = strSobjName.remove('__')+system.Label.sObjectTriggerName;
          String strTriggerBody ='(after Update) { \\n if(trigger.isAfter && trigger.isUpdate){\\n ';
          strTriggerBody += 'DynamicTriggerGenericHandler objDataHandler = new DynamicTriggerGenericHandler();\\n ';
          strTriggerBody +='objDataHandler.onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, ' + '\'' +
                            strSobjName + '\'' + ');\\n';
          strTriggerBody +='}\\n}\\n\\n';
             
          String finalBody = 'Trigger '+strTriggerName+' On '+ strSobjName + ' ' + strTriggerBody; 
          String strJson = '{ "Name" : "'+strTriggerName +' ",'
                + '"TableEnumOrId" : "'+strSobjName+'",'
                + '"Body" : " '+ finalBody +' "}' ;
          if(!checkTriggerExistOrNot(strTriggerName)){
           CreateTrigger(strJson,strSessionId);
          }
      }
    }
    
     /**
       * @Author: Eternus Solutions
       * @Description : Method to check tigger exist or not.
       * @Param : it takes trigger Name as string.
       * @Return : boolean value
       * @Date:16/11/2015
    */ 
    public static Boolean checkTriggerExistOrNot(String strTriggerName){
        list<ApexTrigger> lstTrigger = new list<ApexTrigger>();
        if(String.isNotBlank(strTriggerName)){
            lstTrigger = [select ID,
                                 Name 
                                 FROM ApexTrigger 
                                 WHERE Name =:strTriggerName]; 
        }
        return (!lstTrigger.isEmpty()) ? true : false;
    } 
   
   /**
       * @Author: Eternus Solutions
       * @Description :Method will create trigger on sObject using REST API.
       * @Param : it takes trigger body in JSON Format as string and user session ID.
       * @Return :
       * @Date:16/11/2015
    */ 
    public static Void createTrigger(String strJson,String strSessionId)
    {
        if(String.isNotBlank(strJson) && String.isNotBlank(strSessionId)){
            try {
                HttpRequest req = new HttpRequest();
                req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v34.0/sobjects/ApexTrigger'); 
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer  ' +strSessionId);
                req.setBody(strJson);          
                 
                Http httpReq = new Http();
                res = httpReq.send(req);
            }
            catch(Exception e){

            }
        }
    }
}