/*

https://success.salesforce.com/ideaView?id=08730000000aSCfAAM
*/

public with sharing class objectFinderController {

    private static final boolean DEBUG_MODE = true;
    private static List<String> objectNameList = new List<String>();
    private static List<String> recordList = new List<String>();

    // List of unsupported objects.  This variable is used to docuement.  We don't really use it on our program yet
    private static List<String> unsupportedObjects = new List<String> {'ConferenceNumber','ExternalEventMapping','ExternalEventMappingShare',
        'ExternalEvent','AppAnalyticsQueryRequest', 'CollaborationGroup', 'CollaborationGroupRecord', 'ContentBody', 'ContentVersion', 'Event',
        'FlowInterview', 'FlowRecordRelation', 'Idea','ProductRequestLineItem','Recommendation','QuickText','PromptAction','ProductTransfer','ProductRequired',
        'ProductRequest','Image','Asset','ProductItem','ProductConsumptionSchedule','ProductConsumed','Product2','Pricebook2','Order','DuplicateRecordSet',
        'DuplicateRecordItem','RecordAction','MacroInstruction','Macro','ExpressionFilter','ExpressionFilterCriteria','RecordAction','Task'};

    // List of objects allowed.  This is the complete list of allowable objects.  We also allow custom objects
    private static List<String> objectAllowList = new List<String> {'Account',  'Campaign', 'Case', 
         'ConsumptionSchedule', 'Contact', 'ContactRequest', 'Contract',  'Lead', 'Location', 'Opportunity', 'ReturnOrder', 
        'Shipment', 'Task', 'WorkOrder', 'WorkTypeGroup'};    

    public class objectFinderException extends Exception {}

    // fields for each object discovered
    private static Map<String,List<String>> objectFields = new Map<String,List<String>>();

    private static boolean isObjectSupported (string objectName) {
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
    public static List<string> showUnsupportedObjects(){
        return unsupportedObjects;
    }

    @AuraEnabled
    public static List<string> showAllowedObjects(){
        return objectAllowList;    
    }

    private static boolean isObjectAllowed (string objectName) {
        for (String allowedObject: objectAllowList) {
            if (objectname.indexOf('__c') > 0 ) return true;
            if (objectName == allowedObject) return true;
        }
        return false;
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
//            if (!isObjectSupported(describeObject.name)) continue; // Unsupported object
            if (!isObjectAllowed(describeObject.name)) continue; // Allowed objects list to future proof this code
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

    public static void getFields(String objectName)
    /*
        Method for debugging field attributes
    */
    {

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        sObject obj = targetType.newSObject();
        if (DEBUG_MODE) {
           system.debug('obj: ' + obj);
        }
        
        // Schema.SObjectType anObject = objects.get(objectName);

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
    /*
       Runs a dynamic query based on object name
    */
    {
        integer queryLimit = system.Limits.getLimitQueryLocatorRows();
        String queryStr = 'SELECT ID FROM ' + objectName + ' LIMIT ' + queryLimit;
        if (DEBUG_MODE)
            system.debug('queryStr ' + queryStr);
        return Database.query(queryStr);
    }

    private static boolean requiredExceptionList(String objectName, String fieldName)
    /*
        Fields that are not nillable and are updateable are required, but some fields have these attributes and they are really not required.
    */
    {
        if (fieldName == 'ownerid') return true;
        if (fieldName == 'isprivate') return true;
        if (fieldName == 'ownerid') return true;
        if (fieldName == 'createdbyid') return true;
        if (fieldName == 'lastmodifiedbyid') return true;
        if (fieldName == 'isdeleted') return true;
        if (fieldName == 'CampaignMemberRecordTypeId') return true;
        if (fieldName == 'recordtypeid') return true;
        if (fieldName == null) return true;
        if (fieldName == objectName) return true;

        return false;
    }

    @AuraEnabled
    public static void createRecords(String objectName, Integer count) 
    /*
        Method to create records for selected objects
    */
    {

        if (DEBUG_MODE)
            system.debug('objectName: '  + objectName);

        SObject obj; // for type casting

        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); // set up the schema class

        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap(); // get fields for object
        
        Map<String, List<SObject>> parentRecords = new Map<String,List<SObject>>(); // tracking related records

        List<String> requiredFields = new List<String>(); // Which fields are required

        Map<String,Integer> parentCounts = new Map<String,Integer>();  // How many parent records do we have per field
        
        for (String field : fieldMap.keySet()){
            
            string fieldType = string.valueOf(fieldMap.get(field).getDescribe().type);
            
            if (DEBUG_MODE) {
                if (fieldType != 'REFERENCE') {
                    if (!fieldMap.get(field).getDescribe().Updateable || !fieldMap.get(field).getDescribe().createable) {
                        system.debug('field ' + field + ' is not updateable or createable');
                    }
                }
            }
            
            if (fieldType == 'REFERENCE') {
                // If the field is a reference, we want to try and find related records
                if(DEBUG_MODE) {
                    system.debug('finalmap.get(field).getDescribe().relationshipname: ' + fieldMap.get(field).getDescribe().referenceto);
                    system.debug('field: ' + field);
                    system.debug('string.valueOf(fieldMap.get(field).getDescribe().type: ' + fieldType);
                }
                
                if (!requiredExceptionList(objectName, field)) {
                
                    if(DEBUG_MODE)
                        system.debug('fieldMap.get(' + field + ').getDescribe().relationshipname: ' + fieldMap.get(field).getDescribe().referenceto);
                
                    if (fieldMap.get(field).getDescribe().referenceto != null) {
                        string objectNameStr = string.valueOf(fieldMap.get(field).getDescribe().referenceto); // referenceto format is (object)
                        // to use the object name in a soql query we need to strip "(" and ")"
                        objectNameStr = objectNameStr.remove('(');
                        objectNameStr = objectNameStr.remove(')');
                        boolean multipleObjects = (objectNameStr.indexOf(',') > 0);

                        if(DEBUG_MODE) {
                            system.debug('objectNameStr: ' + objectNameStr);
                            if (!multipleObjects)
                                system.debug('getting: ' + queryParentRecords(objectNameStr));

                            system.debug('field: ' + field);
                            system.debug('objectNameStr.indexOf(,): '  + objectNameStr.indexOf(','));
                        }


                        if (multipleObjects) {
                            // Some relatedto strings are like this (Contact, Lead)
                            // We need to strip the "(" and ")" plus run a separate query for each object
                            List<String> multObjects = objectNameStr.split(',');
                            // Just grab the first object
                            parentRecords.put(field,queryParentRecords(multObjects[0]));
                            parentCounts.put(field,0);
                        } else {
                            parentRecords.put(field,queryParentRecords(objectNameStr));
                            parentCounts.put(field,0);
                        }
                    }

                    if (DEBUG_MODE) {
                        system.debug('field: ' + field);
                        system.debug('parentCounts.get(' + field + '): ' + parentCounts.get(field));
                        system.debug('parentRecords.get(' + field  + ')' + parentRecords.get(field));
                    }
                }
            }

            // Checks which fields are required.  We only care about updating required fields

            boolean isNillable = fieldMap.get(field).getDescribe().nillable;
            boolean isUpdateable = fieldMap.get(field).getDescribe().updateable;
            boolean isRequireException = requiredExceptionList(objectName, field);
            String fieldCheckType = string.valueOf(fieldMap.get(field).getDescribe().type);
            
            if(!isUpdateable && !isNillable && (fieldCheckType == 'REFERENCE'))
                isUpdateable = true; // This is a master-detail

            if (isNillable) {
                // We always want to update reference fields
                isNillable = (fieldCheckType != 'REFERENCE');
            } 

            if (field == 'name') requiredFields.add(field); // name is ALWAYS required
            
            if (DEBUG_MODE) {
                system.debug('fieldCheckType: ' + fieldCheckType);
            }
                
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

            if((!isNillable) && (isUpdateable) && (!isRequireException))  {
                // add required field
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

                // Sort fields by type
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
                            // do nothing.  Boolean (checkbox) fields are never required
                        } else if (fieldType == 'CURRENCY' ) {
                            obj.put(field, 1000000); // Put a bogus number 
                        } else
                        
                        if (fieldType == 'DATE' ) {

                            if(DEBUG_MODE)
                                system.debug('1.a');

                            DATE dt = system.today().addDays(30);// 30 days from today
                            
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

                            DATE dt = system.today().addDays(30); // 30 days from today
                            
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
                            if (field == 'geolocatoin__latitude__s') {
                                 obj.put(field,47.6101581);
                            } else if (field == 'geolocatoin__longitude__s') {
                                obj.put(field, -122.3345627);
                            } else {
                                obj.put(field, 1000.00); // Put a bogus number 
                            }
                        } else
                        if (fieldType == 'INTEGER') {
                            obj.put(field, 10);
                        } else
                        if (fieldType == 'LOCATION') {
                           // Handled by double type 
                        } else
                        if (fieldType == 'EMAIL') {
                            obj.put(field,'email@test.com');
                        } else
                        if (fieldType == 'REFERENCE') {

                            if (DEBUG_MODE) {
                                system.debug('field: ' + field);
                                system.debug('parentRecords.get(field).size(): ' + parentRecords.get(field).size());
                            }
                            
                            // Did we find any related records
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
                            }
                            
                            obj.put(field, parentRecords.get(field)[parentCounts.get(field)].Id); // add each record

                            relationshipRecordCount++;
                            
                            parentCounts.put(field,relationshipRecordCount);    

                            if (DEBUG_MODE) {
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
                            
                            obj.put(field, entries.get(0).getValue()); // grab first value in picklist

                            if (DEBUG_MODE)
                                system.debug('2.c');

                        } else if (fieldType == 'PERCENT') {
                            obj.put(field, 0.5);
                        } else if (fieldType == 'MULTIPICKLIST') {
                            List<Schema.PicklistEntry> entries = fieldMap.get(field).getDescribe().getPicklistValues();
                            obj.put(field, entries.get(0).getValue()); // grab first value in picklist
                        } else if (fieldType == 'TEXTAREA') {
                            obj.put(field, 'test data'); 
                        } else if (fieldType == 'TIME') {
                            obj.put(field, Time.newInstance(4, 06, 00, 00));
                        } else {
                            // should be a string type
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
            if (DEBUG_MODE) {
                system.debug('objects: ' + objects);
                system.debug('objects.size(): '  + objects.size());
            }

            if (objects.size()>0)
                insert objects;

        } catch (Exception e) {
            system.debug('message: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static string deleteRecords(String objectName)
    /*
        Deletes records for selected objects
    */
    {
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