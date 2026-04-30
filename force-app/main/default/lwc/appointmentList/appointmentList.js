import { LightningElement, api, track } from 'lwc';

export default class AppointmentList extends LightningElement {

    @api appointments = [];
    @api multiSelect = false;

    @track selectedIds = [];

    get computedAppointments() {
        return this.appointments.map(appt => {
            return {
                ...appt,
                cardClass: this.selectedIds.includes(appt.id)
                    ? 'card selected'
                    : 'card'
            };
        });
    }

    handleSelect(event) {
        const id = event.currentTarget.dataset.id;

        if (this.multiSelect) {
            if (this.selectedIds.includes(id)) {
                this.selectedIds = this.selectedIds.filter(item => item !== id);
            } else {
                this.selectedIds = [...this.selectedIds, id];
            }
        } else {
            this.selectedIds = [id];
        }

        this.dispatchEvent(new CustomEvent('selectionchange', {
            detail: {
                selectedIds: this.selectedIds
            }
        }));
    }
}