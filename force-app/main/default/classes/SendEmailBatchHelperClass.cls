public with sharing class SendEmailBatchHelperClass {
    
    public static Map<String,Map<String,List<Document__c>>> createClientToTypeWiseDocumentMap(List<Document__c> scope){
        Map<String,Map<String,List<Document__c>>> clientToTypeDocumentMap = new Map<String,Map<String,List<Document__c>>>(); 
        for(Document__c s : scope){
            if(clientToTypeDocumentMap.containsKey(s.Client__r.Client_Email__c)){
                Map<String,List<Document__c>> typeToDocMap = clientToTypeDocumentMap.get(s.Client__r.Client_Email__c);
                if(typeToDocMap.containsKey(s.Type__c)){
                    typeToDocMap.get(s.Type__c).add(s);       
                }else{
                    typeToDocMap.put(s.Type__c,new List<Document__c>{s});
                }
                clientToTypeDocumentMap.put(s.Client__r.Client_Email__c,typeToDocMap);
            }else {
                Map<String,List<Document__c>> typeToDocMap = new Map<String,List<Document__c>>();
                typeToDocMap.put(s.Type__c,new List<Document__c>{s});
                clientToTypeDocumentMap.put(s.Client__r.Client_Email__c,typeToDocMap);
            }
        }
        System.debug('clientToTypeDocumentMap Helper:'+clientToTypeDocumentMap);
        if(clientToTypeDocumentMap.isEmpty()){
            return null;
        }
        return clientToTypeDocumentMap;
    }

    public static void setNotificationStatus(List<Document__c> scope){
        List<Document__c> updatedDocuments = new List<Document__c> ();
        for(Document__c document : scope){
            document.Notification_Status__c = 'Customer Notified';
            document.Customer_Notified_At__c = System.now();
            updatedDocuments.add(document);
        }
        Database.update(updatedDocuments,false);
    }

    public static Messaging.SingleEmailMessage getSingleEmailMessage(String emailBody, String toAddress, String subject){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setHtmlBody(emailBody);
        mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject(subject);
        return mail;
    }
    // public static Messaging.SingleEmailMessage createEmail(List<String> documentTypeList){
    //     for(String docType : documentTypeList){
    //         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //         Map<String,List<Document__c>> documentType = clientToTypeDocumentMap.get(eachClient);
    //         System.debug('docType :'+docType);
    //         String Message = 'Hello Customer, <br/>';
    //         Message += 'A new document : New Document has be uploaded to your portfolio. <br/>';
    //         Message += 'Document Type : ' + docType +'<br/>';        
    //         Message += 'Thanks <br/>';
    //         Message += 'Middas Wealth Management';
    //         mail.setHtmlBody(Message);
    //         mail.setToAddresses(new String[] {eachClient});
    //         mail.setReplyTo('manalijadhav97@gmail.com');
    //         mail.setSenderDisplayName('Batch Processing');
    //         mail.setSubject('New Document : Middas Wealth Management');
    //         //mail.setPlainTextBody('Batch Process has completed');
    //         system.debug('mail:'+mail);
    //         //mailList.add(mail);
    //     }
    // }
}