Practically-focused task

Custom fields:

Account:  Boolean -  Updated By Task (default = false)        Boolean – Updated By Contact (default = false)
Contact:  Boolean – Processed By Future (default = false)     Boolean – Processed By Queue (default = false)       Boolean – Is Synced (default = true)
Task:     Boolean – Is Synced (default = true)                String – Account Owner
Create new git branch with name async_apex_task

For AccountTriggerHandler move task creation logic to future method; set Task.IsSynced = false
*Done: AccountHelper.createNegotiationTasks()

In AccountTriggerHandler create future method:
For accounts in which BillingAddress changed select all related Contacts 
Set to all Contacts Is Synced = false; Processed By Future = true;

*Done: AccountHelper.updateContactsFuture()
*Also canCallFuture() check was added to AccountTriggerHandler class in order to avoid conflicts between batch jobs and 2 future methods

In AccountTriggerHandler call Queueble Job, which perform similar logic:
For accounts in which BillingAddress changed select all related Contacts
Set to all Contacts Is Synced = false; Processed By Queue = true;

*Done: UpdateContactsQueueable (failed to access to the Contacts through the Trigger variables, used SELECT instead. Logs and failed code are in comments) 

Crate Batch Job which select all tasks with  Is Synced = false
Batch should copy from Account.Owner.Name to Task.AccountOwner__c
Set Task.IsSynced__c = true;
Update Account field Updated By Task = true;
Use Query Locator

*Done: UpdateTaskAccounOwner_BatchQL

Create Batch Job, which select all contacts with Is Synced = false
Batch should copy from Account.BillingAddress to Contact.MailingAddress
Set Contact.IsSynced__c = true;
Update Account field Updated By Contact = true;
Use Iterable

*Done: UpdateContactMailingAdress_BatchIterable

Create Scheduled Job which runs every 30 minutes and call 2 created batches

*Done: UpdateContactMailingAddress_Schedulable, UpdateTaskAccountOwner_Schedulable, ScheduleJobsHardcode

Without trigger task.
Task goal of this is creating of 5 classes to practice using async features of the APEX language. Based on created data model add following logic:

Create class with future method. Inside the method do the following:
Select 150 Accounts from database.
For accounts in which BillingAddress is not empty select all related Contacts 
Set to all Contacts Is Synced = false; Processed By Future = true;
Run created class using DevConsole.
*Done: Pt2_150Accounts_Future

Create Queueble Job to perform similar logic:
For accounts in which BillingAddress is not empty select all related Contacts
Set to all Contacts Is Synced = false; Processed By Queue = true;
Run created class using DevConsole.
*Done: Pt2_updateContacts_Queueable

Create Batch Job which select all Сontacts with Is Synced = false
Batch should copy from Account.BillingAddress to Contact.MailingAddress
Set Contact.IsSynced__c = true;
Update Account field Updated By Contact = true;
Use Query Locator
*Done: Pt2_CopyAddress_QueryLocator

Create similar Batch and use Iterable
*Done: Pt2_CopyAddress_Iterable

Create Scheduled Job which runs every 30 minutes and call 2 created batches
*Done: Pt2_MakeSchedule, Pt2_CopyAddressIterable_Schedulable, Pt2_CopyAddressQLocator_Schedulable
