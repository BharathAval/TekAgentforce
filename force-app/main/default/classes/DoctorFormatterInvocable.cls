public with sharing class DoctorFormatterInvocable {

    // Input wrapper (Flow → Apex)
    public class Input {
        @InvocableVariable(required=true)
        public List<HealthcareProvider> doctors;
    }

    // Output wrapper (Apex → Flow)
    public class Output {
        @InvocableVariable
        public String doctorsJSON;
    }

    @InvocableMethod(label='Format Doctors to JSON')
    public static List<Output> formatDoctors(List<Input> inputs) {

        List<Output> outputs = new List<Output>();

        for (Input inp : inputs) {

            List<Map<String, Object>> result = new List<Map<String, Object>>();

            if (inp.doctors != null) {
                for (HealthcareProvider doc : inp.doctors) {
                    Map<String, Object> d = new Map<String, Object>();
                    d.put('id', doc.Id);
                    d.put('name', doc.Name);
                    d.put('experience', doc.Experience__c);
                    d.put('location', doc.Location__c);
                    d.put('department', doc.Department__c);
                    result.add(d);
                }
            }

            Output out = new Output();
            out.doctorsJSON = JSON.serialize(result);
            outputs.add(out);
        }

        return outputs;
    }
}