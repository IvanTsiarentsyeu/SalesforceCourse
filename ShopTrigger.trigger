/**
 * Created by 77111 on 08.08.2021.
 */

trigger ShopTrigger on Shop__c (before insert) {
    // ShopTriggerHandlerCrashLimits handler = new ShopTriggerHandlerCrashLimits();
    ShopTriggerHandlerSingleton handler = ShopTriggerHandlerSingleton.getInstance();

    if (Trigger.isBefore && Trigger.isInsert) {
        handler.replicateShops(Trigger.new);
    }

}