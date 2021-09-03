import { LightningElement, api, wire } from 'lwc';
import findTodos from '@salesforce/apex/TodoController.findTodos';
import { refreshApex } from '@salesforce/apex';

const DELAY = 300;


export default class TodoList extends LightningElement {
    @api searchKey = '';
    @api priority = false;
    @api todoid;

    todos;
    error;
    wiredTodosResult;

    @wire (findTodos, { searchKey: '$searchKey', priority: '$priority' })
    wiredTodos(result) {
        this.wiredTodosResult = result;
        if (result.data) {
            this.todos = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.todos = undefined;
            this.error = result.error;
        }
    }

    handleListItemClick(evt) {
        const event = new CustomEvent('todoselected', {
            detail: evt.detail
        });
        this.dispatchEvent(event);
    }

    @api handleRefresh(){
        return refreshApex(this.wiredTodosResult);
    }

    @api handleGoDown(){
        let i;
        if (this.todos) {
            if (this.todoid){
                i = this.todos.findIndex(todo => todo.Id === this.todoid);
                const max = this.todos.length-1;
                if (i < max) {
                    i = i + 1;
                } else {
                     i = 0;
                }
                const event = new CustomEvent('todoselected', {
                    detail: this.todos[i].Id
                });
                this.dispatchEvent(event);
            }
        }
    }

    @api handleGoUp(){
        let i;
        if (this.todos) {
            if (this.todoid){
                i = this.todos.findIndex(todo => todo.Id === this.todoid);
                const max = this.todos.length-1;
                if (i > 0) {
                    i = i - 1;
                } else {
                     i = max;
                }
                const event = new CustomEvent('todoselected', {
                    detail: this.todos[i].Id
                });
                this.dispatchEvent(event);
            }
        }

    }

}