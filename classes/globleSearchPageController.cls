public with sharing class globleSearchPageController {
	public string searchText {get; set;}
	public list<list<sObject>> soslResults {get;set;}
	public transient list<Lead> leadSearchResult{get;set;}
	public transient list<Contact> contactSearchResult{get;set;}
	public transient list<Account> accountSearchResult{get;set;}
	public transient list<Opportunity> opportunitySearchResult{get;set;}
	public integer displayPanel{get;set;}
	public globleSearchPageController() {
		displayPanel=0;
		}	
	public void getSearchResult() {
		displayPanel=1;
		if(searchText!='' && searchText!=null) { //isnotblank
			soslResults = [FIND :searchText IN ALL FIELDS RETURNING  
												lead(name,firstName,lastName),
												Contact(name,firstName,LastName),
												Account(name),
												Opportunity(name)];
			system.debug('Result= '+soslResults);
			leadSearchResult=soslResults[0] ;
			system.debug('Lead= '+soslResults[0]);
			
			contactSearchResult=soslResults[1];
			system.debug('contact= '+soslResults[1]);
			
			accountSearchResult=soslResults[2];
			system.debug('Acc= '+soslResults[2]);
			
			opportunitySearchResult=soslResults[3];
			system.debug('Opp= '+soslResults[3]);
	}
	}	
}