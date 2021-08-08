/**
 * Created by 77111 on 08.08.2021.
 */

public with sharing class ShopTriggerHandlerSingleton {

    final private static ShopTriggerHandlerSingleton instance = new ShopTriggerHandlerSingleton();
    public boolean replicate = true;

    private void ShopTriggerHandlerSingleton() {
    }

    public static ShopTriggerHandlerSingleton getInstance(){
        return instance;
    }

    public void replicateShops(List<Shop__c> shops){
        if (replicate) {
            replicate =false;
            ShopHelper.replicateShops(shops);
        }
    }

}