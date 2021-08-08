/**
 * Created by Ivan Tsiarentsyeu on 08.08.2021.
 */

public with sharing class AccountHelper {

    @Future
    public static void createNegotiationTasks (List<Account> accountsToAddTasks) {
        List<Task> tasksToInsert = new List<Task>();
        for (Account a : accountsToAddTasks){
            tasksToInsert.add(createNegotiationTask(a));
        }
        if (tasksToInsert.size()>0){
            try {
                insert tasksToInsert;
            } catch (DmlException e) {
                System.debug(e);
            }
        }
    }

    private static Task createNegotiationTask (Account acct) {
        Task newTask = new Task (Subject = 'Negotiations with ' + acct.Name,
                WhatId = acct.Id,
                OwnerId = acct.OwnerId,
                Status = 'Not Started',
                Is_Synced__c = false);
        return newTask;
    }
}