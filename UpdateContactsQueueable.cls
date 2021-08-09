/**
 * Created by 77111 on 09.08.2021.
 */

public class UpdateContactsQueueable implements Queueable {

    private Map <Id, Account> oldMap;
    private List<Account> oldList;

    public UpdateContactsQueueable (Map <Id, Account> oldMap, List<Account> oldList) {
        this.oldMap = oldMap;
        this.oldList = oldList;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsToChange = new List<Contact>();
        System.debug('oldlist ' + oldList);
        for (Account a : [
                SELECT Id, BillingStreet, BillingCity, BillingCountry,
                         (SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contacts)
                FROM Account
                WHERE Id IN :oldList]){
            if (a.BillingStreet <> oldMap.get(a.Id).BillingStreet){
                for (Contact c : a.Contacts){
                    c.Is_Synced__c = false;
                    c.Processed_By_Queue__c = true;
                    contactsToChange.add(c);
                }
            }
        }
        tryToUpsertContacts(contactsToChange);
    }

    private static void tryToUpsertContacts(List<Contact> ContactsToUpsert){
        if (ContactsToUpsert<>null) {
            if (ContactsToUpsert.size() > 0) {
                try {
                    upsert ContactsToUpsert;
                } catch (DmlException e) {
                    System.debug(e);
                }
            }
        }
    }
}

