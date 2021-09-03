import { LightningElement, api } from 'lwc';


export default class TodoListItem extends LightningElement {
    @api listitem;

    listitemclick() {
        const event = new CustomEvent('listitemclick', {
            detail : this.listitem.Id
        });
        this.dispatchEvent(event);
    }

    get category() {
        return this.listitem.Category__c;
    }
}