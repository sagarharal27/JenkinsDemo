global with sharing class CalculatePMOBillingBatchClass implements Database.Batchable<sObject>, Database.Stateful{
	global final String query;
	global map<ID,Expense__c> mapProIdVsExpense;
	global map<ID,list<Time_Entry__c>> mapProIdVslstTimeEntry;
	global map<ID,Project__c> mapProject;
	public String strDescription = 'This is an automated Project Management expense that has been calculated based on the time billed.';
    
    global CalculatePMOBillingBatchClass(String query){
        this.query = query;
        mapProIdVsExpense = new map<ID,Expense__c>();
        mapProIdVslstTimeEntry = new map<ID,list<Time_Entry__c>>();
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('Query:'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<sObject> scope){
        Integer intSumOfTotHours;
        Integer intAmount;
        map<ID, Expense__c> mapProIdVsExpenseToUpsert = new map<ID, Expense__c>();
        list<Time_Entry__c> lstTimeEntryToUpdate = new list<Time_Entry__c>();
        list<Time_Entry__c> lstTimeEntry = (list<Time_Entry__c>) scope;
        for(Time_Entry__c objTimeEntry : lstTimeEntry){
            if(String.isNotBlank(objTimeEntry.Project__c)) {
                if(mapProIdVslstTimeEntry.containsKey(objTimeEntry.Project__c)){
                    mapProIdVslstTimeEntry.get(objTimeEntry.Project__c).add(objTimeEntry);
                }
                else{
                    mapProIdVslstTimeEntry.put(objTimeEntry.Project__c, new list<Time_Entry__c>{objTimeEntry});
                }
            }
        }
        if(!mapProIdVslstTimeEntry.keySet().isEmpty()){
            mapProject = new map<ID,Project__c>([SELECT ID,
                                                Name,
                                                Applied_PM_Billing__c,
                                                Hourly_Rate__c 
                                                FROM Project__c 
                                                WHERE ID IN: mapProIdVslstTimeEntry.keySet()]);
            for(ID projectID : mapProIdVslstTimeEntry.keySet()){
                if(mapProIdVslstTimeEntry.containsKey(projectID)){
                    intSumOfTotHours = 0;
	                for(Time_Entry__c objTimeEntry : mapProIdVslstTimeEntry.get(projectID)){
	                    try{
	                       intSumOfTotHours += Integer.valueOf(objTimeEntry.Total_Hours__c);
	                    }
	                    catch(Exception e){
	                    }
	                }
	                if(mapProject.containsKey(projectID)){
	                    try{
	                       intAmount = (intSumOfTotHours * Integer.valueOf(mapProject.get(projectID).Applied_PM_Billing__c)) * Integer.valueOf(mapProject.get(projectID).Hourly_Rate__c);
	                    }
	                    catch(Exception e){
	                    }
	                    if(mapProIdVsExpense.containsKey(projectID)){
	                        mapProIdVsExpense.get(projectID).Amount__c = intAmount;
	                        mapProIdVsExpenseToUpsert.put(projectID, mapProIdVsExpense.get(projectID));
	                    }
	                    else{
	                        Expense__c objExpense = new Expense__c();
                            objExpense.Amount__c = intAmount;
                            objExpense.Description__c = strDescription;
                            objExpense.Name = mapProject.get(projectID).name;
                            mapProIdVsExpenseToUpsert.put(projectID, objExpense);
	                    }
	                }
                }
            }
            // updsert current context records
            if(!mapProIdVsExpenseToUpsert.values().isEmpty()){
                upsert mapProIdVsExpenseToUpsert.values();
            }
            // maintain project and related expense map to relate expense and project
            for(ID projID : mapProIdVsExpenseToUpsert.keySet()){
                if(!mapProIdVsExpense.containsKey(projID)){
                    mapProIdVsExpense.put(projID, mapProIdVsExpenseToUpsert.get(projID));
                }
            }
            // update expense id to scope
            for(Time_Entry__c objTimeEntry : lstTimeEntry){
                if(String.isNotBlank(objTimeEntry.Project__c) && mapProIdVsExpense.containsKey(objTimeEntry.Project__c)){
                    objTimeEntry.PMO_Billing__c = mapProIdVsExpense.get(objTimeEntry.Project__c).ID;
                    lstTimeEntryToUpdate.add(objTimeEntry);
                }
            }
            // Update PMO_Billing__c in Time_Entry__c
            if(!lstTimeEntryToUpdate.isEmpty()){
                update lstTimeEntryToUpdate;
            }
        }
        system.debug('mapProIdVsExpense='+mapProIdVsExpense);
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
}