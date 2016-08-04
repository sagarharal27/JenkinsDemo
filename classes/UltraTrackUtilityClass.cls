/**
 * Class Name: UltraTrackUtilityClass
 * @Description: Utility class for describe call.   
  ============================================================================================
        Version   | Date        | Author             | Comments
    ------------------------------------------------------------------------------------------
        1.0       | 29-02-2016  | Eternus Solution   | 1.added getFieldNamesAndLabels Method
   ===========================================================================================
 */
 public without sharing class UltraTrackUtilityClass{
    //Map to hold the object name and it's sobject Type
    static map<String, Schema.SObjectType> objMap {get{if(objMap == null) 
                                                       objMap =  Schema.getGlobalDescribe();
                                                       return objMap;} private set;}
    public UltraTrackUtilityClass(){
        objMap = Schema.getGlobalDescribe();
    }
    
    /**
        * @Author: Eternus Solutions
        * @description : Method to get the sObject's field names and field labels
        * @Param : it takes string sObject Name as param
        * Return : It returns map of field name as key and field label as value
        * Date:29/2/2016
    */
    public map<String,String> getFieldNamesAndLabels(String sObjectName){
        map<String,String> mapFieldNameAndLabel  = new map<String,String>();
        if(String.isNotBlank(sObjectName) && objMap.containsKey(sObjectName)){
           for(Schema.SObjectField fieldType : objMap.get(sObjectName).getDescribe().fields.getMap().values()){
               if(fieldType.getDescribe().isUpdateable()) {
                   mapFieldNameAndLabel.put(fieldtype.getDescribe().getName(),fieldtype.getDescribe().getLabel());
               }
           }
        }
        return mapFieldNameAndLabel;
    }
    /**
        * @Author: Eternus Solutions
        * @description : Method to display message on Pages
        * @Param : it takes string Message that to be displyed on page.
        * @Return :
        * @Date:29/2/2016
    */
    public void displayMessage(ApexPages.severity severity,String message){
        ApexPages.AddMessage(new ApexPages.Message(severity,message));
    }
    /**
        * @Author: Eternus Solutions
        * @description : Method to featch the History data from Attachment.
        * @Param : it takes 3 parameters Ultra_Track_Container__c,startDate and endDate as Date.
        * @Return : returns map of Record Id and History Data
        * @Date:28/3/2016
    */ 
    /*
    public map<ID,list<HistoryWrapper>> getRecordIdVsHistoryWrapperMap(Ultra_Track_Container__c objUTC,Date startDate,Date endDate) {
        list<string> selectedFieldsForTrackingField = new list<string>(); 
        map<ID,list<HistoryWrapper>> recordIdVsHistoryWrapperMap = new map<ID,list<HistoryWrapper>>();
        list<Attachment> jsonAttachmentForObjectList = new list<Attachment>();
        map<string,UltraTrackWrapper> ultraTrackWrapperMap = new map<string,UltraTrackWrapper>();
        
        if(objUTC !=null) {
            jsonAttachmentForObjectList = [SELECT body, LastModifiedDate  
                                           FROM Attachment
                                           WHERE parentID =: objUTC.ID
                                           AND Name like :system.Label.AttachmentFileName+'%' 
                                           limit 1];
           // deserialize attachment into map
            if(jsonAttachmentForObjectList.size() > 0 ){
                ultraTrackWrapperMap = new map<string,UltraTrackWrapper>();
                if(startDate == null && endDate == null){
                   
                    ultraTrackWrapperMap =(map<string,UltraTrackWrapper>)System.JSON.deserialize(
                                                 jsonAttachmentForObjectList[0].body.toString(), 
                                                 map<string,UltraTrackWrapper>.class);
                }
                else if(checkStartEndDateRange(startDate,endDate,jsonAttachmentForObjectList[0].LastModifiedDate.dateGMT()))  {
                     ultraTrackWrapperMap =(map<string,UltraTrackWrapper>)System.JSON.deserialize(
                                                 jsonAttachmentForObjectList[0].body.toString(), 
                                                 map<string,UltraTrackWrapper>.class);
                }
            }
            // retrive history data of selected fields 
            if(string.isNotBlank(objUTC.Tracked_Fields__c)) {
                if(objUTC.Tracked_Fields__c.contains(','))
                selectedFieldsForTrackingField = objUTC.Tracked_Fields__c.split(',');
                else
                selectedFieldsForTrackingField.add(objUTC.Tracked_Fields__c);
                    
               for(string fieldName : selectedFieldsForTrackingField){
                   if(ultraTrackWrapperMap.containsKey(fieldName)) {
                     for(HistoryWrapper objWrapper : ultraTrackWrapperMap.get(fieldName).lstHistory){
                         Date modifiedDate = Date.parse(objWrapper.ModifiedDateTime.split(' ')[0]);
                         if(recordIdVsHistoryWrapperMap.containsKey(objWrapper.parentId)){
                            if((startDate != null || endDate != null) && checkStartEndDateRange(startDate,endDate,modifiedDate)) {
                                    recordIdVsHistoryWrapperMap.get(objWrapper.parentId).add(objWrapper);
                            }
                            else {
                                recordIdVsHistoryWrapperMap.get(objWrapper.parentId).add(objWrapper);
                            }
                         }
                         else{
                            if((startDate != null || endDate != null) && checkStartEndDateRange(startDate,endDate,modifiedDate)) {
                                    recordIdVsHistoryWrapperMap.put(objWrapper.parentId,
                                                               new list<HistoryWrapper>{objWrapper});
                            }
                            else {
                                recordIdVsHistoryWrapperMap.put(objWrapper.parentId,
                                                            new list<HistoryWrapper>{objWrapper});
                            }
                         }
                     }
                 }
               }
               for(list<HistoryWrapper> objList : recordIdVsHistoryWrapperMap.values()) {
                    objList.sort();
               }
            }
        }
        return recordIdVsHistoryWrapperMap;
    }
    */
    /**
        * @Author: Eternus Solutions
        * @description : Method to check modifiedDate inbetween stard date and end date.
        * @Param : start date ,end date ranges and date to check inbetween.
        * @Return : returns true or false 
        * @Date:28/3/2016
    */
    /*
    private boolean checkStartEndDateRange(Date startDate,Date endDate,Date modifiedDateTime) {
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
    */
 }