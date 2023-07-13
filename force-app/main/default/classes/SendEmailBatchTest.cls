@IsTest
public with sharing class SendEmailBatchTest {
    
    @IsTest
    static void setupTestData(){
        
        List<Document__c> documentList = new List<Document__c>();
        for(Integer i=0 ;i <5;i++)
        {
            Document__c doc = new Document__c();
            doc.Name ='Name'+i;
            doc.Type__c = 'Report';
            doc.Notification_Status__c = 'New';
            documentList.add(doc);
        }
        for(Integer i=0 ;i <5;i++)
        {
            Document__c doc = new Document__c();
            doc.Name ='Name'+i;
            doc.Type__c = 'Transactional';
            doc.Notification_Status__c = 'New';
            documentList.add(doc);
        }
        for(Integer i=0 ;i <5;i++)
        {
            Document__c doc = new Document__c();
            doc.Name ='Name'+i;
            doc.Type__c = 'Legal';
            doc.Notification_Status__c = 'New';
            documentList.add(doc);
        }
        for(Integer i=0 ;i <5;i++)
        {
            Document__c doc = new Document__c();
            doc.Name ='Name'+i;
            doc.Type__c = 'Contract';
            doc.Notification_Status__c = 'New';
            documentList.add(doc);
        }
        
        insert documentList;
        
    }
     @IsTest
    static void testBatch(){
        
        Test.startTest();
        setupTestData();
        SendEmailBatchClass obj = new SendEmailBatchClass();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        
    }

}