/**
 * Created by Ivan Tsiarentsyeu on 12.08.2021.
 */

//Database.executeBatch(new Pt2_CopyAddress_QueryLocator());

public with sharing class Pt2_CopyAddress_QueryLocator implements
                Database.Batchable<sObject>, Database.Stateful {
    public Integer accountCount = 0;
    public Integer contactCount = 0;


    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, BillingCountry, BillingState, BillingPostalCode,\n' +
                '                                         BillingCity, BillingStreet,\n' +
                '                                         (SELECT Id, Is_Synced__c, Description FROM Contacts WHERE Is_Synced__c = false)\n' +
                '                                  FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        Boolean thisAccountIsNotUpdatedYet;
        for (Account a : accounts) {
            thisAccountIsNotUpdatedYet = true;
            for (Contact c : a.Contacts) {
                changeDescription(c); // for debugging
                copyAccountBillingToContactMailingAddress(a, c);
                c.Is_Synced__c = true;
                a.Updated_By_Contact__c = true;
                contactCount = contactCount +1;
                if (thisAccountIsNotUpdatedYet){
                    thisAccountIsNotUpdatedYet = false;
                    accountCount = accountCount + 1;
                }
                contacts.add(c);
            }
        }
        if (!contacts.isEmpty()) {
            update contacts;
        }
        if (!accounts.isEmpty()) {
            update accounts;
        }
    }

    public void finish (Database.BatchableContext bc) {
        System.debug(accountCount + ' accounts, ' + contactCount + ' contacts updated');
    }

    private void copyAccountBillingToContactMailingAddress (Account a, Contact c) {
        c.MailingCountry = a.BillingCountry + 'a';
        c.MailingState = a.BillingState;
        c.MailingPostalCode = a.BillingPostalCode;
        c.MailingCity = a.BillingCity;
        c.MailingStreet= a.BillingStreet;
    }

    private void changeDescription (Contact c) {
        if (c.Description==null) {
            c.Description = 'Pt2_QueryLocator is working ';
        } else {
            c.Description = 'Pt2_QueryLocator is working ' + c.Description;
        }
    }

}