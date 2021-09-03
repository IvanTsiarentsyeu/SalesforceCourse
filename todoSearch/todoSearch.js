import { LightningElement, api } from 'lwc';

export default class TodoSearch extends LightningElement {

    priority=false;

    handleKeyChange(event){
        const customE = new CustomEvent('keychange', {detail : event.target.value});
        this.dispatchEvent(customE);
    }

    handlePriorityChange(event){
        const customE = new CustomEvent('prioritychange', {detail : event.target.checked});
        this.dispatchEvent(customE);
    }

}

