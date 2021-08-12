/**
 * Created by Ivan Tsairentsyeu on 12.08.2021.
 */

// Pt2_150Accounts_Future.updateContactsForBillingAddressNotEmpty(150);

public with sharing class Pt2_150Accounts_Future {

    public static void updateContactsForBillingAddressNotEmpty(Integer howManyAccounts) {
        if (!System.isBatch() && !System.isFuture() && !System.isQueueable() &&
                Limits.getLimitFutureCalls() > Limits.getFutureCalls()) {
            selectCheckAndUpdateContacts(howManyAccounts);
        } else {
            System.debug('Cant run future method in future/queueable/batch context');
        }
    }

    @Future
    private static void selectCheckAndUpdateContacts(Integer howManyAccounts){
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accounts = new List<Account>([SELECT Id, BillingAddress, (SELECT Id FROM Contacts)
                                                    FROM Account LIMIT : howManyAccounts]);
        for (Account a: accounts){
            if (a.BillingAddress <> null) {
                for (Contact c : a.Contacts) {
                    c.Is_Synced__c = false;
                    c.Processed_By_Future__c = true;
                    contactsToUpdate.add(c);
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