global with sharing class SearchAccountController {
	public List<Account> Accounts{get;set;}
	public string searchText {get;set;}
	public List<Contact> contacts{get;set;}
	public set<string> setAccId;
	public string CID {get;set;}
	public list<String> AlphaList {get; set;}
	public String AlphaFilter {get; set;}
	
	public SearchAccountController (){
		Accounts=new List<Account>(); 
		contacts=new List<Contact>();
		AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
									  'J', 'K', 'L', 'M', 'N', 'O', 'P','Q', 'R', 
									  'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z','All'};
		//AlphaFilter='M';
	}
	public pageReference searchAccount() {
		if(string.isNotBlank(searchText)) {
			getSearchResult();	
		}
		else {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Input at least 3 characters to perform search'));
			return null;
		}
		return null;
	}
	public void getSearchResult() {
		Accounts=new List<Account>();
		contacts=new List<Contact>();
		setAccId=new set<string>();
		Accounts=[SELECT ID,
						 Name,
						 Phone ,
						 Account_First_Name__c,
						 Account_Last_Name__c 
						 FROM Account 
						 WHERE Name like: '%'+ searchText+'%'];
		if(Accounts.size()!=0) {
			for(Account a: Accounts){
				setAccId.add(a.id);
			}	
			
			contacts=[SELECT Id,
							 Name,
							 FirstName,
							 LastName 
							 FROM Contact 
							 WHERE AccountID IN:setAccId];	
			system.debug('Cont ####'+contacts.size());	
		}		  
	}
	public void getContactByAlphbet(){
		contacts=new List<Contact>();
		if(AlphaFilter!='All'){
			contacts=[SELECT Id,
							 Name,
							 FirstName,
							 LastName 
							 FROM Contact 
							 WHERE AccountID IN:setAccId 
							 AND name like :AlphaFilter +'%'];
		}else {
			contacts=[SELECT Id,
							 Name,
							 FirstName,
							 LastName 
							 FROM Contact 
							 WHERE AccountID IN:setAccId];
		}
	}
	@RemoteAction
    public static void doDeleteContact(String conId) {
    	system.debug('Delete con :'+conId);
        contact delCon=[select 
        				name 
        				from contact 
        				WHERE ID =:conId];
        delete delCon;
    }
    public void removeContact(){
    	for(integer i=0;i<contacts.size();i++){
    		if(contacts[i].id==CID){
    			contacts.remove(i);
    			break;
    		}
    	}
    }
    public void clearResult() {
		Accounts.clear();
		contacts.clear();
	}
	
}