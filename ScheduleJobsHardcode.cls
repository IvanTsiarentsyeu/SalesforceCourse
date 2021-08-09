/**
 * Created by 77111 on 09.08.2021.
 */

public with sharing class ScheduleJobsHardcode {
    static public void run() {
        UpdateTaskAccountOwner_Schedulable job_1 = new UpdateTaskAccountOwner_Schedulable();
        UpdateContactMailingAddress_Schedulable job_2 = new UpdateContactMailingAddress_Schedulable();
        String schedule_1 = '00 50 * * * ?';
        String schedule_2 = '00 55 * * * ?';
        System.schedule('UpdateTaskAccountOwner_Schedulable', schedule_1, job_1);
        System.schedule('UpdateContactMailingAddress_Schedulable', schedule_2, job_2);
    }
}