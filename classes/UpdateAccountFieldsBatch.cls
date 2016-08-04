global class UpdateAccountFieldsBatch implements Database.Batchable<sObject>{
   global final String Query;
   global final String Field;
   global final String Value;

   global UpdateAccountFieldsBatch (String q, String f, String v){
             Query=q; Field=f;Value=v;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      for(Sobject s : scope){s.put(Field,Value); 
      }      update scope;
   }

   global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string email='sagarharal3333@gmail.com';
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('sagar.haral10@gmail.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('oh!! yes,Batch Process has completed');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }

}
/*
// Query for 10 accounts
String q = 'SELECT Industry FROM Account LIMIT 10';
String f = 'Industry';
String v = 'Consulting';
Id batchInstanceId = Database.executeBatch(new UpdateAccountFields(q,f,v), 5); 
*/