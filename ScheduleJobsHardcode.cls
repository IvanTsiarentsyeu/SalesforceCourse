/**
 * Created by 77111 on 09.08.2021.
 */

public with sharing class ScheduleJobsHardcode {
    static public void run() {
        UpdateTaskAccountOwner_Schedulable job_1 = new UpdateTaskAccountOwner_Schedulable();
        String schedule_1 = '20 46 * * * ?';
        String schedule_2 = '20 16 * * * ?';
        System.schedule('Batch Job 3', schedule_1, job_1);
        System.schedule('Batch Job 4', schedule_2, job_1);
    }
}