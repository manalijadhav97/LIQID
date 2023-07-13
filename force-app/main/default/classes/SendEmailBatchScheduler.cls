global with sharing class SendEmailBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        SendEmailBatchClass batch = new SendEmailBatchClass(); 
        Database.executeBatch(batch);
     }
}

//To Schedule the class for every 8 hrs a day - thrice a day
// SendEmailBatchScheduler schCls = new SendEmailBatchScheduler();
// String sch = '0 0 */8 ? * *';
// String jobID = System.schedule('SendEmail for Midas Job', sch, schCls);