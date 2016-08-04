public class ContactSearch
{
    public static List<contact> searchForContacts(String LstName,String PostCode)
    {
        List<Contact> lstcon=new List<Contact>{[select id,name from contact 
                                                                     where lastName=:LstName 
                                                                     AND MailingPostalCode=:PostCode] };
        return lstcon;
    }
}