global with sharing class genericRecordCreationEngine implements Database.Batchable<sObject>,Database.Stateful{
	string defaultUrl;
	string query;
	global Map<string,string> FieldValues = new Map<string,string>();
	Map<string,Schema.SObjectType> MapobjectType = Schema.getGlobalDescribe();
	map<ID,sobject> mapSobjectInsert = new map<ID,sobject>();
	public genericRecordCreationEngine (){
   		defaultUrl='ap2.salesforce.com/';
   		query='SELECT id,JSON__C,Object_Name__c,Converted_Record__c FROM Event WHERE Converted_Record__c=\''+defaultUrl+'\'';
   	}
   	global Database.QueryLocator start(Database.BatchableContext BC){
   		return Database.getQueryLocator(query);
   	}
   	global void execute(Database.BatchableContext BC, List<Event> scope){
   		if(scope.size()>0){
	   		for(Event ev : scope){
				FieldValues =   (Map<string,string>)System.JSON.deserialize(ev.JSON__C, Map<string,string>.class);
				Schema.SObjectType objectType = MapobjectType.get(ev.Object_Name__c);
				sObject s=objectType.newsObject();
				for(string field : FieldValues.keySet()){
					s.put(field,FieldValues.get(field));
				}
				mapSobjectInsert.put(ev.ID,s);
	   		}
   		}
   		try{
   			system.debug('Map : '+mapSobjectInsert); 
   			insert mapSobjectInsert.values();
   		}
   		catch(DMLException e){
   		}
   		for(Event ev : scope) { 
   			ev.Converted_Record__c=ev.Converted_Record__c+mapSobjectInsert.get(ev.ID).id;
   		}
   		try{
   			update scope;
   		}
   		catch(DMLException e){
   		}
   	}
   	global void finish(Database.BatchableContext BC){ 
   		//insert lstInsert;
   		system.scheduleBatch(new genericRecordCreationEngine(),'My job', 1);
   	}
   	
}