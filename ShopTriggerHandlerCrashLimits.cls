/**
 * Created by 77111 on 08.08.2021.
 */

public with sharing class ShopTriggerHandlerCrashLimits {

    public boolean replicate = true;
    public void replicateShops(List<Shop__c> shops){
        if (replicate) {
            replicate =false;
            ShopHelper.replicateShops(shops);
        }
    }

}