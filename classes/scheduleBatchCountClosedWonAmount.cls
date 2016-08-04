global with sharing class scheduleBatchCountClosedWonAmount implements Schedulable {
	global void execute(SchedulableContext sc) {
	  countCloseWonOppBatch b = new countCloseWonOppBatch();  
	  ID batchprocessid = Database.executeBatch(b,2);
	}
} 
/*
scheduleBatchCountClosedWonAmount b=new scheduleBatchCountClosedWonAmount();
String sch = '0 0 1 * * ?';
system.schedule('My First Job', sch, b);
*/