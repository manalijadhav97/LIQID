/**
 * @description       : The batch runs every 8 hours and sends notifications to clients
 * @last modified on  : 07-13-2023
**/
public with sharing class SendEmailBatchClass implements Database.Batchable<sObject>,Database.RaisesPlatformEvents{

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Name,Type__c,Notification_Status__c,Generation_Date__c,Customer_Notified_At__c,Client__r.Client_Email__c FROM Document__c WHERE Notification_Status__c=\'New\' ORDER BY Client__r.Client_Email__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Document__c> scope){
        try{
            Map<String,Map<String,List<Document__c>>> clientToTypeDocumentMap = SendEmailBatchHelperClass.createClientToTypeWiseDocumentMap(scope);

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

            Set<Id> documentIds = new Set<Id>();
            // get files related to documents 
            for(Document__c doc : scope) {
                documentIds.add(doc.Id);
            }
            
            Map<Id, Id> documentIdToContentDocumentId = new Map<Id,Id>();
            for(ContentDocumentLink cdLink : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN : documentIds LIMIT 50000]){
                documentIdToContentDocumentId.put(cdLink.ContentDocumentId, cdLink.LinkedEntityId);
            }

            Map<Id, ContentVersion> docIdToContentVersion = new Map<Id, ContentVersion>();
            for(ContentVersion cntVersion : [SELECT Title, FileExtension, ContentDocumentId,VersionData FROM ContentVersion WHERE ContentDocumentId IN : documentIdToContentDocumentId.keySet() LIMIT 50000]){
                docIdToContentVersion.put(documentIdToContentDocumentId.get(cntVersion.ContentDocumentId), cntVersion);
            }

            for(String clientEmail : clientToTypeDocumentMap.keySet()){
                Map<String, List<Document__c>> typeWiseDocs = clientToTypeDocumentMap.get(clientEmail);
                for(String docType : typeWiseDocs.keySet()){
                    String subject = getSubject(docType);
                    String emailBody = getEmailBody(typeWiseDocs.get(docType));
                    List<Messaging.EmailFileAttachment> attachments = getEmailAttachments(typeWiseDocs.get(docType), docIdToContentVersion);
                    mailList.add(SingleEmailService.getSingleEmailMessage(emailBody, clientEmail, subject, 'Midas Wealth', attachments));
                }
            }

            // send emails
            Messaging.sendEmail(mailList);

            // set the nofication on Document__c record
            SendEmailBatchHelperClass.setNotificationStatus(scope);

        }catch(Exception e){
            System.debug('Exception :'+  e.getCause() + e.getStackTraceString() + e.getMessage());
        }   
    }
    public void finish(Database.BatchableContext BC){
        
    }

    public static String getSubject(String docType){
        return 'New ' + docType + ' Documents Uploladed to Midas';
    }
    
    public static String getEmailBody(List<Document__c> documents){
        String emailBody = 'Hi! The following documents have been uploaded.\n';
        for(Document__c doc : documents){
            emailBody +=doc.Name +'\n';
        }
        emailBody += 'Thanks <br/>';
        emailBody += 'Middas Wealth Management';
        return emailBody;
    }

    public static List<Messaging.EmailFileAttachment> getEmailAttachments(List<Document__c> documents, Map<Id, ContentVersion> docIdToContentVersion){
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        for(Document__c document : documents) {

            if(!docIdToContentVersion.containsKey(document.Id)){
                return new List<Messaging.EmailFileAttachment>();
            }

            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            ContentVersion cntVersion = docIdToContentVersion.get(document.Id);
            attachment.setFileName(cntVersion.Title);
            attachment.setBody(cntVersion.VersionData);
            attachments.add(attachment);
        }
        return attachments;
    }
}

// Calculation 
// No of users - 4000
// no of docu type - 4
// maximum no of emails to send - 16000 *