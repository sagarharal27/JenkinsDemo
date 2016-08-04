public class ContactAndLeadSearch
{
    public static List<List< SObject>> searchContactsAndLeads(String value)
    {
        List<List<sObject>> searchList = [FIND :value IN ALL FIELDS
                   RETURNING lead(Name),Contact(FirstName,LastName,Department)];
            return searchList ;
    }
}