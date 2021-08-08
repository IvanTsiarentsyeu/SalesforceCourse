/**
 * Created by 77111 on 08.08.2021.
 */

public with sharing class ShopHelper {
    static public void replicateShops(List<Shop__c> shopsToReplicate){
        List<Shop__c> replicatedShops = new List<Shop__c>();
        for (Shop__c s : shopsToReplicate){
            Shop__c replica = new Shop__c(RecordType=s.RecordType,
                    Name = s.Name + 'r',
                    Parent_Corporation__c=s.Parent_Corporation__c,
                    Director__c = s.Director__c);
            replicatedShops.add(replica);
        }
        insert replicatedShops;
    }
}