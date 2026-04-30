global class DoctorSearch {

    @InvocableMethod(label='Search Doctors')
    public static List<List<DoctorInfoOutput>> searchDoctors(List<DoctorInput> requests) {
        List<List<DoctorInfoOutput>> response = new List<List<DoctorInfoOutput>>();

        //for (DoctorSearchFilter req : requests) {

            List<DoctorInfoOutput> doctorsList = new List<DoctorInfoOutput>();

            List<HealthcareProvider> doctors = [
                SELECT Id, Name, Department__c, Location__c, Experience__c
                FROM HealthcareProvider
                WHERE Department__c = :requests[0].filters.department
                AND Location__c = :requests[0].filters.location
            ];
        
       /* List<HealthcareProvider> doctors;

                String baseQuery = 'SELECT Id, Name, Department__c, Location__c, Experience__c FROM HealthcareProvider';
                List<String> conditions = new List<String>();
                
                if (requests[0].filters.department != null) {
                    conditions.add('Department__c = :requests[0].filters.department');
                }
                
                if (requests[0].filters.location != null) {
                    conditions.add('Location__c = :requests[0].filters.location');
                }
                
                if (!conditions.isEmpty()) {
                    baseQuery += ' WHERE ' + String.join(conditions, ' AND ');
                }
                
                doctors = Database.query(baseQuery);*/

            for (HealthcareProvider d : doctors) {
                DoctorInfoOutput info = new DoctorInfoOutput();
                info.doctorId = d.Id;
                info.name = d.Name;
                info.department = d.Department__c;
                info.location = d.Location__c;
                info.experience = Integer.valueOf(d.Experience__c);

                doctorsList.add(info);
            }

            response.add(doctorsList);
        //}

        return response;
    }
    
    @JsonAccess(serializable='always' deserializable='always')
    global class DoctorInput {
        @InvocableVariable
        global DoctorRequestFilter filters;
        //@InvocableVariable
        //global String userID;
    }
    
    @JsonAccess(serializable='always' deserializable='always')
    global class DoctorInfoOutput {
    @InvocableVariable
    global Id doctorId;

    @InvocableVariable
    global String name;

    @InvocableVariable
    global String department;

    @InvocableVariable
    global String location;

    @InvocableVariable
    global Integer experience;
}


}