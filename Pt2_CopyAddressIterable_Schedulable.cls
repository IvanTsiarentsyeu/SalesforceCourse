/**
 * Created by 77111 on 12.08.2021.
 */

global class Pt2_CopyAddressIterable_Schedulable implements Schedulable {
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new Pt2_CopyAddress_Iterable());
    }
}