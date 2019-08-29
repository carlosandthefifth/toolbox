public class objectNameGrabber {

    public static List<String> objectNameList = new List<String>();

    @AuraEnabled
    public static List<string> getObjectNames(){
        Map<String, Schema.SObjectType> Objects = Schema.getGlobalDescribe(); 
        for (String AObject : Objects.keySet()) {
            Schema.SObjectType anObject = objects.get(AObject);
            system.debug('anObject: ' + anObject);
            objectNameList.add(String.valueOf(anObject));  // type case schema.SObjectType to string
        }      
        return objectNameList;
    }
}
