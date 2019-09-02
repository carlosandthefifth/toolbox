public class describetype {
    public static void testclass () {
        // Create a new account as the generic type sObject
        sObject s = new Account();

        // Verify that the generic sObject is an Account sObject
        System.assert(s.getsObjectType() == Account.sObjectType);

        // Get the sObject describe result for the Account object
        Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();

        // Get the field describe result for the Name field on the Account object
        Schema.DescribeFieldResult dfr = Schema.sObjectType.Account.fields.Name;

        // Verify that the field token is the token for the Name field on an Account object
        System.assert(dfr.getSObjectField() == Account.Name);

        // Get the field describe result from the token
        dfr = dfr.getSObjectField().getDescribe();
        system.debug('dfr: ' + dfr);

        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();

        for(String fieldName: fieldMap.keySet()) {
            Schema.SObjectField field = fieldMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            system.debug('Label: ' + fieldDescribe.getLabel());
            system.debug('Name: ' + fieldDescribe.getName());
        }
    }

    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(Schema.DescribeSObjectResult dsor, Set<String> fields) 
    {
        // the map to be returned with the final data
        Map<String,Schema.DescribeFieldResult> finalMap = 
            new Map<String, Schema.DescribeFieldResult>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
                
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : fields){
            // skip fields that are not part of the object
            if (objectFields.containsKey(field)) {
            Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
            // add the results to the map to be returned
            finalMap.put(field, dr); 
            }
        }
        return finalMap;
    }

    public static void getFields(String objectName)
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
