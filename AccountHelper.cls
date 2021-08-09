/**
 * Created by Ivan Tsiarentsyeu on 08.08.2021.
 */

public with sharing class AccountHelper {

    @Future
    public static void updateContactsFuture (List<Id> accountsIdList) {
        System.debug('accountsIdList' + accountsIdList);
        List<Contact> contactsToChange = new List<Contact>();
        for (Account a : [
                SELECT Id, (SELECT Id, Is_Synced__c, Processed_By_Future__c FROM Contacts)
                FROM Account
                WHERE Id IN :accountsIdList]){
            for (Contact c : a.Contacts) {
                c.Is_Synced__c = false;
                c.Processed_By_Future__c = true;
                contactsToChange.add(c);
            }
    }
        tryToUpsertContacts(contactsToChange);
    }

    public static List<Id> getIdsOfAccountsWithChangedBillingAddress (Map<Id, Account> newMap, List<Account> oldList){
        List<Account> accountsList = new List<Account>();
        for (Account a : oldList){
            System.debug(a.BillingStreet<>newMap.get(a.Id).BillingStreet);
            if (a.BillingStreet<>newMap.get(a.Id).BillingStreet){
                accountsList.add(a);
            }
        }
        System.debug('accountsList'+ accountsList);
        return getIdList(accountsList);
    }

    public static List<Id> getIdList(List<Account> accountsList){
        List<Id> idList = new List<Id>();
        for (Account a: accountsList){
            idList.add(a.Id);
        }
        System.debug('Idlist' + idList);
        return idList;
    }

    private static void tryToUpsertContacts(List<Contact> ContactsToUpsert){
        System.debug(ContactsToUpsert + ' size = ' + ContactsToUpsert.size());
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

    @Future
    public static void createNegotiationTasks (List<Id> accountsIdList) {
        List<Task> tasksToInsert = new List<Task>();
        for (Account a : [SELECT Id, OwnerId, Name FROM Account WHERE Id IN :accountsIdList]){
            tasksToInsert.add(createNegotiationTask(a));
        }
        tryToUpsertTasks(tasksToInsert);
    }

    private static Task createNegotiationTask (Account acct) {
        Task newTask = new Task (Subject = 'Negotiations with ' + acct.Name,
                WhatId = acct.Id,
                OwnerId = acct.OwnerId,
                Status = 'Not Started',
                Is_Synced__c = false);
        return newTask;
    }

    private static void tryToUpsertTasks(List<Task> tasksToUpsert){
        if (tasksToUpsert <> null) {
            if (tasksToUpsert.size() > 0) {
                try {
                    upsert tasksToUpsert;
                } catch (DmlException e) {
                    System.debug(e);
                }
            }
        }
    }

}