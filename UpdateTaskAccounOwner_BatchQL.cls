/**
 * Created by IvanTsiarentsyeu on 09.08.2021.
 */

public class UpdateTaskAccounOwner_BatchQL implements
                Database.Batchable<sObject>, Database.Stateful {

    public Integer recordsProcessed = 0;
    public Integer batchesProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Owner.Name, (SELECT Id FROM Tasks WHERE Is_Synced__c = false) FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Task> tasks = new List<Task>();
        for (Account a : accounts){
            for (Task t : a.Tasks){
                t.Is_Synced__c = true;
                t.Account_Owner__c = a.Owner.Name;
                tasks.add(t);
                a.Updated_By_Task__c = true;
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update tasks;
        update accounts;
        batchesProcessed = batchesProcessed + 1;
    }

    public void finish (Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records, ' + batchesProcessed + ' batches ');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                JobItemsProcessed, TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id = :bc.getJobId()];
        System.debug(job);
    }
}