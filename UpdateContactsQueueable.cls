/**
 * Created by 77111 on 09.08.2021.
 */

public class UpdateContactsQueueable implements Queueable {

    private List<Account> newList;
    private Map <Id, Account> oldMap;


    public UpdateContactsQueueable (List<Account> newList, Map <Id, Account> oldMap) {
        this.newList = newList;
        this.oldMap = oldMap;

    }

    /* Can't get Contacts through the Trigger variables (look at the log below)

    public void execute(QueueableContext context) {
        List<Contact> contactsToChange = new List<Contact>();
        for (Account a : newList) {
            System.debug('newList a.Contacts = ' + a.Contacts);
            System.debug('oldMap.get(a.Id).Contacts = ' + oldMap.get(a.Id).Contacts);
            List<Account> al = [SELECT Id, (SELECT Id, Name FROM Contacts) From Account Where Id = :a.Id];
            System.debug('al[0].Contacts' + al[0].Contacts);

            if (billingAdressChanged(a, oldMap.get(a.Id))) {
                for (Contact c : a.Contacts){
                    c.Is_Synced__c = false;
                    c.Processed_By_Queue__c = true;
                    contactsToChange.add(c);
                }
            }
        }
        tryToUpsertContacts(contactsToChange);
    }
    */
    /*
    22:50:10:007 USER_DEBUG [20]|DEBUG|newList a.Contacts = ()
    22:50:10:008 USER_DEBUG [21]|DEBUG|oldMap.get(a.Id).Contacts = ()
    22:50:10:022 USER_DEBUG [24]|DEBUG|al[0].Contacts(Contact:{AccountId=0015g00000N69ZgAAJ, Id=0035g00000AxhGTAAZ, Name=Akana Greatsky})
    */

    public void execute(QueueableContext context) {
        List<Contact> contactsToChange = new List<Contact>();
        for (Account a : [SELECT Id, BillingCountry, BillingCity, BillingStreet,
                                 BillingState, BillingPostalCode,
                                 (SELECT Id FROM Contacts)
                          FROM Account
                          WHERE Id in :newList]) {
            System.debug('newList a.Contacts = ' + a.Contacts);
            System.debug('oldMap.get(a.Id).Contacts = ' + oldMap.get(a.Id).Contacts);
            System.debug(a.BillingStreet);
            System.debug(oldMap.get(a.Id).BillingStreet);
            if (billingAdressChanged(a, oldMap.get(a.Id))) {
                for (Contact c : a.Contacts){
                    c.Is_Synced__c = false;
                    c.Processed_By_Queue__c = true;
                    contactsToChange.add(c);
                }
            }
        }
        tryToUpsertContacts(contactsToChange);
    }

    private static boolean billingAdressChanged (Account a, Account b) {
        return ((a.BillingCountry<>b.BillingCountry) || (a.BillingCity<>b.BillingCity) ||
                (a.BillingStreet<>b.BillingStreet) || (a.BillingState<>b.BillingState) ||
                (a.BillingPostalCode<>b.BillingPostalCode));
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

