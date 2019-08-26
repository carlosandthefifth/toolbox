/*
         PROGRAMMER: Daniel Gustafson

         Date:  August 25, 2019

         PURPOSE: 
            Load records for standard object
        VERSION NOTES:  
        1.0 will have just a simple account contact creation built in and deletion

        TODO: 
            * Make this class generic where you can pass it any object value and number and it will create those records.  
            * Define schema relationships between object. 
            * If the object does not exist, the class will have an option of creating the object and then adding records.  

        EXAMPLE CALLS:
        system.enqueueJob(new factoryData_QuickTemplate_asynchronous());

        system.enqueueJob(new factoryData_QuickTemplate_asynchronous(true));

        system.enqueueJob(new factoryData_QuickTemplate_asynchronous.factoryData_QuickTemplate_Remove_asynchronous());

*/

public class factoryData_QuickTemplate_asynchronous implements Queueable {

    enum ObjectTypes {ACCOUNTS, PERSONACCOUNTS, CONTACTS, OPPORTUNITIES, CASES, LEADS, PRODUCTS}
    public class factoryDataQuickTemplateException extends Exception{}
    boolean contactsOnly = false;

    // Standard template for ORG with 200 MB
    Map<ObjectTypes,Integer> objectCount = new Map<ObjectTypes,Integer> {ObjectTypes.ACCOUNTS=>10000,ObjectTypes.CONTACTS=>10000,
            ObjectTypes.OPPORTUNITIES=>100,ObjectTypes.CASES=>200, ObjectTypes.LEADS=>300};

    public void execute(QueueableContext Context) {
        integer totalDMLRows = Limits.getLimitDmlRows();
        // Environmental check
        if (totalDMLRows <= 0 ) {
            // If we get here, potentially something is wrong with the ORG
            throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_asynchronous. ' +
                'Total rows that can be inserted: ' + totalDMLRows);
        }

        if (objectCount.get(ObjectTypes.ACCOUNTS) > totalDMLRows) {
            // If we get here, we asked for too many records
            throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_asynchronous. ' +
                'Total rows that can be insert is ' + totalDMLRows + ' we requested ' + 
                objectCount.get(ObjectTypes.ACCOUNTS));
        }

        if (!contactsOnly) {
            List<Account> Accounts = new List<Account>();
            for (integer i = 0; i < objectCount.get(ObjectTypes.ACCOUNTS); i++) {
                Account a = new Account(name='test ' + i);
                Accounts.add(a);
            }
            insert Accounts;
        }
        system.enqueueJob(new factoryData_QuickTemplate_Contacts_asynchronous(objectCount));
    }

    // Constructor
    public factoryData_QuickTemplate_asynchronous() {
        // no need for now
    }
    
    public factoryData_QuickTemplate_asynchronous(boolean ContactsOnly) 
    {
        this.contactsOnly = contactsOnly;
    }

    public class factoryData_QuickTemplate_Contacts_asynchronous implements Queueable{
        Map<ObjectTypes,Integer> objectCount;

        public void execute(QueueableContext Context) {
            // How many records can we insert here
            integer totalDMLRows = Limits.getLimitDmlRows();
            // Environmental check
            if (totalDMLRows <= 0 ) {
                // If we get here, potentially something is wrong with the ORG
                throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_Contacts_asynchronous. ' +
                    'Total rows that can be inserted: ' + totalDMLRows);
            }

            if (objectCount.get(ObjectTypes.CONTACTS) > totalDMLRows) {
                // If we get here, we asked for too many records
                throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_Contacts_asynchronous. ' +
                    'Total rows that can be insert is ' + totalDMLRows + ' we requested ' + 
                    objectCount.get(ObjectTypes.CONTACTS));
            }

            List<Account> Accounts = [SELECT id FROM ACCOUNT LIMIT :totalDMLRows]; // get as many recs as possible
            List<Contact> Contacts = new List<Contact>();

            Integer accountIndex=0;
            for (integer i = 0; i < objectCount.get(ObjectTypes.CONTACTS); i++) {
                Contact c = new Contact(Lastname='test ' + i, AccountId=Accounts.get(accountIndex).id);
                accountIndex++;
                if (accountIndex >= Accounts.size()) accountIndex = 0;
                Contacts.add(c);
            }
            insert Contacts;
            system.enqueueJob(new sendEmail(objectCount));
        }

        // Constructor
        public factoryData_QuickTemplate_Contacts_asynchronous(Map<ObjectTypes,Integer> objectCount) {
            this.objectCount = objectCount;
        }         
    }



    // Beginning of class to remove data
    public class factoryData_QuickTemplate_Remove_asynchronous implements Queueable{
        Map<ObjectTypes,Integer> objectCount;

        public void execute(QueueableContext Context) {
            // How many records can we insert here
            integer totalSOQLRows = Limits.getLimitDmlRows();
            system.debug('totalSOQLRows: ' + totalSOQLRows);
            // Environmental check
            if (totalSOQLRows <= 0 ) {
                // If we get here, potentially something is wrong with the ORG
                throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_Contacts_asynchronous. ' +
                    'Total rows that can be queried: ' + totalSOQLRows);
            }
            List<Account> Accounts = [SELECT id FROM ACCOUNT LIMIT :totalSOQLRows]; // get as many recs as possible
            delete Accounts;
            system.enqueueJob(new sendEmail(true));
        }

        // Constructor
        public factoryData_QuickTemplate_Remove_asynchronous() {
            // no need
        }

    }

    public class factoryData_QuickTemplate_Remove_Contacts_asynchronous implements Queueable{
        Map<ObjectTypes,Integer> objectCount;

        public void execute(QueueableContext Context) {
            // How many records can we insert here
            integer totalSOQLRows = Limits.getLimitDmlRows();
            // Environmental check
            if (totalSOQLRows <= 0 ) {
                // If we get here, potentially something is wrong with the ORG
                throw new factoryDataQuickTemplateException('Inside factoryData_QuickTemplate_Contacts_asynchronous. ' +
                    'Total rows that can be queried: ' + totalSOQLRows);
            }

            List<Contact> Contacts = [SELECT id FROM CONTACT LIMIT :totalSOQLRows]; // get as many recs as possible
            delete Contacts;
        }

        // Constructor
        public factoryData_QuickTemplate_Remove_Contacts_asynchronous() {
            // no need
        }

        
    }

    public class sendEmail implements Queueable {
        Map<ObjectTypes,Integer> objectCount;
        boolean contactsOnly = false;

        public void execute(QueueableContext Context) {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'gdansfdev@gmail.com'};

            mail.setToAddresses(toAddresses);
            mail.setInReplyTo('gdansfdev@gmail.com');
            mail.setSenderDisplayName('system');
            mail.setSubject('queueable job done');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            if (!contactsOnly) {
                mail.setPlainTextBody('queueable job done! \n' +
                                  'Accounts: ' + objectCount.get(ObjectTypes.ACCOUNTS) + '\n' +
                                  'Contact: ' + objectCount.get(ObjectTypes.CONTACTS));
            } else {
                mail.setPlainTextBody('delete process finished.  We can delete 10,000 records per transaction');

            }
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } catch (Exception e) {
                system.debug('inside sendEmail: ' + e.getMessage());
            } 
        }

        public sendEmail(Map<ObjectTypes,Integer> objectCount)
        {
            this.objectCount = objectCount;
        }

        public sendEmail(boolean contactsOnly)
        {
            this.contactsOnly = contactsOnly;
        }

    }

}