/**
 * Class Name: ViewDataController
 * @Description: Class to display historical data for all object records.   
  ========================================================================================================================
        Version   | Date        | Author             | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 22-02-2016  | Eternus Solution   | 1. Created getObjects, getshowTrackHistoryData, getRendered  
                                                     |    redirectToUser, checkStartEndDateRange methods.
   ========================================================================================================================
 */
public with sharing class ViewDataController {
    
    public string selectedObject {get;set;}
    public map<ID,list<HistoryWrapper>> recordIdVsUltraTrackWrapperMap {get;set;}
    public map<Id, String> IdVsAccountNameMap {get;set;}
    public Id redirectToUserId {get;set;}
    public Date startDate {get;set;}
    public Date endDate {get;set;} 
    public UltraTrackUtilityClass objUtility {get;set;}
    public String redirectURL{get;set;}
    
    public map<string,Ultra_Track_Container__c> ultraTrackContainerMap = new map<string,Ultra_Track_Container__c>();
    map<string,UltraTrackWrapper> ultraTrackWrapperMap = new map<string,UltraTrackWrapper>();
   
    public ViewDataController() {
        objUtility = new UltraTrackUtilityClass();
        IdVsAccountNameMap = new map<Id, String>();
        recordIdVsUltraTrackWrapperMap = new map<ID,list<HistoryWrapper>>();
    } 
    
    /*
     @ Description : Method to get objects for which history traking is enabled.
     @Return    : list of selectOption.
    */
    public list<SelectOption> getObjects() {
        
        list<SelectOption> objectSelectedoptionsList = new list<SelectOption>();
        
        objectSelectedoptionsList.add(new SelectOption('','--None--'));
        for(Ultra_Track_Container__c trackContainerObj : [SELECT Object_Label__c, 
                                                                 Tracked_Fields__c, 
                                                                 Object_Name__c
                                                         FROM Ultra_Track_Container__c 
                                                         WHERE Is_Tracking_Enabled__c =: true]) {
                                    
            ultraTrackContainerMap.put(trackContainerObj.Object_Name__c,trackContainerObj);
            objectSelectedoptionsList.add(new SelectOption(trackContainerObj.Object_Name__c,
                                                           trackContainerObj.Object_Label__c
                                         ));
        }
        objectSelectedoptionsList.sort();
        return objectSelectedoptionsList; 
    }  
    
    /*
     @ Description : Method to get historical data for perticular object.
     @Return    : PageReference object.
    */
    public PageReference getshowTrackHistoryData() {
        list<string> selectedFieldsForTrackingField = new list<string>(); 
        this.recordIdVsUltraTrackWrapperMap = new map<ID,list<HistoryWrapper>>();
        IdVsAccountNameMap = new map<Id, String>();
        list<Attachment> jsonAttachmentForObjectList = new list<Attachment>();
        /*DateTime startDateTime = Datetime.newInstance(startDate,0,0,0);
        startDateTime = Datetime.newInstance(startDateTime.dateGMT(),0,0,0);
        DateTime endDateTime = Datetime.newInstance(endDate,0,0,0);
        endDateTime = Datetime.newInstance(endDateTime.dateGMT(),0,0,0);*/
        if(string.isNotBlank(selectedObject)) {
            
            jsonAttachmentForObjectList = [SELECT body, LastModifiedDate  
                                           FROM Attachment
                                           WHERE parentID =: ultraTrackContainerMap.get(selectedObject).ID 
                                           AND Name like :system.Label.AttachmentFileName+'%' 
                                           //AND (LastModifiedDate >=: startDateTime 
                                           //AND LastModifiedDate <=: endDateTime)
                                           limit 1];
            if(jsonAttachmentForObjectList.size() > 0 ){
                ultraTrackWrapperMap = new map<string,UltraTrackWrapper>();
                if(startDate == null && endDate == null){
	               
	                ultraTrackWrapperMap =(map<string,UltraTrackWrapper>)System.JSON.deserialize(
                                                                     jsonAttachmentForObjectList[0].body.toString(), 
                                                                     map<string,UltraTrackWrapper>.class);
                }
                else if(checkStartEndDateRange(jsonAttachmentForObjectList[0].LastModifiedDate.dateGMT()))  {
                	 ultraTrackWrapperMap =(map<string,UltraTrackWrapper>)System.JSON.deserialize(
                                                                     jsonAttachmentForObjectList[0].body.toString(), 
                                                                     map<string,UltraTrackWrapper>.class);
                }
                
            }
            
            if(ultraTrackContainerMap.containsKey(selectedObject) && 
               string.isNotBlank(ultraTrackContainerMap.get(selectedObject).Tracked_Fields__c)) {
                Ultra_Track_Container__c fhtDataHolderObj = ultraTrackContainerMap.get(selectedObject);
                if(fhtDataHolderObj.Tracked_Fields__c.contains(',')) {
                    
                    selectedFieldsForTrackingField = fhtDataHolderObj.Tracked_Fields__c.split(',');
                }
               else {
                   selectedFieldsForTrackingField.add(fhtDataHolderObj.Tracked_Fields__c);
               }
            }
            

           if(!selectedFieldsForTrackingField.isEmpty()){
               for(string fieldName : selectedFieldsForTrackingField){
                   if(ultraTrackWrapperMap.containsKey(fieldName)) {
                         for(HistoryWrapper objWrapper : ultraTrackWrapperMap.get(fieldName).lstHistory){
                             Date modifiedDate = Date.parse(objWrapper.ModifiedDateTime.split(' ')[0]);
                             if(recordIdVsUltraTrackWrapperMap.containsKey(objWrapper.parentId)){
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedDate)) {
                                        recordIdVsUltraTrackWrapperMap.get(objWrapper.parentId).add(objWrapper);
                                    }
                                }
                                else {
                                    recordIdVsUltraTrackWrapperMap.get(objWrapper.parentId).add(objWrapper);
                                }
                             }
                             else{
                                if(startDate != null || endDate != null) {
                                    if(checkStartEndDateRange(modifiedDate)) {
                                        recordIdVsUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                   new list<HistoryWrapper>{objWrapper});
                                    }
                                }
                                else {
                                    recordIdVsUltraTrackWrapperMap.put(objWrapper.parentId,
                                                                new list<HistoryWrapper>{objWrapper});
                                }
                                 
                             }
                         }
                    }
               }
               for(list<HistoryWrapper> objList : recordIdVsUltraTrackWrapperMap.values()) {
                    objList.sort();
               }
           }
           if(!recordIdVsUltraTrackWrapperMap.isEmpty()) {
               
               string query;
               set<Id> sObjectIdSet = recordIdVsUltraTrackWrapperMap.keySet();
               list<sObject> sObjectList = new list<sObject>();
               
               query = 'SELECT Id, Name';
               query += ' FROM '+ selectedObject;
               query += ' WHERE Id IN: sObjectIdSet';
               query += ' ORDER by Name' ;
               sObjectList = Database.query(query);
               
               if(!sObjectList.isEmpty()) {
                    for(sObject Objct : sObjectList) {
                        IdVsAccountNameMap.put((Id)Objct.get('Id'), (string)Objct.get('Name'));
                    }
               }
               //Generate URL for downloading result in csv or pfd
               //redirectURL = URL.getSalesforceBaseUrl().toExternalForm()+
              // '/apex/GenerateCsvFilePage?Param1='+selectedObject+'&Param2='+startDate+'&param3='+endDate;
            }
        }
        else{
            objUtility.displayMessage(ApexPages.severity.INFO,system.label.Object_Not_Selected);
        }
       return null;
    }
    /*
    public pageReference generatePdfFile(){
        String URL = '/Apex/GeneratePdfFilePage?Param1='+selectedObject+'&Param2='+startDate+'&param3='+endDate;
        PageReference pageRef = new PageReference(URL);
        pageRef.setRedirect(false);
        return pageRef;
    }
    */
    /*
     @ Description : Method to get rendered the div.
     @Return    : boolean.
    */
    public Boolean getRendered() { 
        return !IdVsAccountNameMap.isEmpty(); 
    }
    
    /*
     @ Description : Method to redirect to user detail page.
     @Return    : pageReference object.
    */
    public pageReference redirectToUser() {
        
        if(redirectToUserId != null) {
            string salesforceBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            PageReference redirectToUser = new PageReference(salesforceBaseUrl + '/'+redirectToUserId);       
            redirectToUser.setRedirect(true);       
            return redirectToUser;
        }
        return null;
    }
    
    /*
     @ Description : Method to check modified date of record should be in range.
     @Return    : boolean.
    */
    private boolean checkStartEndDateRange(Date modifiedDateTime) {
        boolean flag = false;
        if(startDate != null && endDate != null) {
            if(modifiedDateTime >= startDate && modifiedDateTime <= endDate) {
                flag = true;
            }
        }
        else if(startDate != null && endDate == null) {
            if(modifiedDateTime >= startDate) {
                flag = true;
            }
        }
        else if(startDate == null && endDate != null) {
            if(modifiedDateTime <= endDate) {
                flag = true;
           }
        }
        return flag;
    }

}