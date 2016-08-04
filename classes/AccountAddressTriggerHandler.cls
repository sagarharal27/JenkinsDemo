Public class AccountAddressTriggerHandler
{
    public void AccountAddressMatch(List<Account> lstAcc)
    {

        for(Account a:lstAcc)
        {
            if (a.Match_Billing_Address__c==true && a.BillingPostalCode !=null)
            {
                a.ShippingPostalCode=a.BillingPostalCode;
                            
            }
        }
        
    }
}