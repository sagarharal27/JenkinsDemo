public with sharing class DisplayAccount {
	public List<Account> accounts{get;set;}
	public List<Contact> Contacts{get;set;}
	public List<Opportunity> Opportunities{get;set;}
	public String accID{get;set;}
	public DisplayAccount() {
		accounts=[SELECT 
				  ID,
				  Name,
				  Phone,
				  BillingCity
				  FROM Account
				  limit 10 ];
		Contacts=new List<contact>();
		Opportunities=new List<Opportunity>();
	}
	public void showContactAndOpp (){
		//String accID = ApexPages.currentPage().getParameters().get('id');
		system.debug('selected Id **'+accID);
		Contacts=[select name,email from contact where accountid=:accid];
		Opportunities=[select name,stageName  from Opportunity where accountid=:accid];
		
	}
}