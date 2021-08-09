/**
 * Created by Ivan Tsiarentsyeu on 10.08.2021.
 */

public with sharing class UpdateContactMailingAdress_BatchIterable implements
                Database.Batchable<Sobject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    public Integer batchesProcessed = 0;

    public List<SObject> CustomIterable(){
        return new List<Account>([SELECT Id, BillingCountry, BillingState, BillingPostalCode, BillingCity, BillingStreet,
                                     (SELECT Id, Is_Synced__c FROM Contacts WHERE Is_Synced__c = false)
                                  FROM Account]);
    }

    public Iterable<SObject> start(Database.BatchableContext bc){
        return CustomIterable();
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for (Account a : accounts){
            for (Contact c : a.Contacts){
                c.Is_Synced__c = true;
                c.MailingCountry = a.BillingCountry;
                c.MailingState = a.BillingState;
                c.MailingPostalCode = a.BillingPostalCode;
                c.MailingCity = a.BillingCity;
                c.MailingStreet= a.BillingStreet;
                contacts.add(c);
                a.Updated_By_Contact__c = true;
                recordsProcessed = recordsProcessed + 1;
            }
        }
        if (contacts<>null) {
            update contacts;
        }
        if (accounts<>null) {
            update accounts;
        }
        batchesProcessed = batchesProcessed + 1;
    }

    public void finish (Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records, ' + batchesProcessed + ' batches ');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                JobItemsProcessed, TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
        System.debug(job);
    }

}