public class objectNameGrabber {

    public static List<String> objectNameList {get;set;}


    private static boolean isAvailable = true;
    private static boolean isSupported = true;

    @AuraEnabled
    public static void getObjectNames(){
        system.debug('inside getObjectNames');
        Map<String, Schema.SObjectType> Objects = Schema.getGlobalDescribe(); 
        List<String> unsupportedObjects = new List<String> {'ConferenceNumber','ExternalEventMapping','ExternalEventMappingShare',
        'ExternalEvent'};
        for (String AObject : Objects.keySet()) {
            isAvailable = true;
            Schema.SObjectType anObject = objects.get(AObject);
            system.debug('anObject: ' + anObject);

            

            Schema.DescribeSObjectResult describeObject = anObject.getDescribe();
            if (!describeObject.accessible) continue;
            isSupported = true;
            for (String unsupportedObject: unsupportedObjects) {
                if (describeObject.name == unsupportedObject) {
                    isSupported = false;
                    break;
                }
            }
            if (!isSupported) continue;
            system.debug('describeObject13: ' + describeObject.name);

            List<RecordTypeInfo> infos = describeObject.getRecordTypeInfos();
            
            for(RecordTypeInfo info: describeObject.getRecordTypeInfos()) {
                if (!info.available) {
                    isAvailable = false;
                    break;
                }
            }
            if (!isAvailable) continue;
            if (describeObject.getRecordTypeInfos().size() <= 0) continue;
            if(!describeObject.isCreateable()) continue;
            if (describeObject.getRecordTypeInfos() == null) continue;
            if((describeObject.isCustom() == false) && (describeObject.getRecordTypeInfos().size()) > 0)
                objectNameList.add(String.valueOf(anObject));  // type case schema.SObjectType to string
            else if (describeObject.isCustom()) 
                objectNameList.add(String.valueOf(anObject));  // type case schema.SObjectType to string
        }      
        objectNameList.sort();
    }


}
