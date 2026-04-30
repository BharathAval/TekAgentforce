global class DoctorSearchAgent {
    
    @InvocableMethod(label='Fetch Available Doctors' description='Finds available Doctors')
    global static List<DoctorResponse> fetchDoctors(List<DoctorRequest> requests) {
        
        List<DoctorResponse> finalResponse = new List<DoctorResponse>();
        
        //for (DoctorSearchFilter req : requests) {
        
        List<Doctor> doctorList = new List<Doctor>();
        
        //Query HealthcareProvider object
        List<HealthcareProvider> doctors = [
            SELECT Id, Name, Department__c, Location__c, Experience__c
            FROM HealthcareProvider
            WHERE Department__c = :requests[0].filters.department
            AND Location__c = :requests[0].filters.location
            ORDER BY Experience__c DESC
            LIMIT 50
        ];
        
        // Map to output DTO
        for (HealthcareProvider d : doctors) {
            
            Doctor info = new Doctor(d.Id, d.Name, d.Department__c, d.Location__c, Integer.valueOf(d.Experience__c) );
            
            doctorList.add(info);
        }
        
		AvailableDoctor availableDoctor = new AvailableDoctor(doctorList);
        //availableDoctor.doctors = doctorList;
        
        DoctorResponse docResponse = new DoctorResponse();
        docResponse.availableDoctors = availableDoctor;
        System.debug('The Response---'+docResponse);
        System.debug('The final Response---'+JSON.serialize(docResponse));
        finalResponse.add(docResponse);
        
        System.debug('The final Response---'+finalResponse);
        System.debug('The final Response---'+JSON.serialize(finalResponse));
        
        
        return finalResponse;
    }
    
    @JsonAccess(serializable='always' deserializable='always')
    global class DoctorRequest {
        @InvocableVariable
        global DoctorRequestFilter filters;
    }
    
    @JsonAccess(serializable='always' deserializable='always')
    global class DoctorResponse {
        
        @InvocableVariable
        global AvailableDoctor availableDoctors;
    }
}