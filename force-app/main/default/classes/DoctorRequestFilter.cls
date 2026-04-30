@JsonAccess(serializable='always' deserializable='always')
global class DoctorRequestFilter {

    @AuraEnabled
    global String department;

    @AuraEnabled
     global String location;
}