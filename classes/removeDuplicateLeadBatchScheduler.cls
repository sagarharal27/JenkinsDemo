global with sharing class removeDuplicateLeadBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		  removeDuplicateLeadBatch b = new removeDuplicateLeadBatch();  
		  ID batchprocessid = Database.executeBatch(b,10);
		}
}

/* to set schedule for after 3 hr
removeDuplicateLeadBatchScheduler scheObj =new removeDuplicateLeadBatchScheduler();
string sch='0 0 1/3 * * *'
system.schedule('My job 2',sch,scheObj);
*/