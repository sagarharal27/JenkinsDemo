public class ClosedOpportunityTriggerHandler
{
    Public void CreateTask(List<Opportunity> lstOpp)
    {
        List<Task> lstTaskToSave=new List<Task>();
        for(Opportunity opp:lstOpp)
        {
        if(opp.StageName=='Closed Won')
        {
            Task ObjTask=new Task();
            objTask.subject='Follow Up Test Task';
            objTask.Whatid=opp.id;
            lstTaskToSave.add(objTask);
        }
        }
        insert lstTaskToSave;
    }
}