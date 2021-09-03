import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Todo__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/Todo__c.Description__c';
import CATEGORY_FIELD from '@salesforce/schema/Todo__c.Category__c';
import COMPLETION_FIELD from '@salesforce/schema/Todo__c.Completion_Date__c';
import CREATION_FIELD from '@salesforce/schema/Todo__c.Creation_Date__c';
import PRIORITY_FIELD from '@salesforce/schema/Todo__c.Priority__c';
import IS_DONE_FIELD from '@salesforce/schema/Todo__c.Is_Done__c';
import IMAGE_FIELD from '@salesforce/schema/Todo__c.Image__c';
import IMAGE_URL_FIELD from '@salesforce/schema/Todo__c.Image_URL__c';
import PICTURES_ARCHIVE_URL from '@salesforce/resourceUrl/todo_pic'; // ZIPped static resource
//import resourcesUrl from '@salesforce/resourceUrl/pic_done'; // named static resource


const FIELDS = [NAME_FIELD, DESCRIPTION_FIELD, CATEGORY_FIELD, COMPLETION_FIELD, CREATION_FIELD, PRIORITY_FIELD, IS_DONE_FIELD, IMAGE_FIELD, IMAGE_URL_FIELD];

export default class TodoDetailItem extends LightningElement {
    @api recordid;

    @wire (getRecord, { recordId: '$selectedRecordId', fields: FIELDS })
    todoz;

    //pictureUrl2 = resourcesUrl;       // named static resource
    get imageUrl() {
        return PICTURES_ARCHIVE_URL+getFieldValue(this.todoz.data, IMAGE_URL_FIELD);
    }

    get selectedRecordId () {
        return this.recordid;
    }

    get name() {
        return getFieldValue(this.todoz.data, NAME_FIELD);
    }

    get description() {
        return getFieldValue(this.todoz.data, DESCRIPTION_FIELD);
    }

    get completion() {
        return getFieldValue(this.todoz.data, COMPLETION_FIELD);
    }

    get creation() {
        return getFieldValue(this.todoz.data, CREATION_FIELD);
    }

    get category() {
        return getFieldValue(this.todoz.data, CATEGORY_FIELD);
    }

    get priority() {
        return getFieldValue(this.todoz.data, PRIORITY_FIELD);
    }

    get isDone() {
        return getFieldValue(this.todoz.data, IS_DONE_FIELD)?'Todo is already done':'Not finished yet';
    }

}