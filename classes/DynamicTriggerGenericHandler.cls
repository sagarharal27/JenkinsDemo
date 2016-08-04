/**
 * Class Name: DynamicTriggerGenericHandler.
 * @Description: This class is generic handler for all dynamically generated triggers.
                 This stores the History data in attachment under Ultra_Track_Container__c object in JSON Format.  
  ===============================================================================================================================
        Version   | Date        | Author             | Comments
    -----------------------------------------------------------------------------------------------------------------------------
        1.0       | 16-11-2015  | Eternus Solution   | 1.Created Class for above functionality.
        1.1       | 23-02-2016  | Eternus Solution   | 1.added code review changes.
        1.2       | 26-02-2015  | Eternus Solution   | 1.store history data in attachment under object "Ultra_Track_Container__c"
                                                         instead of "FieldHistoryTrackSetting" object
        1.3       | 29-02-2015  | Eternus Solution   | 1.Removed describe call methods and added utility class for that.
        1.4       | 03-03-2015  | Eternus Solution   | 1.added generateActionString,getHistoryWrapperInstance Method.
   ==============================================================================================================================
 */
public with sharing class DynamicTriggerGenericHandler{
    //Map to hold user data for retrieving the name of user.
    public static map<ID,User> mapUser = new map<ID,User>([SELECT 
                                                           ID,
                                                           Name 
                                                           FROM User
                                                          ]);
    //Map of wrapper class "UltraTrackWrapper" to de serialize and serialize History data
    @TestVisible map<String,UltraTrackWrapper> mapUltraTrackWapper;
    //List to hold the history data and insert into Attachment file.
    list<HistoryWrapper> listHistoryWrapper;
    //Attachment object to create or update the attachment.
    Attachment objAtt;
    //List ID of Container record id's to query against Attachment.
    list<ID> utcIdList = new list<ID>();
    //List of Ultra_Track_Container__c to get selected field list
    list<Ultra_Track_Container__c> listUltraTrackContainer;
    //Utility class object to call methods
    public UltraTrackUtilityClass objUtility {get;set;}
    //string variables to store constant values.
    public static final String fieldId = 'ID';
    public static final String fieldLastModifiedById = 'LastModifiedById';
    public static final String fieldLastModifiedDate ='LastModifiedDate';
    public static final String strContentType = 'text/plain;charset=UTF-8';
    
    public DynamicTriggerGenericHandler(){
        listUltraTrackContainer = new list<Ultra_Track_Container__c>();
        objUtility = new UltraTrackUtilityClass();
    }
     /**
       * @Author: Eternus Solutions
       * @description : Method to create or update Attachment file on update of Sobject record.
       * @Param : It takes trigger.newMap,trigger.oldMap and strObjectName as string.
       * @Return :
       * @Date:29/2/2016
    */
    public void onUpdateStoreHistoryData(map<id,SObject> mapNewRecords,
                                         map<id,SObject> mapOldRecords,
                                         String strObjectName
                                        )
    {
        list<String> listSelectedFields = new list<String>();
        map<String,Ultra_Track_Container__c> mapSavedObjectFields =
                                           new map<String,Ultra_Track_Container__c>();
        map<ID,Attachment> mapIdAttachment = new map<ID,Attachment>();
        map<String,String> mapFieldsAndLabels = new map<String,String> ();
        
        if(string.isNotBlank(strObjectName)){
            mapFieldsAndLabels = objUtility.getFieldNamesAndLabels(strObjectName);
            listUltraTrackContainer =[SELECT Tracked_Fields__c,
                                             Is_Tracking_Enabled__c,
                                             Object_Name__c
                                             FROM Ultra_Track_Container__c
                                             WHERE Object_Name__c=:strObjectName
                                             limit 1];
            //process only if Is_Tracking_Enabled__cis enabled 
            if(!listUltraTrackContainer.isEmpty() && listUltraTrackContainer[0].Is_Tracking_Enabled__c)
            {    
                mapSavedObjectFields.put(listUltraTrackContainer[0].Object_Name__c,listUltraTrackContainer[0]); 
                utcIdList.add(listUltraTrackContainer[0].ID);
                if(string.isNotBlank(listUltraTrackContainer[0].Tracked_Fields__c)){
                    
                    listSelectedFields = listUltraTrackContainer[0].Tracked_Fields__c.split(',');
                }
                //Call method to get attachments related to Ultra_Track_Container__c object
                if(!utcIdList.isEmpty()){
                    mapIdAttachment = getAttachmentsRelatedToUTC(utcIdList);
                } 
                // if attachment is present for Container record
                if(mapSavedObjectFields.containsKey(strObjectName) 
                        && mapIdAttachment.containsKey(mapSavedObjectFields.get(strObjectName).ID))
                {
                    objAtt = new Attachment();
                    objAtt = mapIdAttachment.get(mapSavedObjectFields.get(strObjectName).ID); 
                    mapUltraTrackWapper = new map<String,UltraTrackWrapper>();
                    mapUltraTrackWapper = (map<String,UltraTrackWrapper>)System.JSON.deserialize(
                           objAtt.body.toString(), map<String,UltraTrackWrapper>.class);
                    
                    //iterate all selected fields
                    for(String selectedField : listSelectedFields) { 
                        listHistoryWrapper = new list<HistoryWrapper>();
                        
                        //iterate all trigger.new records
                        for(SObject record : mapNewRecords.values()) {
                            //Check old and new values of field is different
                            if(record.get(selectedField) != mapOldRecords.get(record.id).get(selectedField)) {
                               String action = '';
                               if(mapFieldsAndLabels.containsKey(selectedField)) {
                                   action = generateActionString(mapFieldsAndLabels.get(selectedField),
                                       String.valueOF(mapOldRecords.get(record.id).get(selectedField)),
                                       String.valueOf(record.get(selectedField)));
                               }
                               HistoryWrapper objHW = getHistoryWrapperInstance(
                                                   String.valueOF(mapOldRecords.get(record.id).get(selectedField)),
                                                   String.valueOf(record.get(selectedField)),
                                                   String.valueOf(record.get(fieldId)),
                                                   String.valueOF(record.get(fieldLastModifiedById)),
                                                   getUserNameFromID(String.valueOf(record.get(fieldLastModifiedById))),
                                                   (DateTime)record.get(fieldLastModifiedDate),
                                                   action
                                                   );
                               if(objHW != Null) {
                                    listHistoryWrapper.add(objHW);
                               }
                           }
                       }
                       if(mapUltraTrackWapper.containsKey(selectedField)){
                          mapUltraTrackWapper.get(selectedField).lstHistory.addAll(listHistoryWrapper);
                       }
                       else{
                           if(!listHistoryWrapper.isEmpty()){
                           mapUltraTrackWapper.put(selectedField,
                                                    new UltraTrackWrapper(selectedField,
                                                            mapFieldsAndLabels.get(selectedField),
                                                            listHistoryWrapper));
                           }
                       }
                    }
                    // update if values different
                    if(JSON.serialize(mapUltraTrackWapper) != objAtt.body.toString()) {
                       objAtt.body=blob.valueOf(JSON.serialize(mapUltraTrackWapper));
                       Try{
                        update objAtt;
                       }
                       catch(DMLException e){
                       }
                    }
                 }
                
                // if attachment is not present for Container record
                else if(mapSavedObjectFields.containsKey(strObjectName) 
                    && !mapIdAttachment.containsKey(mapSavedObjectFields.get(strObjectName).id)) 
                {
                    mapUltraTrackWapper = new map<String,UltraTrackWrapper>();
                    //iterate all selected fields
                    for(String selectedField : listSelectedFields) {
                        listHistoryWrapper = new list<HistoryWrapper>();
                        //iterate all trigger.new records
                        for(SObject record: mapNewRecords.values()) {
                            //Check old and new values of field is different
                            if(record.get(selectedField) != mapOldRecords.get(record.id).get(selectedField)) {
                               String action='';
                               if(mapFieldsAndLabels.containsKey(selectedField)) {
                                   
                                   action = generateActionString(mapFieldsAndLabels.get(selectedField),
                                       String.valueOF(mapOldRecords.get(record.id).get(selectedField)),
                                       String.valueOf(record.get(selectedField)));
                               }
                               HistoryWrapper objHW = getHistoryWrapperInstance(
                                                   String.valueOF(mapOldRecords.get(record.id).get(selectedField)),
                                                   String.valueOf(record.get(selectedField)),
                                                   String.valueOf(record.get(fieldId)),
                                                   String.valueOF(record.get(fieldLastModifiedById)),
                                                   getUserNameFromID(String.valueOf(record.get(fieldLastModifiedById))),
                                                   (DateTime)record.get(fieldLastModifiedDate),
                                                   action
                                                   );
                               if(objHW != Null) {
                                    listHistoryWrapper.add(objHW);
                               }
                           }
                       }
                       if(!listHistoryWrapper.isEmpty()){
                       mapUltraTrackWapper.put(selectedField,new UltraTrackWrapper(selectedField,
		                                                           mapFieldsAndLabels.get(selectedField),
		                                                           listHistoryWrapper));
                       }
                  }
                  objAtt = new Attachment(); 
                  objAtt.body = blob.valueOf(JSON.serialize(mapUltraTrackWapper));
                  objAtt.parentId = mapSavedObjectFields.get(strObjectName).ID;
                  objAtt.Name=system.Label.AttachmentFileName + mapSavedObjectFields.get(strObjectName).ID+'.txt';
                  objAtt.contentType = strContentType;
                  objAtt.isPrivate = false;
                  Try{
                      insert objAtt;
                  }
                  catch(DMLException e){
                  }
               } 
           }
        }
    }
     /**
       * @Author: Eternus Solutions
       * @description : Method to get User's Name from ID.
       * @Param : it takes User record Id as String.
       * @Return : It returns User's Name.
       * @Date:29/2/2016
    */
    public static String getUserNameFromID(String userID)
    {
        String name = '';
        if(String.isNotBlank(userID)){
            name = (mapUser.containsKey(userID))? mapUser.get(userID).Name:'';
        }
        return name;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to generate the action string.
       * @Param : it takes updated field's label, old value and new value as string.
       * @Return : It returns Action in specific format.
       * @Date:3/3/2016
    */
    public static String generateActionString(String fieldLabel, String oldValue, String NewValue){
        String action;
        //OldValue and NewValues can be null or blank so no need to check
        if(String.isNotBlank(fieldLabel)){
            action= 'Changed <b>'+ fieldLabel +' From'+ '</b> ';
            action +=  oldValue + ' To ';
            action += '<b>'+NewValue+'</b>';
        }
        return action;
    }
    /**
       * @Author: Eternus Solutions
       * @description : Method to create and return Instance of HistoryWrapper Class.
       * @Param : it takes updated field's old value and new value,record Id,
                ModifiedById, userName, Action as string And ModifiedDate as DateTime.
       * @Return : It returns HistoryWrapper Class's instance.
       * @Date:3/3/2016
    */
    public static HistoryWrapper getHistoryWrapperInstance(String oldValue, String newValue,
                                                    String recordID, String ModifiedById,
                                                    String userName, dateTime modifiedDate,
                                                    String action)
    {
        HistoryWrapper objHW = 
            new HistoryWrapper(oldValue, newValue, recordID, ModifiedById, userName, modifiedDate, action);
        return objHW;
    }
    
    /**
       * @Author: Eternus Solutions
       * @description : Method to get Attachments related to Ultra Track Container records .
       * @Param : it take the id list of Ultra Track Container object.
       * @Return :  it returns map of ID and attachment.
       * @Date:3/3/2016
    */
    public map<Id,Attachment> getAttachmentsRelatedToUTC(List<ID> utcIdList){
       map<ID,Attachment> mapIdAttachment = new map<ID,Attachment>();
       if(!utcIdList.isEmpty()){
           for(Attachment a:[SELECT id,parentid,body 
                                  FROM Attachment 
                                  WHERE parentid 
                                  IN :utcIdList 
                                  AND Name like :system.Label.AttachmentFileName+'%'])
	       {
	           mapIdAttachment.put(a.parentid,a);
	       }
       }
       return mapIdAttachment;
    }
}