/**
 * Created by Ivan Tsiarentsyeu on 08.08.2021.
 */

public with sharing class AccountTriggerHandler {

    public static void onBeforeInsert(List<Account> newList) {

    }


    public static void onBeforeUpdate(List<Account> newList, Map<Id, Account> newMap,
            List<Account> oldList, Map<Id, Account> oldMap) {

    }


    public static void onBeforeDelete(List<Account> oldList, Map<Id, Account> oldMap) {

    }


    public static void onAfterInsert(List<Account> newList, Map<Id, Account> newMap) {
        AccountHelper.createNegotiationTasks(newList);
    }


    public static void onAfterUpdate(List<Account> newList, Map<Id, Account> newMap,
            List<Account> oldList, Map<Id, Account> oldMap) {

    }


    public static void onAfterDelete(List<Account> oldList, Map<Id, Account> oldMap) {

    }


    public static void onAfterUndelete(List<Account> newList, Map<Id, Account> newMap) {

    }

}