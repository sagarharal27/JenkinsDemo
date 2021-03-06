/**
 * Class Name: HistoryWrapper
 * @Description: Wrapper class to store information regarding historical data 
                into the Attachments. This class is used in class"DynamicTriggerGenericHandler" to
                store data in attachments And also used in class"ViewDataController" to read data
                From Attachments.   
  ========================================================================================================================
        Version   | Date        | Author             | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 22-02-2016  | Eternus Solution   | 1. Created constructor and campareTo method.
        1.2       | 04-03-2016  | Eternus Solution   | 1. Added Method and class description.
   ========================================================================================================================
 */
 /*
 Implemented comparable interface to compare objects on the bases of ModifiedDateTime
 */
public with sharing class HistoryWrapper implements comparable {
	public String oldValue{get;set;}
	public String newValue{get;set;}
	public String parentID{get;set;}
	public String ModifiedById{get;set;}
	public String ModifiedByName{get;set;}
	public String ModifiedDateTime{get;set;}
	public String Action{get;set;}
	
	/*
     * @Description : Parameterised Constructor to set values related to history data.
     * @Paramenter  :1. oldValue old value for field
     *               2. newValue new value for field
     *               3. parentID record Id for record
     *               4. ModifiedById user Id who modified the record
     *               5. ModifiedByName user name who modified the record
     *               6. ModifiedDateTime DateTime when user modified the record
     *               7. Action action performed on record
    */
	public HistoryWrapper(String oldValue,
	                      String newValue,
	                      String parentID,
	                      String ModifiedById, 
	                      String ModifiedByName,
                          dateTime ModifiedDateTime,
                          String Action) {
                          	
        this.oldValue=oldValue;
        this.newValue=newValue;
        this.parentID=parentID;
        this.ModifiedById=ModifiedById;
        this.ModifiedByName=ModifiedByName;
        
        this.ModifiedDateTime = (ModifiedDateTime!= null)? ModifiedDateTime.format():'';  
        this.action=action;
    }
    
    /*
     * @Description : Method to sort wrapper base on ModifiedDateTime.
     * @Paramenter  : ObjToCompare object for wrapper to campare.
     * @Return      : Return -1 in case of desending order or 1 in asending order.
                      if campare object is null then return -1.
    */    
    public Integer compareTo(Object ObjToCompare) {
        Integer returnValue = 0;
        if(ObjToCompare != Null){
            HistoryWrapper that = (HistoryWrapper)ObjToCompare;  
            returnValue = (this.ModifiedDateTime > that.ModifiedDateTime) ? -1 : 1;
        }
        else{
            returnValue = -1;
        }
        return returnValue;
    }
}