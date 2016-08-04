public class popup
{
public boolean displayPopup {get; set;}
public List<myClass> myList {get;set;}
public String amar {get; set;} public String HiddenVal {get;set;}
public void closePopup()
{
displayPopup = false;
amar = HiddenVal;
}
public void showPopup()
{
HiddenVal ='';
displayPopup = true;
myList = new List<myClass>();
for(Integer i = 0; i < 1000; i++){
                myClass m = new myClass();
                m.val1 = 'val1 ' + i;
                m.val2 = 'val2 ' + i;

                myList.add(m);
            
    }
} 
public class myClass{
        public string val1 {get;set;}
        public string val2 {get;set;}
    }
}