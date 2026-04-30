trigger ServiceAppointmentEmailTrigger on ServiceAppointment (after insert, after update) {

    try {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        // Collect Account Ids
        Set<Id> accIds = new Set<Id>();
        for (ServiceAppointment sa : Trigger.new) {
            if (sa.AccountId != null) {
                accIds.add(sa.AccountId);
            }
        }

        // Query Accounts (Person Accounts)
        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, PersonEmail, PersonContactId, Name 
             FROM Account 
             WHERE Id IN :accIds]
        );

        // ✅ Preload Templates
        Map<String, EmailTemplate> templates = new Map<String, EmailTemplate>();
        for (EmailTemplate et : [
            SELECT Id, DeveloperName 
            FROM EmailTemplate 
            WHERE DeveloperName IN (
                'ServiceAppointment_Creation_1776765242942',
                'ServiceAppointment_Rescheduled_1776786227405',
                'ServiceAppointment_Cancelled_1776787213847'
            )
        ]) {
            templates.put(et.DeveloperName, et);
        }

        for (ServiceAppointment sa : Trigger.new) {
            ServiceAppointment oldSa = Trigger.isUpdate ? Trigger.oldMap.get(sa.Id) : null;

            String templateKey;
            Boolean shouldSend = false;

            // --- Condition 1: Creation ---
            if (Trigger.isInsert) {
                if (sa.Status == 'Scheduled' && sa.EarliestStartTime != null) {
                    templateKey = 'ServiceAppointment_Creation_1776765242942';
                    shouldSend = true;
                }
            }

            // --- Condition 2: Reschedule ---
            else if (Trigger.isUpdate) {
                if (sa.Status == 'Scheduled' &&
                    sa.EarliestStartTime != null &&
                    sa.EarliestStartTime != oldSa.EarliestStartTime) {
                    templateKey = 'ServiceAppointment_Rescheduled_1776786227405';
                    shouldSend = true;
                }

                // --- Condition 3: Cancel ---
                if (sa.Status == 'Canceled' && sa.EarliestStartTime != null) {
                    templateKey = 'ServiceAppointment_Cancelled_1776787213847';
                    shouldSend = true;
                }
            }

            if (!shouldSend) continue;

            if (sa.AccountId == null || !accMap.containsKey(sa.AccountId)) {
                continue;
            }

            Account acc = accMap.get(sa.AccountId);

            // ✅ Skip if no email or no contact
            if (String.isBlank(acc.PersonEmail) || acc.PersonContactId == null) {
                System.debug('### Skipping - No Person Email');
                continue;
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // ✅ REQUIRED for Lightning Template
            mail.setTargetObjectId(acc.PersonContactId);

            // ✅ Related record (Service Appointment)
            mail.setWhatId(sa.Id);

            // ✅ Template Id
            mail.setTemplateId(templates.get(templateKey).Id);

            // Optional
            mail.setSaveAsActivity(false);

            System.debug('### Sending ' + templateKey + ' email to: ' + acc.PersonEmail);
            System.debug('### SchedStartTime: ' + sa.SchedStartTime);
            System.debug('### EarliestStartTime: ' + sa.EarliestStartTime);

            emails.add(mail);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

    } catch (Exception ex) {
        System.debug('### EXCEPTION: ' + ex.getMessage());
    }
}