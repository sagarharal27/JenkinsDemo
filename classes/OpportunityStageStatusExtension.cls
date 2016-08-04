public with sharing class OpportunityStageStatusExtension{
    public List<String> statuses{get;set;}
    public String currentStatus{get;set;}
    public String objectName = 'Opportunity';
    public String fieldName = 'StageName';
 public OpportunityStageStatusExtension(ApexPages.StandardController controller)
  {
    
    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
    sObject obj = targetType.newSObject();
    obj = controller.getRecord();
       
   obj= database.query('select id,'+fieldName+' from '+objectName+' where id=\''+obj.id+'\' limit 1');
    
   if(obj != null) 
   {
        statuses=StageValues(objectName,fieldName);
        currentStatus=(String)obj.get(fieldName);
   }  
       
  }
    public static List<String> StageValues(String objectName,String FieldName)
    { 
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe(); 
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> ListValues=new List<String>();
        for (Schema.PicklistEntry a :ple )
        {
             ListValues.add(a.getValue());
        }
        return ListValues;
    }
    
}