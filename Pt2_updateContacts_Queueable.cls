/**
 * Created by Ivan Tsiarentsyeu on 12.08.2021.
 */

// System.enqueueJob(new Pt2_updateContacts_Queueable());

public with sharing class Pt2_updateContacts_Queueable implements Queueable {

    public void execute(QueueableContext context){
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accounts = new List<Account>([SELECT Id, BillingAddress,(SELECT Id FROM Contacts)
                                                    FROM Account]);
        for (Account a : accounts) {
            if (a.BillingAddress <> null) {
                for (Contact c : a.Contacts) {
                    c.Is_Synced__c = false;
                    c.Processed_By_Queue__c = true;
                }
            }
        }
        tryToUpsertContacts(contactsToUpdate);
    }

    private static void tryToUpsertContacts(List<Contact> ContactsToUpsert){
        if (ContactsToUpsert<>null) {
            if (!ContactsToUpsert.isEmpty()) {
                try {
                    upsert ContactsToUpsert;
                } catch (DmlException e) {
                    System.debug(e);
                }
            }
        }
    }

}