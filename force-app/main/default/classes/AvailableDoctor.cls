@JsonAccess(serializable='always' deserializable='always')
global class AvailableDoctor {
    
    @AuraEnabled
    global List<Doctor> doctors;

    global AvailableDoctor(List<Doctor> doctorList) {
        this.doctors = doctorList;
    }


}