public class exportCSVController {

    public List<List<myClass>> myList {get;set;}

    public exportCSVController() {
        myList = new List<List<myClass>>();
        List<myClass> temp = new List<myClass>();
        
        for(Integer i = 0; i < 50000; i++){
            if(temp.size() < 1000){
                myClass m = new myClass();
                m.val1 = 'val1 ' + i;
                m.val2 = 'val2 ' + i;
                m.val3 = 'val3 ' + i;
                m.val4 = 'val4 ' + i;
                m.val5 = 'val5 sdfdsfsfsssssssssssssssssssssssssssssssssss ssssssssssssssss ssssssssssss ssssssssssssssss ssssssssssssssss' + i;
                temp.add(m);
            }
            else{
                myList.add(temp);
                temp = new List<myClass>();
                myClass m = new myClass();
                m.val1 = 'val1 ' + i;
                m.val2 = 'val2 ' + i;
                m.val3 = 'val3 sdfsdfsd' + i;
                m.val4 = 'val4 ffffffffffffff sdfsdfsd' + i;
                m.val5 = 'val5 sdfdsfsfsssssssssssssssssssss dfsffffffffffffffffffffffffffffffffffffffffffssssssssssssssss ssssssssssssssss ssssssss ssssssssssssssss ssssssssssss ssssssssssssssss sssssss' + i;
                temp.add(m);
            }
        }
        myList.add(temp);
     system.debug('Heap size'+Limits.getHeapSize() );
    }
    
    public class myClass{
        public string val1 {get;set;}
        public string val2 {get;set;}
        public string val3 {get;set;}
        public string val4 {get;set;}
        public string val5 {get;set;}
    }
}