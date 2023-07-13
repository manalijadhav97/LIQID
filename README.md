# Technical Design 

# Solutions 
## Scenario 1
### Database Model 
![image](https://github.com/manalijadhav97/LIQID/assets/32008754/5f682d3a-54e6-469b-ab08-42d57b0c1d03)

# Introduction to Objects : 

1. User Object : Standard Salesforce Object , every client can be stored as a user in SF
   Fields :
   UserId
   Email
2. Client /Account Object : Standard Account SF Object can be used to store the Client's information.(Parent Object)
3. Product Offering : This custom object holds the information on different products that the comapny owns. 
   Record Types : (Wealth,Cash,Equity).
4. Investement : This is a junction object for Client/Account and Product Offering object - this stores the investment options stored by our client with different product offering combinations.
5. Financial Institutions : Custom Object holds the information on different types of financial instituations offering different products for investment.
6. Portfolio Document : Custom Object holds the Client/Accounts documents , used for investments further, it has has a child object Files, this is a standard SF object used to hold raw files/attchments.

### Questions to ask 
- What client information needs to be captured during the onboarding process?
- What are the specific attributes and details of each investment product?
- What information is required to create and manage investments for clients?
- Are there any specific validations or rules for data entry?
- Are there any integrations required with external systems or APIs (for example with Partner system)?
- What are the important metrics and reports that need to be tracked and generated?

## Scenario 2
# Proposed Solution Approaches : 
# Option 1 :
Send Email using Scheduled Batch Apex. 

Background : 
Salesforce Essentials and Professional Edition: 250 emails per day per Salesforce license.
Enterprise Edition: 500 emails per day per Salesforce license.
Unlimited Edition: 1,000 emails per day per Salesforce license.
Performance Edition: 3,000 emails per day per Salesforce license.
Developer Edition: 15 emails per day.
Keeping in mind that atleast Salesforce Essentials / Professional Edition will be used : 
We have a client base of 4000 users , out of which 30% are to get new documents every week and email is to be send out each day 
Assume 30% od the client base (1200 clients) get new emails per day and 1 summary email per document type (4 types) 
each client can receive max 4 emails per day - 1200*4 - 4800 emails per day - This is under SF external email limit of 5000 per day.
But further more the customer base is to increase by 10% every quarter - to accomodate this requirement and make the approach more scalable, we propose to create a user object record for each client , by doing so we get the following ability as per Salesforce Essentials and Professional Edition license configration.
1 user - 250 emails /day
4000 users - 1,000,000 emails /day

# Option 2 :
Middle ware to handle sending emails 
We can send accumlated data of 
client email - Documnt Type - DocumentName,Files 

When using an external email service, you can store the email addresses of your customers or recipients in the Contact object in Salesforce. By integrating your external email service with Salesforce, you can send emails directly from the external email service using the email addresses stored in the Contact records.


# Implemented Solution : Option 1

<img width="780" alt="Screenshot 2023-07-13 at 10 58 31" src="https://github.com/manalijadhav97/LIQID/assets/32008754/b3acc2ec-7f9f-4ff1-931d-6d0e85e5c193">

# Technical Design 

Approach : 
Keeping in mind the use-case & salesforce limits, the approch we went for was sending the emails was via scheduled batch class. 
Batch approach was chosen keeping in mind the bulkifiation and to achieve scalability. This approach also gives us the flexibility to make accomdate any further business changes , considering the complexity. 

# Assumptions 

The logic is the objects at play here are : 
1. Document__c - custome SF object , used to store the document related information. 
Client__c - This custom object is created for testing purpose of scenario 2. 
2. In reality the Client object can be a standard Account object and with Client Email (Formulae field : Standard User Object.Email)
3. This is to extend our email limit. 
(As only 5000 external emails can be sent out by an org, we can extend this limit by creating the user's in SF refer option1 under solution Approaches for more understanding.)
4. A scheduled batch apex - which will run every 8 hrs - thrice a day will pick up Document__c object records for which email is not yet sent
(This can be identified with field Notification_Status__c field set to New for Email notification not sent documents.)
Furthermore, New document of type report can be inserted multiple times in a day for a client , but we would send out only single email (sumamry email) conatining the document names and files of all the updated documents. Sending one such sumamry email will help with email limit and will also not bombared the customer with updates.

# Unit Test 

For simplicity : We can Insert a Document__c object's record from Docuemnt__c Tab 
Here : Assumption is that the web service exposed will insert the Document__c object , link it to the Client (Data Model reference is Client/Account Object), along with Files(Standard Files Object in SF).

Input :
Insert new Document 

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

