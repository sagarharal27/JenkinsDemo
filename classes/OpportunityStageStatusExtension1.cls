public with sharing class OpportunityStageStatusExtension1{
    //List to hold statuses of records that want to display
    public List<String> statuses{get;set;}
    //String variable to store the current selected status
    public String currentStatus{get;set;}
    //String to hold the object name
    public String objectName = system.label.ObjectName;
    //String to hold field name
    public String fieldName = system.label.FieldName;
    //Map of to hold all objects name and their type
    public map<String,Schema.SObjectType> mapSobjectType;
    //map of field name and fields type
    public map<String,Schema.SObjectField> mapSobjectField;
    //Constructor to get the current record's satus values of picklist
    public OpportunityStageStatusExtension1(ApexPages.StandardController controller)
    {
        mapSobjectType = Schema.getGlobalDescribe();
        if(String.isNotBlank(objectName) && String.isNotBlank(fieldName) && mapSobjectType.containsKey(objectName)){
            mapSobjectField = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            Schema.SObjectType targetType = mapSobjectType.get(objectName);
            sObject obj = targetType.newSObject();
            obj = controller.getRecord();
             
            obj= database.query('select id,'+fieldName+' from '+objectName+' where id=\''+obj.id+'\' limit 1');
            
            if(obj != null) 
            {
                statuses = getStatusValues(objectName,fieldName);
                currentStatus=(String)obj.get(fieldName);
            }  
        }  
    }
    public  List<String> getStatusValues(String objectName,String FieldName)
    { 
        List<String> listValues = new List<String>();
        if(mapSobjectType.containsKey(objectName) && mapSobjectField.containsKey(FieldName)){
            for (Schema.PicklistEntry a : mapSobjectField.get(fieldName).getDescribe().getPicklistValues() )
            {
                 listValues.add(a.getValue());
            }   
        }
        return listValues;
    }
}