# Technical Design 

# Data Base Model 

<img width="780" alt="Screenshot 2023-07-13 at 10 58 18" src="https://github.com/manalijadhav97/LIQID/assets/32008754/4598cea8-70dd-477a-a9db-767bb6971657">


#Flow Diagram : 

<img width="780" alt="Screenshot 2023-07-13 at 10 58 31" src="https://github.com/manalijadhav97/LIQID/assets/32008754/b3acc2ec-7f9f-4ff1-931d-6d0e85e5c193">

#Technical Design 


#Unit Test 
Input 
Insert new Document :
Notification_Status__c = New 
Document Type : Report
Client : test@gmail.com
File : Attachment1.txt

Notification_Status__c = New 
Document Type : Report
Client : test@gmail.com
File : Attachment2.txt

Notification_Status__c = New 
Document Type : Transactional
Client : test@gmail.com
File : Attachment1.txt

Output : 
Email Sent 2 to test@gmail.com 
1 - Summary email 
Document Type Report - with 2 Files Attachment1.txt & Attachment2.txt
Summary Email : 
![image](https://github.com/manalijadhav97/LIQID/assets/32008754/5a666187-8a4a-4053-b01f-426a3874f42f)


1 - email
Document Type Transactional - with 1 Files Attachment1.txt

Unit Test 2:
Input 
Insert new Document :
Notification_Status__c = New 
Document Type : Report
Client : test@gmail.com
File : Attachment1.txt

Notification_Status__c = New 
Document Type : legal
Client : test@gmail.com
File : Attachment2.txt

Notification_Status__c = New 
Document Type : Transactional
Client : test@gmail.com
File : Attachment1.txt

Notification_Status__c = New 
Document Type : Contract
Client : test@gmail.com
File : Attachment1.txt

Output : 
Email Sent 4 to test@gmail.com of each type

![image](https://github.com/manalijadhav97/LIQID/assets/32008754/5443ca68-7a1b-4466-966e-47164e2377db)

