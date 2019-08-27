public with sharing class createCustomObject {
    public createCustomObject() {
        MetadataService.MetadataPort service = MetadataServiceExamples.createService();
        MetadataService.CustomObject customObject = new MetadataService.CustomObject();
        customObject.fullName = 'Test__c';
        customObject.label = 'Test';
        customObject.pluralLabel = 'Tests';
        customObject.nameField = new MetadataService.CustomField();
        customObject.nameField.type_x = 'Text';
        customObject.nameField.label = 'Test Record';
        customObject.deploymentStatus = 'Deployed';
        customObject.sharingModel = 'ReadWrite';
        List<MetadataService.SaveResult> results =      
        service.createMetadata(
        new MetadataService.Metadata[] { customObject });       
        MetadataServiceExamples.handleSaveResults(results[0]);
    }
}
