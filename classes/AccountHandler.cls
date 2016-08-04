public class AccountHandler{
    public static Account insertNewAccount(string name){
        Account objAcc=new Account();
        objAcc.Name=name;
        try{
            insert objAcc;
            return objAcc;
        }catch(DMLException e)
        {
            return null;
        }
    }
}