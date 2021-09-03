public class TodoController {

    @AuraEnabled (cacheable=true)
    public static List<Todo__c> findTodos(String searchKey, Boolean priority) {
        List<Todo__c> selectedTodos = [
                SELECT Id, Name, Description__c,
                        Category__c, Creation_Date__c, Completion_Date__c,
                        Priority__c, Is_Done__c, Image__c
                FROM Todo__c
                WITH SECURITY_ENFORCED
        ];
        List<Todo__c> filteredTodos = new List<Todo__c>();

        if (searchKey.length() > 0) {
            for (Todo__c t : selectedTodos) {
                if (t.Name.toUpperCase().contains(searchKey.toUpperCase())) {
                    filteredTodos.add(t);
                }
            }
        } else filteredTodos = selectedTodos;

        List<Todo__c> evenMoreFilteredTodos = new List<Todo__c>();

        if (priority) {
            for (Todo__c t : filteredTodos) {
                if (t.Priority__c == 'High') {
                    evenMoreFilteredTodos.add(t);
                }
            }
        } else evenMoreFilteredTodos = filteredTodos;

        return evenMoreFilteredTodos;
    }
}