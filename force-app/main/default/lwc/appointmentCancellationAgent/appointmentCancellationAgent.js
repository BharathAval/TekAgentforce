import { LightningElement, api, track } from 'lwc';
import getAppointments from '@salesforce/apex/AppointmentController.getAppointments';

export default class AppointmentCancellationAgent extends LightningElement {

   /* // Inputs from Agentforce
    //@api patientID;
    @api value;

    @track selectedIds = [];
    @track reason = '';
    @track appointments = [];

    get contactId() {
        return this.value ? this.value.contactID : null;
    }

    connectedCallback() {
        console.log('=== Agent Input Received ===');
        console.log('Full value:', JSON.stringify(this.value));
        console.log('Derived Contact ID:', this.contactId);

        if (!this.contactId) {
            console.warn('⚠️ No contactId received from Agentforce');
        }
        if (this.contactId) {

            this.loadAppointments();
        }
    }

    // Fetch appointments from Apex
    loadAppointments() {
        console.log('=== Fetching Appointments ===');
        console.log('Contact ID used:', this.contactId);
        getAppointments({ contactId: this.contactId })
            .then(result => {
                console.log('=== Appointments Fetched Successfully ===');
                console.log('Raw Result:', result);
                console.log('Stringified:', JSON.stringify(result));
                console.log('Record Count:', result?.length);
                this.appointments = result;
            })
            .catch(error => {
                console.error('Error fetching appointments', error);
            });
    }

    get hasAppointments() {
        return this.appointments && this.appointments.length > 0;
    }

    // Handle child selection
    handleSelection(event) {
        this.selectedIds = event.detail.selectedIds;
    }

    // Handle reason input
    handleReasonChange(event) {
        this.reason = event.target.value;
    }

    // Disable button if incomplete
    get isSubmitDisabled() {
        return this.selectedIds.length === 0 || !this.reason;
    }

    // Send back to Agentforce
    handleSubmit() {

        const payload = {
            appointmentIds: this.selectedIds,
            cancellationReason: this.reason,
            contactID: this.contactId
        };

        console.log('=== Submitting Cancellation ===');
        console.log('Payload:', JSON.stringify(payload));

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                appointmentIds: this.selectedIds,
                cancellationReason: this.reason,
                contactID: this.contactId
            }
        }));
    }*/

    @api value;

    @track appointments = [];
    @track selectedIds = [];
    @track reason = '';

    get contactId() {
        return this.value?.contactID || null;
    }

    connectedCallback() {
        console.log('Input:', JSON.stringify(this.value));

        if (this.contactId) {
            this.loadAppointments();
        }
    }

    loadAppointments() {
        getAppointments({ contactId: this.contactId })
            .then(result => {
                this.appointments = result;
            })
            .catch(error => {
                console.error(error);
            });
    }

    get hasAppointments() {
        return this.appointments?.length > 0;
    }

    handleSelection(event) {
        this.selectedIds = event.detail.selectedIds;
    }

    handleReasonChange(event) {
        this.reason = event.target.value;
    }

    get isSubmitDisabled() {
        return this.selectedIds.length === 0 || !this.reason;
    }

    handleSubmit() {
        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                appointmentIds: this.selectedIds,
                cancellationReason: this.reason,
                contactID: this.contactId
            }
        }));
    }
}