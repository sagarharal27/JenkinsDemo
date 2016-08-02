public  without sharing class Abc {
    public void empFunction() {
       
        list<Account> empList=[Select e.Name 
                              From Account e];
       	
        
       system.debug(empList.size());
       system.debug(empList);
       
    }
}


/*

with sharing both classes  with private owd

Employee__c:{First_Name__c=Manager 2, Id=a0I28000000KtdFEAS}, 
Employee__c:{First_Name__c=Manager 1, Id=a0I28000000KtcMEAS}, 
Employee__c:{First_Name__c=Manager 3, Id=a0I28000000KtiKEAS}, 
Employee__c:{First_Name__c=HR 1, Id=a0I28000000KthvEAC})





*/