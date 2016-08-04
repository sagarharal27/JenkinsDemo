global with sharing class countCloseWonOppBatch implements Database.Batchable<sObject>,Database.Stateful{
	global Map<string,List<Opportunity>> mapAccOpp;
	public string Query;
    public countCloseWonOppBatch (){
    	mapAccOpp=new Map<string,List<Opportunity>>();
   		string stage='Closed Won';
	  	Query='SELECT ID,Primary_Contact__c,(SELECT id, Name, Amount FROM Opportunities Where stageName=\''+ stage +'\') from Account WHERE Primary_Contact__c !=null';
   	}
   	global Database.QueryLocator start(Database.BatchableContext BC){
   		system.debug('Query +++'+Database.getQueryLocator(Query));
   		return Database.getQueryLocator(Query);
   	}
   	global void execute(Database.BatchableContext BC, List<Account> scope){
		if (scope.size()>0) {
			for(Account a:scope){
				mapAccOpp.put(a.Primary_Contact__c,a.Opportunities);
			}
			system.debug('Map ===== '+mapAccOpp); 
		}
   	}
   	global void finish(Database.BatchableContext BC){
   		List<Messaging.Singleemailmessage> lstEmail = new List<Messaging.Singleemailmessage>();
       	for(string mailId : mapAccOpp.keyset()) {
       		Decimal TotAmount=0;
       		string eBody='';
       		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
       		List<String> sendTo = new List<String>();
      		sendTo.add(mailId);
       		mail.setToAddresses(sendTo);
       		mail.setReplyTo('sagar.haral10@gmail.com');
			mail.setSenderDisplayName('Sagar Haral');
			mail.setSubject('Close Won Opp det..');
       		List<Opportunity> lstOpp=mapAccOpp.get(mailId);
       		if(lstOpp.size()>1) {
	       		for(Opportunity o:lstOpp){
	       			TotAmount=TotAmount+o.Amount;
	       			eBody=eBody+'Opportunity Name:'+o.name+';'+'Opportunity Amount :'+o.Amount+'\r\n';
	       		}
	       		eBody=eBody+' Total Amount Of Closed Won Opp is :'+	TotAmount;
				mail.setPlainTextBody(eBody);
				system.debug(system.loggingLevel.debug+'Your Mail @@@@@@@@:'+mail);
				lstEmail.add(mail);
       		}
       	}
       	Messaging.sendEmail(lstEmail); 
   	}
}