public class AppointmentController {
    
   /* @AuraEnabled(cacheable=true)
    public static List<ServiceAppointment> getAppointments(Id contactId) {
        return [
            SELECT Id, AppointmentNumber, Status, SchedStartTime, SchedEndTime
                FROM ServiceAppointment
                WHERE ContactId =:contactId
        ];
    }*/
    


    @AuraEnabled(cacheable=true)
    public static List<ServiceAppointment> getAppointments(Id contactId) {

        if (contactId == null) {
            return new List<ServiceAppointment>();
        }
		System.debug('The Contact ID'+contactId);
        return [
            SELECT Id, AppointmentNumber, Status, SchedStartTime, SchedEndTime
            FROM ServiceAppointment
            WHERE ParentRecordId = :contactId
            AND Status = 'Scheduled'
            ORDER BY SchedStartTime ASC
        ];
    }
}