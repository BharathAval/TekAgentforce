global class ServiceAppointmentOutput {

    @AuraEnabled @InvocableVariable
    global Id accountId;

    @AuraEnabled @InvocableVariable
    global String accountName;

    @AuraEnabled @InvocableVariable
    global Integer totalAppointments;

    @AuraEnabled @InvocableVariable
    global List<ServiceAppointmentItem> appointments;

    @AuraEnabled @InvocableVariable
    global String errorMessage;

    global class ServiceAppointmentItem {
        @AuraEnabled @InvocableVariable
        global String appointmentNumber;

        @AuraEnabled @InvocableVariable
        global String subject;

        @AuraEnabled @InvocableVariable
        global String status;

        @AuraEnabled @InvocableVariable
        global String workType;

        @AuraEnabled @InvocableVariable
        global Datetime scheduledStart;

        @AuraEnabled @InvocableVariable
        global Datetime scheduledEnd;

        @AuraEnabled @InvocableVariable
        global Datetime createdDate;

        @AuraEnabled @InvocableVariable
        global Datetime lastModifiedDate;
    }
}