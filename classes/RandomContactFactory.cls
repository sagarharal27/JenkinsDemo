Public class RandomContactFactory
{
    Public static List<Contact> generateRandomContacts(Integer NumberOfContacts,String LName)
    {
        List<Contact> lstContact=new List<Contact>();
        for(Integer i=1;i<=NumberOfContacts;i++)
        {
            lstContact.add(new contact(FirstName='Test '+i,lastName=lName));
        }
        return lstContact;
    }
}