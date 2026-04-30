/*global with sharing class CancelAppointmentsAction {

@JsonAccess(serializable='always' deserializable='always')
global class CancellationRequest {
@InvocableVariable
global CancelAppointmentInputs cancellationInputs;
}

@JsonAccess(serializable='always' deserializable='always')
global class CancellationResponse {
@InvocableVariable
global List<String> appointmentNames;

@InvocableVariable
global String message;
}

@InvocableMethod(label='Cancel Appointments and Return Names')
public static List<CancellationResponse> cancel(List<CancellationRequest> requests) {

List<CancellationResponse> responses = new List<CancellationResponse>();

for (CancellationRequest req : requests) {

CancellationResponse res = new CancellationResponse();

if (req.cancellationInputs.appointmentIds == null || req.cancellationInputs.appointmentIds.isEmpty()) {
res.message = 'No appointments selected.';
responses.add(res);
continue;
}

// 🔷 Query appointments
List<ServiceAppointment> appts = [
SELECT Id, AppointmentNumber, Status, SchedStartTime, SchedEndTime
FROM ServiceAppointment
WHERE Id IN :req.cancellationInputs.appointmentIds
];

List<String> appointmentNumber = new List<String>();

for (ServiceAppointment appt : appts) {
appt.Status = 'Cancelled';
//appt.Cancellation_Reason__c = req.cancellationReason;

appointmentNumber.add(appt.AppointmentNumber);
}

if (!appts.isEmpty()) {
update appts;
}

// 🔷 Prepare response
res.appointmentNames = appointmentNumber;
res.message = 'Appointments cancelled successfully.';

responses.add(res);
}

return responses;
}
}*/

global with sharing class CancelAppointmentsAction {
    @JsonAccess(serializable='always' deserializable='always')
    global class CancellationRequest {
        
        @InvocableVariable
        global List<Id> appointmentIds;
        
        @InvocableVariable
        global String cancellationReason;
        
        @InvocableVariable
        global Id contactID;
    }
    @JsonAccess(serializable='always' deserializable='always')
    global class CancellationResponse {
        
        @InvocableVariable
        global List<String> appointmentNumbers;
        
        @InvocableVariable
        global String message;
    }
    
    @InvocableMethod(label='Cancel Appointments')
    public static List<CancellationResponse> cancel(List<CancellationRequest> requests) {
        
        List<CancellationResponse> responses = new List<CancellationResponse>();
        
        for (CancellationRequest req : requests) {
            
            CancellationResponse res = new CancellationResponse();
            

            if (req == null || req.contactID == null) {
                res.message = 'Invalid request or missing contact.';
                responses.add(res);
                continue;
            }
            
            if (req.appointmentIds == null || req.appointmentIds.isEmpty()) {
                res.message = 'No appointments selected.';
                responses.add(res);
                continue;
            }
            
            if (String.isBlank(req.cancellationReason)) {
                res.message = 'Cancellation reason is required.';
                responses.add(res);
                continue;
            }
            
            List<ServiceAppointment> appts = [
                SELECT Id, AppointmentNumber, Status, ParentRecordId
                FROM ServiceAppointment
                WHERE Id IN :req.appointmentIds
                AND Status != 'Cancelled'
            ];
            
            if (appts.isEmpty()) {
                res.message = 'No valid appointments found.';
                responses.add(res);
                continue;
            }
            
            List<String> numbers = new List<String>();
            
            for (ServiceAppointment appt : appts) {
                appt.Status = 'Cancelled';
                numbers.add(appt.AppointmentNumber);
            }
            
            update appts;
            
            res.appointmentNumbers = numbers;
            res.message = 'Cancelled ' + numbers.size() + ' appointment(s) successfully.';
            
            responses.add(res);
        }
        
        return responses;
    }
}