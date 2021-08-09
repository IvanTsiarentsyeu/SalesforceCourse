/**
 * Created by 77111 on 09.08.2021.
 */

public class UpdateContactsQueueable implements Queueable {

    private Map <Id, Account> newMap;
    private List<Account> oldList;

    public UpdateContactsQueueable (Map <Id, Account> newMap, List<Account> oldList) {
        this.newMap = newMap;
        this.oldList = oldList;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsToChange = new List<Contact>();
        for (Account a : oldList){
            if (a.BillingAddress <> newMap.get(a.Id).BillingAddress){
                for (Contact c : newMap.get(a.Id).Contacts){
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

