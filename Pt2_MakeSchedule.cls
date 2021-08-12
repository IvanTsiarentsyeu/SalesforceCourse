/**
 * Created by 77111 on 12.08.2021.
 */

// Pt2_MakeSchedule.make();

public with sharing class Pt2_MakeSchedule {
    public static void make() {
        Pt2_CopyAddressIterable_Schedulable job_iterable = new Pt2_CopyAddressIterable_Schedulable();
        Pt2_CopyAddressQLocator_Schedulable job_QL = new Pt2_CopyAddressQLocator_Schedulable();
        String schedule_15 = '30 15 * * * ?';
        String schedule_30 = '30 30 * * * ?';
        String schedule_45 = '30 45 * * * ?';
        String schedule_00 = '30 00 * * * ?';
        System.schedule('CopyAddressIterable 1', schedule_15, job_iterable);
        System.schedule('CopyAddressQLocator 1', schedule_30, job_QL);
        System.schedule('CopyAddressIterable 2', schedule_45, job_iterable);
        System.schedule('CopyAddressQLocator 2', schedule_00, job_QL);

    }

}