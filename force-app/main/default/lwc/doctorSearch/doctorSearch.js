import { LightningElement, api, track } from 'lwc';
export default class DoctorSearch extends LightningElement {

       // REQUIRED for Lightning Type binding

     _value;
     department;
     location;


    /*@api value = {
        department: '',
        location: ''
    };*/

    @api test;

    @api
    get value() {
        return this._value;
    }
    /**
     * @param  {} value
     */
    set value(value) {
        this._value = value;
    }

    connectedCallback() {
        console.log('Inside filte CC**********');
        if (this.value) {
            this.department = this.value?.department || '';
            this.location = this.value?.location || '';
        }
    }

    // Picklist options (static for now)
    departmentOptions = [
        { label: 'Oncology', value: 'Oncology' },
        { label: 'Gynaecology', value: 'Gynaecology' },
        { label: 'Pediatrics', value: 'Pediatrics' }
    ];

    locationOptions = [
        { label: 'Hyderabad', value: 'Hyderabad' },
        { label: 'Pune', value: 'Pune' }
    ];

   /* // Handle Department Change
    handleDepartmentChange(event) {
        this.value = {
            ...this.value,
            department: event.detail.value
        };
    }

    // Handle Location Change
    handleLocationChange(event) {
        this.value = {
            ...this.value,
            location: event.detail.value
        };
    }*/

        handleInputChange(event) {
        event.stopPropagation();
        const { name, value } = event.target;
        this[name] = value;
        
        this.dispatchEvent(new CustomEvent('valuechange', {
          detail: {
            value: {
              department: this.department,
              location: this.location
            }
          }
        }));
    }

}