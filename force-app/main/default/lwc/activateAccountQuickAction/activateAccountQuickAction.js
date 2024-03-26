import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import updateAccountDetails from '@salesforce/apex/AccountDefaultActiveContactCreation.updateAccountDetails'; 

export default class ActivateAccountQuickAction extends LightningElement {
    activateSummary;
    checkBoxFieldValue;
    @api recordId;

    getActivationValue(event){
        debugger;
       this.activateSummary = event.target.value;
    }
    handleCheckBoxChange(event){
        debugger;
   this.checkBoxFieldValue = event.target.checked;
}

    closeAction(){
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    saveUpdateAccount(){
        debugger;
        if(this.activateSummary == undefined){
           this.showToastError();
           return;
        }
        updateAccountDetails({recordId:this.recordId,isActivate:this.checkBoxFieldValue,activatonSummary:this.activateSummary})
        .then(result =>{
            if(result == 'SUCCESS'){
               this.showToast();
            }
        })
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Account Updated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        this.closeAction();
    }

    showToastError() {
        const event = new ShowToastEvent({
            title: 'ERROR',
            message: 'Please Provide Activation Summary !',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        this.closeAction();
    }

}