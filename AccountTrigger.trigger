/**
 * Created by Ivan Tsiarentsyeu on 08.08.2021.
 */

trigger AccountTrigger on Account (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {

    if (Trigger.isInsert && Trigger.isBefore){
        AccountTriggerHandler.onBeforeInsert(Trigger.new);
    }

    if (Trigger.isUpdate && Trigger.isBefore){
        AccountTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isDelete && Trigger.isBefore){
        AccountTriggerHandler.onBeforeDelete(Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isInsert && Trigger.isAfter){
        AccountTriggerHandler.onAfterInsert(Trigger.new, Trigger.newMap);
    }

    if (Trigger.isUpdate && Trigger.isAfter){
        AccountTriggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isDelete && Trigger.isAfter){
        AccountTriggerHandler.onAfterDelete(Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isUndelete && Trigger.isAfter){
        AccountTriggerHandler.onAfterUndelete(Trigger.new, Trigger.newMap);
    }
}