/**
 * Created by Ivan Tsiarentsyeu on 10.08.2021.
 */

global class UpdateContactMailingAddress_Schedulable implements Schedulable {
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new UpdateContactMailingAdress_BatchIterable());
    }
}