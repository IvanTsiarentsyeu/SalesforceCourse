import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const DELAY = 300;

export default class Container extends LightningElement {
    @api selectedTodoId;
    @api searchKey = '';
    @api priority = false;

    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.detail;
        this.delayTimeout = setTimeout(
            () => {
                this.searchKey = searchKey;
            },
        DELAY);
     }

    handlePriorityChange(event) {
        this.priority = event.detail;
     }

    handleTodoSelected(evt) {
        this.selectedTodoId = evt.detail;
    }

    handleRefresh () {
        this.template.querySelector('c-todo-list').handleRefresh();
    }

    handleGoUp() {
        this.template.querySelector('c-todo-list').handleGoUp();
    }

    handleGoDown() {
        this.template.querySelector('c-todo-list').handleGoDown();
    }

}