import { LightningElement, api } from 'lwc';

export default class getAppointmentsLwc extends LightningElement {

    // 🔥 Agentforce sends data here
    @api value;

    // ✅ Debug (you can remove later)
    connectedCallback() {
        console.log('✅ LWC LOADED');
        console.log('GetAppointmentsLWC connected');
    }

    renderedCallback() {
        console.log('🔥 RAW VALUE FROM AGENT:', JSON.stringify(this.value));
    }

    // ✅ Normalize data (handles wrapper + direct)
    get output() {
        if (!this.value) {
            return {};
        }

        // Case 1: Apex wrapper → { output: {...} }
        if (this.value.output) {
            return this.value.output;
        }

        // Case 2: Direct object (future-safe)
        return this.value;
    }

    // ✅ Error handling
    get error() {
        return this.output?.errorMessage || null;
    }

    get showError() {
        return !!this.error;
    }

    // ✅ Appointments checks
    get hasAppointments() {
        return this.output?.appointments && this.output.appointments.length > 0;
    }

    get showNoRecords() {
        return (
            this.output &&
            (!this.output.appointments || this.output.appointments.length === 0) &&
            !this.error
        );
    }

    // ✅ Safe getters for UI (prevents undefined issues)
    get accountName() {
        return this.output?.accountName || '';
    }

    get totalAppointments() {
        return this.output?.totalAppointments || 0;
    }

    get appointments() {
        return this.output?.appointments || [];
    }
}