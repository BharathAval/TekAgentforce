import { LightningElement, api } from 'lwc';

export default class DoctorList extends LightningElement {

    // 🔥 Agentforce passes data here
    @api value;
    /*//doctors = [];


    get doctors() {
        try {
            const raw = this.value?.availableDoctors?.doctors || [];

            return raw.map(doc => ({
                ...doc
            }));

        } catch (error) {
            console.error('Error parsing doctors:', error);
            return [];
        }
    }

    

    
    handleSelect(event) {
        const doctorId = event.target.dataset.id;

        // Future: trigger slot fetch
        console.log('Selected Doctor Id:', doctorId);

        // Optional: update value for next step (Agent chaining)
        this.dispatchEvent(
            new CustomEvent('doctorselect', {
                detail: { doctorId }
            })
        );
    }*/
}