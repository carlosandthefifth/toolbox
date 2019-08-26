/*
         PROGRAMMER: Daniel Gustafson

         Date:  August 25, 2019

         PURPOSE: 
            Manages factory data including creation, deletion, inserting and updating

        VERSION NOTES:  
        1.0 will have just a simple account contact creation built in and deletion

        TODO: 
            * Make this class generic where you can pass it any object value and number and it will create those records.  
            * Define schema relationships between object. 
            * If the object does not exist, the class will have an option of creating the object and then adding records.  
*/

public class factoryData_asynchronous implements Queueable {

    public void execute(QueueableContext Context) {
    }

    public factoryData_asynchronous() {
        // no need for now
    }
    
 }