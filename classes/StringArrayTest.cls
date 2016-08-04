public class StringArrayTest
{
    public static List<String> generateStringArray(Integer a)
    {
        //integer i;
        List<String> lstString=new List<String>();
        for (integer i=0;i<a;i++)
        {
            lstString.add('Test  [[]] '+i);
            System.debug(lstString);
        }
        return lstString;
        
    }
}