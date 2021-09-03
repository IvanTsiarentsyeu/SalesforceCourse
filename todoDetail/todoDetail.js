import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class TodoDetail extends LightningElement {
   @api todoid;
   error;

    deleteTodo(event){
        const recordId = this.todoid;
        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Todo deleted',
                        variant: 'success'
                    })
                );
                this.todoid = undefined;
                const event = new CustomEvent('refresh',{ detail: ''});
                this.dispatchEvent(event);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: '?!',
                        variant: 'error'
                    })
                );
            });

    }

    handleRefresh(){
        const event = new CustomEvent('refresh',{ detail: ''});
        this.dispatchEvent(event);
    }

    goUp() {
        const event = new CustomEvent('goup',{ detail: ''});
        this.dispatchEvent(event);
    }

    goDown() {
        const event = new CustomEvent('godown',{ detail: ''});
        this.dispatchEvent(event);
    }
}