@JsonAccess(serializable='always' deserializable='always')
global class CancelAppointmentInputs {
    @AuraEnabled
    global List<Id> appointmentIds;
    
    @AuraEnabled
    global String cancellationReason;
    
    @AuraEnabled
    global String contactID;
    
}