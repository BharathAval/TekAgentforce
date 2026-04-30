/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : Doctor
 * Author          : <YourName>
 * Created Date    : Apr 16, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Apr 16, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Apr 16, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */
@JsonAccess(serializable='always' deserializable='always')
global class Doctor {

	@InvocableVariable
        global String doctorId;
        
        @InvocableVariable
        global String name;
        
        @InvocableVariable
        global String department;
        
        @InvocableVariable
        global String location;
        
        @InvocableVariable
        global Integer experience;

    global Doctor(String doctorId, String name, String department,
                  String location, Integer experience) {
        this.doctorId = doctorId;
        this.name = name;
        this.department = department;
        this.location = location;
        this.experience = experience;
     }

}