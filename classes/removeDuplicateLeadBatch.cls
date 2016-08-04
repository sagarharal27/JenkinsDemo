global with sharing class removeDuplicateLeadBatch implements Database.Batchable<sObject>,Database.Stateful {
	public String Query;
	public set<string> uniqueSet=new set<string>();
	Schema.SObjectType objectType = Schema.getGlobalDescribe().get('Lead');
	//Map<String,Schema.SObjectField> mapFields = objectType.getDescribe().fields.getMap();
	List<Lead> LstLeadToDelete=new List<Lead> ();
	
	global removeDuplicateLeadBatch (){
		Query='SELECT ID,Name,Email,FirstName,LastName from Lead';
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(Query);
	}
	global void execute(Database.BatchableContext BC,List<Lead> scope){ 
		//Schema.SObjectField field=mapFields.get(Label.LeadDuplicateField);
		for(Lead lead : scope){		
			if(lead.get(Label.LeadDuplicateField)!=null){
				if(uniqueSet.contains(string.valueOF(lead.get(Label.LeadDuplicateField)))){  //string.valueOf(lead.get(field))
					LstLeadToDelete.add(lead);
				}
				else{
					uniqueSet.add(string.valueOf(lead.get(Label.LeadDuplicateField)));
				}
			}
		}
		try{
			delete LstLeadToDelete;
		}
		catch(DMLException e){
			system.debug('Exception '+e);
		}
	}
	global void Finish(Database.BatchableContext BC){
		
	}
}