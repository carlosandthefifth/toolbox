public with sharing class objectNames {

    @AuraEnabled
    public static List<string> discoverObjects() {
        List<string> objects = new List<string>{'account:12','contact:20','opportunity:31','case:26','campaigns:4','solutions:10'};

        return objects;
    }    

}
