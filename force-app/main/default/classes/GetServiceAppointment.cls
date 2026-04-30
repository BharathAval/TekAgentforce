@JsonAccess(serializable='always' deserializable='always')
global without sharing class GetServiceAppointment {

    @InvocableMethod(
        label='Get Scheduled Service Appointments' 
        description='Retrieves Scheduled Service Appointments for an Account'
    )
    global static List<OutputWrapper> getAppointments(List<InputRequest> requests) {
        List<OutputWrapper> responses = new List<OutputWrapper>();

        for (InputRequest request : requests) {
            OutputWrapper response = new OutputWrapper();
            response.output = new ServiceAppointmentOutput();

            try {
                Id accountId;
                String accountName;

                if (request.objAccount != null && request.objAccount.Id != null) {
                    accountId = request.objAccount.Id;
                    accountName = getAccountNameById(accountId);
                } else if (String.isNotBlank(request.accountName)) {
                    Account acc = getAccountByName(request.accountName);
                    accountId = acc.Id;
                    accountName = acc.Name;
                } else {
                    response.output.errorMessage =
                        'Please provide either Account ID or Account Name.';
                    responses.add(response);
                    continue;
                }

                List<ServiceAppointmentWrapper> appointments =
                    buildServiceAppointmentWrappers(getScheduledAppointments(accountId));

                if (appointments.isEmpty()) {
                    response.output.errorMessage =
                        'No scheduled Service Appointments found';
                } else {
                    response.output.accountId = accountId;
                    response.output.accountName = accountName;
                    response.output.totalAppointments = appointments.size();
                    response.output.appointments = appointments;
                }
            } catch (Exception e) {
                response.output.errorMessage = 'Error: ' + e.getMessage();
            }

            responses.add(response);
        }
        system.debug('responses=='+responses);
        return responses;
    }

    global static List<ServiceAppointmentWrapper> buildServiceAppointmentWrappers(
        List<ServiceAppointment> appointments
    ) {
        List<ServiceAppointmentWrapper> result = new List<ServiceAppointmentWrapper>();
        for (ServiceAppointment appt : appointments) {
            ServiceAppointmentWrapper wrap = new ServiceAppointmentWrapper();
            wrap.Id = appt.Id;
            wrap.AppointmentNumber = appt.AppointmentNumber;
            wrap.Status = appt.Status;
            wrap.SchedStartTime = String.valueOf(appt.SchedStartTime);
            wrap.SchedEndTime = String.valueOf(appt.SchedEndTime);
            result.add(wrap);
        }
        return result;
    }

    global static Account getAccountByName(String accountName) {
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :('%' + accountName + '%')
            LIMIT 2
        ];
        if (accounts.isEmpty()) {
            throw new AuraHandledException('No Account found with name: ' + accountName);
        }
        if (accounts.size() > 1) {
            throw new AuraHandledException(
                'Multiple Accounts found for "' + accountName + '". Please specify Account ID.'
            );
        }
        return accounts[0];
    }

    global static String getAccountNameById(Id accountId) {
        return [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1].Name;
    }

    global static List<ServiceAppointment> getScheduledAppointments(Id accountId) {
        return [
            SELECT Id, AppointmentNumber, Status, SchedStartTime, SchedEndTime
            FROM ServiceAppointment
            WHERE AccountId = :accountId
            AND Status IN ('Scheduled', 'Confirmed', 'In Progress')
            ORDER BY SchedStartTime ASC
        ];
    }

    // Input DTO must be AuraEnabled
    global class InputRequest {
        @InvocableVariable(label='Account ID' required=false)
        @AuraEnabled global Account objAccount;

        @InvocableVariable(label='Account Name' required=false)
        @AuraEnabled global String accountName;
    }

    // Output wrapper
    global class OutputWrapper {
        @AuraEnabled
        @InvocableVariable
        global ServiceAppointmentOutput output;
    }

    // Main output DTO
    global class ServiceAppointmentOutput {
        @AuraEnabled global Id accountId;
        @AuraEnabled global String accountName;
        @AuraEnabled global Integer totalAppointments;
        @AuraEnabled global List<ServiceAppointmentWrapper> appointments;
        @AuraEnabled global String errorMessage;
    }

    // Appointment DTO
    global class ServiceAppointmentWrapper {
        @AuraEnabled global Id Id;
        @AuraEnabled global String AppointmentNumber;
        @AuraEnabled global String Status;
        @AuraEnabled global String SchedStartTime;
        @AuraEnabled global String SchedEndTime;
    }
}