public class ContactQueryController{
    public List<Account> accountList{get;set;}
    public List<Contact> contactList{get;set;}
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
 
public ContactQueryController(){
    accountList = [select id, name from Account LIMIT 50];
    contactList = [Select id, name, account.name, email from Contact LIMIT 50];
 
}
 

}