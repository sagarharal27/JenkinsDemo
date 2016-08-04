public class NewCaseListController
{
public  List<case> getNewCases()
{
    List<Case> lstCase=[select id,CaseNumber from case where status='New' ];
    system.debug('############ '+lstCase);
    return lstCase;
}
}