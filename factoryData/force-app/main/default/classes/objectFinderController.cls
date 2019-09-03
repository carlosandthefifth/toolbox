public with sharing class objectFinderController {
    private static List<String> objectNameList = new List<String>();
    private static List<String> recordList = new List<String>();

    // Seems related to: https://success.salesforce.com/issues_view?id=a1p3A00000031xjQAA
    // List of unsupported objects.  These objects appear to be accessible through the API but from research it sounds like
    // objects that were not supposed to be accessible were made accessible but because they are not really, we get errors 
    // when trying to access the get getRecordTypeInfos() or any record field.  Trying to catch these errors is not possible 
    // because the error generated is an internal salesforce error which occurs internally before the exception reaches the code.
    // You cannot query the objects, but putting in a query checks results in 101 SOQL error.  The elegant way around this might be 
    // to create queuable batches that run in their own Apex transaction and avoid this error, but the easy solution (and since this is 
    // just a utility program) is to create an exception list like this:
    private static List<String> unsupportedObjects = new List<String> {'ConferenceNumber','ExternalEventMapping','ExternalEventMappingShare',
        'ExternalEvent'};
    private static boolean isSupported = true;

    // fields for each object discovered
    private static Map<String,List<String>> objectFields = new Map<String,List<String>>();

    private static boolean isSupported (string objectName) {
        // go through the exception list of objects
        // most unsupported objects can be found listed on this article
        // Unsupported Salesforce Objects and Fields in Analytics
        // https://help.salesforce.com/articleView?id=bi_integrate_salesforce_extract_transformation_unsupported_objects_fields.htm&type=5
        for (String unsupportedObject : unsupportedObjects) {
            if (objectName == unsupportedObject) return false;
        }
        return true;
    }

    @AuraEnabled
    public static List<String> getObjectNames(){
        system.debug('inside getObjectNames');
        Map<String, Schema.SObjectType> Objects = Schema.getGlobalDescribe(); 
        
        for (String AObject : Objects.keySet()) {
            Schema.SObjectType anObject = objects.get(AObject);

            Schema.DescribeSObjectResult describeObject = anObject.getDescribe();
        
            if (!describeObject.accessible) continue; // cannot access the object - skip
            if (!isSupported(describeObject.name)) continue; // Unsupported object
            if(!describeObject.isCreateable()) continue;

            if((describeObject.isCustom() == false) && (describeObject.getRecordTypeInfos().size()) > 0)
                objectNameList.add(String.valueOf(anObject));  // type case schema.SObjectType to string
            else if (describeObject.isCustom()) 
                objectNameList.add(String.valueOf(anObject));  // type case schema.SObjectType to string
        }      
        objectNameList.sort(); // sort ascending 
        return objectNameList;
    }

    @AuraEnabled
    public static List<String> getFields(String objectName){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        sObject obj = targetType.newSObject();
        system.debug('obj: ' + obj);
        
      //  Schema.SObjectType anObject = objects.get(objectName);

        Schema.DescribeSObjectResult describeObject = targetType.getDescribe();

        Map<String, Schema.SObjectField> finalMap = describeObject.fields.getMap();
        List<String> fields = new List<String>();

        for(String field : finalMap.keySet()) {
            if ((finalMap.get(field).getDescribe().accessible) && (finalMap.get(field).getDescribe().updateable))
                fields.add(String.valueOf(finalMap.get(field)));
        }        
        return fields;
    }
}