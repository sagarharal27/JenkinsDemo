public with sharing class genericRecordCreationEngineScheduler implements schedulable {
public void execute(SchedulableContext sc){
	genericRecordCreationEngine batch = new genericRecordCreationEngine();
	database.executeBatch(batch,2);
}
}
/*
genericRecordCreationEngineScheduler b=new genericRecordCreationEngineScheduler();
String sch = '59 * * * * ?';
system.schedule('My First Job', sch, b);
*/