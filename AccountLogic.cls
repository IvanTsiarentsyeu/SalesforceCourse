public class AccountLogic {
    
    static final List <String> APPROPRIATE_USER_PROFILE_LIST = appropriateUserProfilesList();
        
    @InvocableMethod (label = 'Task management on Account')
    public static void main (List<Id> accountIds) {
        if (accountIds<>null){

        List<Account> accountList = new List<Account> ([
                               SELECT Id, Name, LastModifiedDate, CreatedDate
                               FROM Account 
                               WHERE Id IN :accountIds]);
        Map<Id, List<Task>> taskMap = makeMapOfTaskListsFrom (new List<Task> ([
                               SELECT Id, OwnerId, WhatId 
                               FROM Task 
                               WHERE WhatId IN :accountIds]));

		List<Task> tasksToUpsert = new List<Task>();
        for (Account currentAccount: accountList) {
            if (isCreatedNow(currentAccount)) {
                tasksToUpsert.add(createNegotiationTask(currentAccount));
            } else {
                List<Task> listOfTasks = taskMap.get(CurrentAccount.Id);
                if (hasMoreThanEnoughTasks(listOfTasks, 3)) {
                    if (tasksAreAssignedToDifferentUsers(listOfTasks))
                        tasksToUpsert.addAll(assignTasksToRandomUser(listOfTasks));
                }
            }
        }
        if (tasksToUpsert.size()>0) {
        	try {
            	upsert tasksToUpsert;
        	} catch(DMLException e) {
            	System.debug(e);
        	} 
        }
        }
    }

    
    static List<Task> assignTasksToRandomUser (List<Task> listOfTasks) { 
        id randomUserId = randomUserId();
        for (Integer i = 0; i < listOfTasks.size(); i++) {
            listOfTasks[i].OwnerId = randomUserId;
        }
        return listOfTasks;
    }

    
    static Task createNegotiationTask (Account acct) {  
        Task newTask = new Task (Subject = 'Negotiations with' + acct.Name,
                                 WhatId = acct.Id,
                                 OwnerId = randomUserId(),
                                 Status = 'Not Started');
        return newTask;
    }

    
    static Map<Id, List<Task>> makeMapOfTaskListsFrom(List<Task> taskList) {
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();     
        for (Task t : taskList){
            if (taskMap.get(t.WhatId) == null) {
                taskMap.put(t.WhatId, new List<Task>());  
            }    
            taskMap.get(t.WhatId).add(t);
        }
        return taskMap;
    }
    
    
    static boolean hasMoreThanEnoughTasks(List<Task> listOfTasks, Integer enough) {
        return listOfTasks.size() > enough;
    }
    
    
    static boolean tasksAreAssignedToDifferentUsers(List<Task> listOfTasks) {
        Id firstOwnerId = listOfTasks[0].OwnerId;
        for (Task t:listOfTasks) {
            if (t.OwnerId<>firstOwnerId) {              
                return true;  
            }
        }
        return false;
    }
    
    
    static Id randomUserId() {
        List<User> activeUserArray = [SELECT Id, ProfileId FROM User
                                      WHERE IsActive=true AND Profile.Name IN :APPROPRIATE_USER_PROFILE_LIST];
        Integer randomIndex = (Integer) (Math.random() * activeUserArray.size());
        return activeUserArray[randomIndex].Id;
    }
    
    
    static List<String> appropriateUserProfilesList() {
        List<String> profileList = new List<String>(); 
        profileList.add('System Administrator');
        profileList.add('Analytics Cloud Security User');
        profileList.add('Analytics Cloud Integration User');
        return profileList;
    }
    
    
    static boolean isCreatedNow (Account acct) {
        return acct.LastModifiedDate == acct.CreatedDate;
    }
}