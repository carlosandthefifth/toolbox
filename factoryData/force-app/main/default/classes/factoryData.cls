public with sharing class factoryData {
/*
         PROGRAMMER: Daniel Gustafson

         Date:  August 24, 2019

         PURPOSE: 
            Manages factory data including creation, deletion, inserting and updating

        VERSION NOTES:  
        1.0 will have just a simple account contact creation built in and deletion

        TODO: 
            * Make this class generic where you can pass it any object value and number and it will create those records.  
            * Define schema relationships between object. 
            * If the object does not exist, the class will have an option of creating the object and then adding records.  
*/

    public enum verb {CREATE_ACCOUNTS,CREATE_CONTACTS,DELETE_ACCOUNTS,DELETE_CONTACTS}

    public static List<verb> verbs = new list<verb>();

    private static List<Account> Accounts = new List<Account>();
    private static List<Contact> Contacts = new LIst<Contact>();
    private static Map<Boolean,String> callTypes = new Map<Boolean,String>{true =>'synchronous', false => 'asynchronous'};

    public static integer maxAccount;
    public static integer maxContact;
    public static boolean isSynchronous = true;

    public class factoryDataException extends Exception{}

/*
    @future 
    private static void asynchronous_createContacts(integer maxContact)
    {
         if ((maxContact + Limits.getDmlRows()) > Limits.getLimitDMLRows()) {
              // We dont have sufficient limits to perform the action
            // Notice we don't check for isSynchronous.  This is because static variables reset for future calls since future calls
            // run in seperate apex transactions
          throw new factoryDataException('request to create ' + maxContact + ' records for Contact was denied because the DML limit ' +
            'for ' + callTypes.get(false) + ' calls in a single transaction is ' + Limits.getLimitDMLRows() + ' and number of DMLRows processed so far is '+
            Limits.getDmlRows());
            
        }
        try {
            integer accountIndex = 0;
            Accounts = [select id from account];
            for (integer i = 0; i < maxContact; i++) {
                Contact c = new Contact(lastName='Test ' + i, accountId=Accounts.get(accountIndex).id);
                Contacts.add(c);
                if (accountIndex == Accounts.size()-1) accountIndex=0;
                accountIndex++;
            }
            insert Contacts;
        } catch (Exception e) {
            system.debug('***factorydata createContacts');
            system.debug('Contacts size: ' + Contacts.size());
            system.debug('error message: ' + e.getMessage());
        }
    }
*/

    private static integer createAccounts()
    /*
        Creates account data to work with
    */ 
    {
        // Check our limits
        if ((maxAccount + Limits.getDmlRows()) > Limits.getLimitDMLRows() && (isSynchronous))  {
            // We dont have sufficient limits to perform the action

            throw new factoryDataException('request to create ' + maxAccount + ' records for Account was denied because the DML limit ' +
            'for ' + callTypes.get(isSynchronous) + ' calls in a single transaction is ' + Limits.getLimitDMLRows() + ' and number of DMLRows processed so far is '+
            Limits.getDmlRows());
            
        }
        if (isSynchronous) { 
            try {
                for (integer i = 0; i < maxAccount; i++) {
                    Account a = new Account(name='test ' + i);
                    Accounts.add(a);
                }
                insert Accounts;
            } catch (Exception e) {
                system.debug('***factorydata createAccounts');
                system.debug('Accounts size: ' + Accounts.size());
                system.debug('error message: ' + e.getMessage());
            }
        }
        else {            
          //  system.enqueueJob(new asynchronous_createAccounts(maxAccount));
        }
        return Accounts.size();
    }

    private static integer createContacts()
    {
         if ((maxContact + Limits.getDmlRows()) > Limits.getLimitDMLRows() && (isSynchronous)) {
            throw new factoryDataException('request to create ' + maxContact + ' records for Contact was denied because the DML limit ' +
            'for ' + callTypes.get(isSynchronous) + ' calls in a single transaction is ' + Limits.getLimitDMLRows() + ' and number of DMLRows processed so far is '+
            Limits.getDmlRows());
            
        }
        if (isSynchronous) {
        try {
            integer accountIndex = 0;
            Accounts = [select id from account];
            for (integer i = 0; i < maxContact; i++) {
                Contact c = new Contact(lastName='Test ' + i, accountId=Accounts.get(accountIndex).id);
                Contacts.add(c);
                if (accountIndex == Accounts.size()-1) accountIndex=0;
                accountIndex++;
            }
            insert Contacts;
        } catch (Exception e) {
            system.debug('***factorydata createContacts');
            system.debug('Contacts size: ' + Contacts.size());
            system.debug('error message: ' + e.getMessage());
        }
        } else {
            //system.enqueueJob(new asynchronous_createContacts(maxContact));          
        }

        return Contacts.size();       
    }

    private static integer deleteAccounts() {
        try {
            Accounts = [SELECT ID FROM Account LIMIT :limits.getLimitDMLRows()];
            delete Accounts;
        } catch (Exception e) {
            system.debug('***factorydata deleteAccounts');
            system.debug('Exception messsage: ' + e.getMessage());

        }

        return Accounts.size();
    }

    
    private static integer deleteContacts() {
        try {
            Contacts = [SELECT ID FROM Contact LIMIT :limits.getLimitDMLRows()];
            delete Contacts;
        } catch (Exception e) {
            system.debug('***factorydata deleteContacts');
            system.debug('Exception messsage: ' + e.getMessage());

        }
        return contacts.size();
    }


    public factoryData(integer maxAccount, integer maxContact) 
    {
        maxAccount = maxAccount;
        maxContact = maxContact;
    }

    public static integer execute(verb whichVerb) 
    {
        integer records = 0;
        switch on whichVerb {
            when CREATE_ACCOUNTS {
               records = createAccounts();
            }
            when CREATE_CONTACTS {
               records = createContacts();
            } 
            when DELETE_ACCOUNTS {
               records = deleteAccounts();
            } 
            when DELETE_CONTACTS {
               records = deleteContacts();
            }
            when else {
                system.debug('FACTORY DATA OBJECT NOT RECOGNIZED');        
            }
        }

        return records;
    }

    public static integer execute() 
    {
        // system.enqueueJob(new factoryData_asynchronous(1));
        return 0;
    }


    public class sendEmail implements Queueable {
        integer numOContacts;
        boolean finalRun = false;
        public void execute(QueueableContext Context) {
            system.debug('sendmail contacts: ' + this.numOContacts);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'gdansfdev@gmail.com'};

            mail.setBccAddresses(toAddresses);
            mail.setInReplyTo('gdansfdev@gmail.com');
            mail.setSenderDisplayName('system');
            mail.setSubject('queueable job done');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('queueable job done! contacts to go: ' + this.numOContacts);
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } catch (Exception e) {
                system.debug('inside sendEmail: ' + e.getMessage());
            } finally {
                if (!finalRun) {
                    system.debug('second contacts: ' + this.numOContacts);
                    // next action
                }
            }
        }

        public sendEmail(boolean processNext, integer contactcount)
        {
            system.debug('inside email');
            system.debug('contactcount: ' + contactcount);
            finalRun = !processNext;
            this.numOContacts = contactcount;
            system.debug('sendmail const contacts: ' + this.numOContacts);
        }
    }
}
