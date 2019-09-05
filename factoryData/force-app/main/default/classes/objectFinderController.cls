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
    public static Map<String,Integer> getObjectNames(){
        system.debug('inside getObjectNames');
        Map<String,Integer> objectRecords = new Map<String,Integer>();
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
        for (integer i = 0; i < objectNameList.size(); i++) {
            objectRecords.put(objectNameList[i], 10);
        }
        return objectRecords;
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

    public static void getFields(String objectName)
    /*
        Used to find related objects 
        test
    */
    {

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        sObject obj = targetType.newSObject();
        system.debug('obj: ' + obj);
        
      //  Schema.SObjectType anObject = objects.get(objectName);

        Schema.DescribeSObjectResult describeObject = targetType.getDescribe();

        Map<String, Schema.SObjectField> finalMap = describeObject.fields.getMap();

        for(String field : finalMap.keySet()) {
            system.debug('field: ' + finalMap.get(field));
            system.debug('1' + finalmap.get(field).getDescribe().accessible);
            system.debug('2' + finalmap.get(field).getDescribe().aggregatable);
            system.debug('3' + finalmap.get(field).getDescribe().aipredictionfield);
            system.debug('4' + finalmap.get(field).getDescribe().autonumber);
            system.debug('5' + finalmap.get(field).getDescribe().bytelength);
            system.debug('6' + finalmap.get(field).getDescribe().calculated);
            system.debug('7' + finalmap.get(field).getDescribe().calculatedformula);
            system.debug('8' + finalmap.get(field).getDescribe().cascadedelete);
            system.debug('9' + finalmap.get(field).getDescribe().casesensitive);
            system.debug('10' + finalmap.get(field).getDescribe().compoundfieldname);
            system.debug('12' + finalmap.get(field).getDescribe().controller);
            system.debug('13' + finalmap.get(field).getDescribe().createable);
            system.debug('14' + finalmap.get(field).getDescribe().custom);
            system.debug('15' + finalmap.get(field).getDescribe().defaultedoncreate);
            system.debug('16' + finalmap.get(field).getDescribe().defaultvalue);
            system.debug('17' + finalmap.get(field).getDescribe().defaultvalueformula);
            system.debug('18' + finalmap.get(field).getDescribe().dependentpicklist);
            system.debug('19' + finalmap.get(field).getDescribe().deprecatedandhidden);
            system.debug('20' + finalmap.get(field).getDescribe().digits);
            system.debug('21' + finalmap.get(field).getDescribe().displaylocationindecimal);
            system.debug('22' + finalmap.get(field).getDescribe().encrypted);
            system.debug('23' + finalmap.get(field).getDescribe().externalid);
            system.debug('24' + finalmap.get(field).getDescribe().filterable);
            system.debug('25' + finalmap.get(field).getDescribe().filteredlookupinfo);
            system.debug('26' + finalmap.get(field).getDescribe().formulatreatnullnumberaszero);
            system.debug('27' + finalmap.get(field).getDescribe().groupable);
            system.debug('28' + finalmap.get(field).getDescribe().highscalenumber);
            system.debug('29' + finalmap.get(field).getDescribe().htmlformatted);
            system.debug('30' + finalmap.get(field).getDescribe().idlookup);
            system.debug('31' + finalmap.get(field).getDescribe().inlinehelptext);
            system.debug('32' + finalmap.get(field).getDescribe().label);
            system.debug('33' + finalmap.get(field).getDescribe().length);
            system.debug('34' + finalmap.get(field).getDescribe().localname);
            system.debug('35' + finalmap.get(field).getDescribe().mask);
            system.debug('36' + finalmap.get(field).getDescribe().masktype);
            system.debug('37' + finalmap.get(field).getDescribe().name);
            system.debug('38' + finalmap.get(field).getDescribe().namepointing);
            system.debug('39' + finalmap.get(field).getDescribe().nillable);
            system.debug('40' + finalmap.get(field).getDescribe().permissionable);
            system.debug('41' + finalmap.get(field).getDescribe().picklistvalues);
            system.debug('42' + finalmap.get(field).getDescribe().precision);
            system.debug('43' + finalmap.get(field).getDescribe().querybydistance);
            system.debug('44' + finalmap.get(field).getDescribe().referencetargetfield);
            system.debug('45' + finalmap.get(field).getDescribe().referenceto);
            system.debug('46' + finalmap.get(field).getDescribe().relationshipname);
            system.debug('47' + finalmap.get(field).getDescribe().relationshiporder);
            system.debug('48' + finalmap.get(field).getDescribe().restricteddelete);
            system.debug('49' + finalmap.get(field).getDescribe().restrictedpicklist);
            system.debug('50' + finalmap.get(field).getDescribe().scale);
            system.debug('51' + finalmap.get(field).getDescribe().searchprefilterable);
            system.debug('52' + finalmap.get(field).getDescribe().soaptype);
            system.debug('53' + finalmap.get(field).getDescribe().sobjectfield);
            system.debug('54' + finalmap.get(field).getDescribe().sortable);
            system.debug('55' + finalmap.get(field).getDescribe().type);
            system.debug('56' + finalmap.get(field).getDescribe().unique);
            system.debug('57' + finalmap.get(field).getDescribe().updateable);          
        }
        
    }
    
}