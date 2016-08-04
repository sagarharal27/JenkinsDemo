@isTest
public class TestVerifyDate
{
    public static testMethod void TestCheckDates()
    {
        Date d1=date.ValueOf('2015-09-15');
        Date d2=date.ValueOf('2015-09-29');
        Date d3;
        Date d4=date.ValueOf('2015-09-10');
        Date d5=date.valueof('2015-09-30');
       
        d3=VerifyDate.CheckDates(d1,d2);
        System.assertEquals(d2,d3);
        
        d3=VerifyDate.CheckDates(d1,d4);
        System.assertEquals(d5,d3);

    }
}