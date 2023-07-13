/**
 * @description       : Responsible for all email related activities
 * @last modified on  : 07-12-2023
**/
public with sharing class SingleEmailService {

    /**
    * @description constructs the SingleEmailMessage objects
    * @author manali | 07-12-2023 
    * @param String emailBody 
    * @param String toAddress 
    * @param String subject 
    * @param String displayName 
    * @return Messaging.SingleEmailMessage 
    **/
    public static Messaging.SingleEmailMessage getSingleEmailMessage(String emailBody, String toAddress, String subject, String displayName, List<Messaging.EmailFileAttachment> attachments){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setHtmlBody(emailBody);
        mail.setToAddresses(new String[] {toAddress }); //UserInfo.getUserEmail()
        mail.setSenderDisplayName(displayName);
        mail.setSubject(subject);
        if(!attachments.isEmpty()){
            mail.setFileAttachments(attachments);
        }
        return mail;
    }
}