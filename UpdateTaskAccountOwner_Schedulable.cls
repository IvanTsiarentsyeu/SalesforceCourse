/**
 * Created by 77111 on 09.08.2021.
 */

global class UpdateTaskAccountOwner_Schedulable implements Schedulable {
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new UpdateTaskAccounOwner_BatchQL());
    }
}