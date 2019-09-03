public with sharing class objectNames {

    @AuraEnabled
    public static Map<string,integer> discoverObjects() {
        Map<string, integer> objects = new Map<string,integer>{'account'=>12,'contact'=>20,'opportunity'=>31,'case'=>26,'campaigns'=>4,'solutions'=>10};

        return objects;
    }    

}
