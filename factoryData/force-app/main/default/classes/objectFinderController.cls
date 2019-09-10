public with sharing class objectFinderController {

    private static final boolean DEBUG_MODE = false;
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

    public class objectFinderException extends Exception {}

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

/*
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
    */

/*
    private static boolean fieldIsRequired(String fieldName) {
        Schema.SObjectField checkField;

        return checkField.get(fieldName).getDescribe().nillable;
    }
*/
    public static void getFields(String objectName)
    /*
        Used to find related objects 
        test3
    */
    {

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        sObject obj = targetType.newSObject();
        if (DEBUG_MODE) {
           system.debug('obj: ' + obj);
        }
        
      //  Schema.SObjectType anObject = objects.get(objectName);

        Schema.DescribeSObjectResult describeObject = targetType.getDescribe();

        Map<String, Schema.SObjectField> finalMap = describeObject.fields.getMap();
        if(DEBUG_MODE) {
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

    private static List<Sobject> queryParentRecords (String objectName)
    {
        integer queryLimit = system.Limits.getLimitQueryLocatorRows();
        String queryStr = 'SELECT ID FROM ' + objectName + ' LIMIT ' + queryLimit;
        if (DEBUG_MODE)
            system.debug('queryStr ' + queryStr);
        return Database.query(queryStr);
    }

    private static boolean requiredExceptionList(String objectName, String fieldName)
    {
        if (fieldName == 'ownerid') return true;
        if (fieldName == 'isprivate') return true;
        if (fieldName == 'ownerid') return true;
        if (fieldName == 'createdbyid') return true;
        if (fieldName == 'lastmodifiedbyid') return true;
        if (fieldName == 'isdeleted') return true;
        if (fieldName == null) return true;
        if (fieldName == objectName) return true;

        return false;
    }

    @AuraEnabled
    public static void createRecords(String objectName, Integer count) {
        if (DEBUG_MODE)
            system.debug('objectName: '  + objectName);
        //Casting String to sObject
        SObject obj;
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        
        Map<String, List<SObject>> parentRecords = new Map<String,List<SObject>>();

        List<String> requiredFields = new List<String>();

        Map<String,Integer> parentCounts = new Map<String,Integer>();

        for (String field : fieldMap.keySet()){
            string fieldType = string.valueOf(fieldMap.get(field).getDescribe().type);
            if (fieldType == 'REFERENCE') {
                if(DEBUG_MODE) {
                    system.debug('finalmap.get(field).getDescribe().relationshipname: ' + fieldMap.get(field).getDescribe().referenceto);
                    system.debug('field: ' + field);
                    system.debug('string.valueOf(fieldMap.get(field).getDescribe().type: ' + fieldType);
                }
                if (!requiredExceptionList(objectName, field)) {
                    if(DEBUG_MODE)
                        system.debug('fieldMap.get(' + field + ').getDescribe().relationshipname: ' + fieldMap.get(field).getDescribe().referenceto);
                    if (fieldMap.get(field).getDescribe().referenceto != null) {
                        string objectNameStr = string.valueOf(fieldMap.get(field).getDescribe().referenceto);
                        objectNameStr = objectNameStr.remove('(');
                        objectNameStr = objectNameStr.remove(')');
                        if(DEBUG_MODE) {
                            system.debug('objectNameStr: ' + objectNameStr);
                            system.debug('getting: ' + queryParentRecords(objectNameStr));
                            system.debug('field: ' + field);
                        }
                        parentRecords.put(field,queryParentRecords(objectNameStr));
                        parentCounts.put(field,0);
                    }
                    if (DEBUG_MODE) {
                        system.debug('field: ' + field);
                        system.debug('parentCounts.get(' + field + '): ' + parentCounts.get(field));
                        system.debug('parentRecords.get(' + field  + ')' + parentRecords.get(field));
                    }
                }
            }
           
            boolean isNillable = fieldMap.get(field).getDescribe().nillable;
            boolean isUpdateable = fieldMap.get(field).getDescribe().updateable;
            boolean isRequireException = requiredExceptionList(objectName, field);
            String fieldCheckType = string.valueOf(fieldMap.get(field).getDescribe().type);
            // isUpdateable =  (!isNillable && fieldCheckType == 'REFERENCE');
            if (DEBUG_MODE) {
                system.debug('logic test for field: ' + field);
                if (isNillable)
                    system.debug('logic test IS nillable');
                else 
                    system.debug('logic test NOT nillable');

                if (isUpdateable)
                    system.debug('logic test IS updateable');
                else 
                    system.debug('logic test NOT updateable');

                if (isRequireException)
                    system.debug('logic test IS in requiredexception list');
                else 
                    system.debug('logic test IS NOT in requiredexception list');
            }
            if(!isUpdateable && !isNillable && (fieldCheckType == 'REFERENCE'))
                isUpdateable = true; // This is a master-detail
            if (isNillable) {
                isNillable = (fieldCheckType != 'REFERENCE');
            } // reference fields should be updated if possible

            if (field == 'name') requiredFields.add(field);
            
            if (DEBUG_MODE) {
                system.debug('fieldCheckType: ' + fieldCheckType);
                if((!isNillable) && (isUpdateable) && (!isRequireException))  {
                    system.debug('skipping: ' + objectName);
                    if (fieldMap.get(field).getDescribe().nillable) 
                        system.debug('FIELD IS NOT REQUIRED');
                    else
                        system.debug('FIELD IS REQUIRED');
            }        
                requiredFields.add(field);
            }
        }
        //  Map<String, Schema.SObjectField> finalMap = obj.fields.getMap();
        if(DEBUG_MODE) {
            for (String field : requiredFields) {
                system.debug('field: ' + field);
                system.debug('type: ' + fieldMap.get(field).getDescribe().type);
            }
        }
        try {
            List<SObject> objects = new List<SObject>();
            if(DEBUG_MODE)
                system.debug('(requiredFields.size(): ' + (requiredFields.size()));
            for (integer i = 0; i < count; i++) {
                if (Limits.getCpuTime() >= Limits.getLimitCpuTime()) {
                    // There is not a way to catch a limit error so we have to detect the error and throw it ourselves
                    throw new objectFinderException('CPU Time Limit Exceeded');
                }
                if (DEBUG_MODE) 
                    system.debug('>>i: ' + i);
                obj = Schema.getGlobalDescribe().get(objectName).newSObject();
  //              obj.put('Name', 'Test ' + i);
                if (requiredFields.size() >0 ) {
                    for (String field : requiredFields) {
                        integer relationshipRecordCount = parentCounts.get(field);
                        if (DEBUG_MODE) {
                            system.debug('****relationshipRecordCount: ' + relationshipRecordCount);
                            system.debug('****field: ' + field);
                            system.debug('field: ' + field);
                        }
                        string fieldType = string.valueOf(fieldMap.get(field).getDescribe().type);
                        if (DEBUG_MODE)
                            system.debug('fieldType: ' + fieldType);

                        if(!fieldMap.get(field).getDescribe().updateable && (fieldType != 'REFERENCE')) continue;
                        if(requiredExceptionList(objectName,field)) continue;

                        if (fieldType == 'BOOLEAN') {
                            // do nothing
                        } else if (fieldType == 'CURRENCY' ) {
                            obj.put(field, 1000000);
                        } else
                        if (fieldType == 'DATE' ) {
                            if(DEBUG_MODE)
                                system.debug('1.a');
                            DATE dt = system.today().addDays(30);
                            if (DEBUG_MODE) {
                                system.debug('field: ' + string.valueOf(field));
                                system.debug('system.today().addDays(30): ' + dt.format());
                                system.debug('dt: ' + dt);
                            }
                            obj.put(field, dt);
                            if (DEBUG_MODE)
                                system.debug('2.a');
                        } else
                        if (fieldType == 'DATETIME' ) {
                            if (DEBUG_MODE) 
                                system.debug('1.E');
                            DATE dt = system.today().addDays(30);
                            if(DEBUG_MODE) {
                                system.debug('field: ' + string.valueOf(field));
                                system.debug('system.today().addDays(30): ' + dt.format());
                                system.debug('dt: ' + dt);
                            }
                            obj.put(field, dt);
                            if (DEBUG_MODE) 
                                system.debug('2.E');
                        } else
                        if (fieldType == 'DOUBLE') {
                            // do nothing
                        } else
                        if (fieldType == 'INTEGER') {
                            obj.put(field, 10);
                        } else
                        if (fieldType == 'EMAIL') {
                            obj.put(field,''); // add blank
                        } else
                        if (fieldType == 'REFERENCE') {
                            if (DEBUG_MODE) {
                                system.debug('field: ' + field);
                                system.debug('parentRecords.get(field).size(): ' + parentRecords.get(field).size());
                            }
                            if (parentRecords.get(field).size() <= 0) continue;
                            
                            if (relationshipRecordCount >= parentRecords.get(field).size()) {
                                relationshipRecordCount=0;
                                parentCounts.put(field,0);
                            }
                            if (DEBUG_MODE) {
                                system.debug('*** adding reference ***');
                                system.debug('1.b');
                                system.debug('1.bbb==> field: ' + field);
                                system.debug('parentRecords.get(field).size(): ' + parentRecords.get(field).size()); 
                                system.debug('parentCounts.get(field): ' + parentCounts.get(field));

                                system.debug('*****parentRecords.get(field)[parentCounts.get(field)]: ' + parentRecords.get(field)[parentCounts.get(field)].id);
                                obj.put(field, parentRecords.get(field)[parentCounts.get(field)].Id); 
                                relationshipRecordCount++;
                                parentCounts.put(field,relationshipRecordCount);    
                                system.debug('*** for field: ' + field);
                                system.debug('*** parentCounts.get(field): ' + parentCounts.get(field));                               
                                system.debug('2.b');
                            }
                        } else
                        if (fieldType == 'PICKLIST') {
                            if (DEBUG_MODE)
                                system.debug('1.c');                                    
                            List<Schema.PicklistEntry> entries = fieldMap.get(field).getDescribe().getPicklistValues();
                            if (DEBUG_MODE) {
                                for (Schema.PicklistEntry entry : entries) {
                                    system.debug('entry: ' + entry);
                                }
                            }
                            
                            if (DEBUG_MODE)
                                system.debug('entries.get(0): ' + entries.get(0).getValue());
                            obj.put(field, entries.get(0).getValue());
                            if (DEBUG_MODE)
                                system.debug('2.c');
                        } else if (fieldType == 'PERCENT') {
                            // Do nothing
                        } else if (fieldType == 'MULTIPICKLIST') {
                            // Do nothing
                        } else if (fieldType == 'TEXTAREA') {
                            // Do nothing
                        } else if (fieldType == 'TIME') {
                            obj.put(field, Time.newInstance(4, 06, 00, 00));
                        } else {
                            if (DEBUG_MODE) {
                                system.debug('1.d');
                                system.debug('field: ' + field);
                                system.debug('fieldType: ' + fieldType);
                            }
                            string value = 'test ' + i;
                            if (DEBUG_MODE) {
                                system.debug('field.length(): ' + fieldMap.get(field).getDescribe().getLength());
                                system.debug('value.length(): ' + value.length());
                            }
                            if (fieldMap.get(field).getDescribe().getLength() < value.length())
                                value = value.substring(fieldMap.get(field).getDescribe().getLength());
                            if (DEBUG_MODE)
                                system.debug('value: ' + value);
                            obj.put(field, value);
                            if (DEBUG_MODE)
                                system.debug('2.d');
                        }
                    }
                    if (DEBUG_MODE)
                        system.debug('ADDING OBJECT objects: ' + obj);
                    objects.add(obj);
                    if (DEBUG_MODE)
                        system.debug('after add obj');
                }
            }

            insert objects;
        } catch (Exception e) {
            system.debug('message: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static string deleteRecords(String objectName){
        try {
            integer queryLimit = system.Limits.getLimitQueryLocatorRows();
            String queryStr = 'SELECT ID FROM ' + objectName + ' LIMIT ' + queryLimit;
            List<SObject> objs = Database.query(queryStr);
            if (objs.size() > 0)
                delete objs;
        } catch (exception e) {
            return 'failed to delete object ' + objectName + ' with error message: ' + e.getMessage();
        }

        return 'SUCCESS';
    }    
}