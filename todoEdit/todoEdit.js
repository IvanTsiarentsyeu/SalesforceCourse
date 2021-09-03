import { LightningElement, api } from 'lwc';
import TODO_OBJECT from '@salesforce/schema/Todo__c'; //
import ID_FIELD from '@salesforce/schema/Todo__c.Id'; //
import NAME_FIELD from '@salesforce/schema/Todo__c.Name'; //
import DESCRIPTION_FIELD from '@salesforce/schema/Todo__c.Description__c'; //
import COMPLETION_FIELD from '@salesforce/schema/Todo__c.Completion_Date__c';
import PRIORITY_FIELD from '@salesforce/schema/Todo__c.Priority__c';
import IS_DONE_FIELD from '@salesforce/schema/Todo__c.Is_Done__c';

export default class TodoEdit extends LightningElement {

    @api todoid;
    name = NAME_FIELD;
    description = DESCRIPTION_FIELD;
    completion = COMPLETION_FIELD;
    priority = PRIORITY_FIELD;
    isDone = IS_DONE_FIELD;


    objectApiName = TODO_OBJECT;
    openModal = false;


    showModal() {
        this.openModal = true;
    }

    closeModal() {
         this.openModal = false;
    }

    handleSuccess() {
        this.openModal = false;
        const event = new CustomEvent('refresh',{ detail: ''});
        this.dispatchEvent(event);
    }

}