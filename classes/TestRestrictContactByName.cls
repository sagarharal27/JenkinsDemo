@isTest
Public class TestRestrictContactByName
{
    public static testMethod void TestTrigger()
    {
        Contact c=new Contact(lastName='INVALIDNAME');
        Test.startTest();
        Database.SaveResult result = Database.Insert(c, false);
        Test.stopTest();
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             result.getErrors()[0].getMessage());


    }
}