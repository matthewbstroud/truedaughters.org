public with sharing class mbs_CampainMailerExtension {
    private Campaign m_campaign;
    public Boolean getIsEditPage() {
        return currentPage == 'EDIT';
    }
    public Boolean getIsPreviewPage() {
        return currentPage == 'PREVIEW';
    }
    public Boolean getIsResultPage() {
        return currentPage == 'RESULT';
    }
    public Boolean mailMembers {get; set;}
    public Boolean mailMemberGuardians {get; set;}
    public String emailSubject {get;set;}
    public String emailBodyHtml {get;set;}
    public String emailBodyText {get;set;}
    public Integer emailCount {get;set;}

    public string currentPage {get;set;}
    public List<Contact> selectedMembers {get; set;}
    public List<npe4__Relationship__c> selectedGuardians {get; set;}
    public EmailTemplate eTemplate {get;set;}
    private Messaging.SingleEmailMessage previewEmail;
    public mbs_CampainMailerExtension(ApexPages.StandardController stdController) {
        currentPage = 'EDIT';
        this.m_campaign = (Campaign)stdController.getRecord();
    }
    public String HtmlPreview {get;set;}
    public String getTextPreview() {
        return eTemplate.Body;
    } 
    public void setTextPreview(String val) {
        eTemplate.Body = val;
    }
    
    public void removeMemberFromList() {
        if (selectedMembers.size() == 1 && selectedGuardians.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must have at least one recipient.'));
            return;
        }
        ID memberId = Id.valueOf(apexpages.currentpage().getparameters().get('memberId'));
        for(integer i=0; i<selectedMembers.size(); i++) {
            if (selectedMembers[i].Id == memberId) {
                selectedMembers.remove(i);
                break;
            }
        }
    }
    
    public void removeGuardianFromList() {
        if (selectedGuardians.size() == 1 && selectedMembers.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must have at least one recipient.'));
            return;
        }
        ID guardianId = Id.valueOf(apexpages.currentpage().getparameters().get('guardianId'));
        for(integer i=0; i<selectedGuardians.size(); i++) {
            if (selectedGuardians[i].Id == guardianId) {
                selectedGuardians.remove(i);
                break;
            }
        }
    }
    
	public String selectedTemplateId { public get; public set; }

    public List<SelectOption> getMailerTemplates() {
        List<SelectOption> options = new List<SelectOption>();
        
        for (EmailTemplate t : [
            select Id,Name 
            from EmailTemplate
            where Folder.Name = 'Campaign Mailers' ORDER BY Name
        ]) {
            options.add(new SelectOption(t.Id,t.Name));
        }
        return options;
    }
    
    private void generateRecipientList() {
        System.debug('generateRecipientList()');
        selectedMembers = new List<Contact>();
        selectedGuardians = new List<npe4__Relationship__c>();
        List<Contact> allMembers = [SELECT Contact.Name, Contact.Email, 
                                 (SELECT npe4__RelatedContact__r.Name, npe4__RelatedContact__r.Email, npe4__Type__c, npe4__Relationship_Explanation__c FROM npe4__Relationships__r) 
                                 FROM Contact WHERE Id in (SELECT ContactId FROM CampaignMember WHERE CampaignId = :m_campaign.Id) ORDER BY Name];
        System.debug('allMembers=' + allMembers);
        for (Contact member : allMembers) {
            System.debug('member=' + member);
            if (mailMembers) {
                selectedMembers.add(member);
            }
            if (mailMemberGuardians && member.npe4__Relationships__r != null && member.npe4__Relationships__r.size() > 0) {
                npe4__Relationship__c guardian = findGuardian(member.npe4__Relationships__r, 'Mother');
                if (guardian == null) {
                    guardian = findGuardian(member.npe4__Relationships__r, 'Father');
                }
                if (guardian == null) {
                    guardian = findGuardian(member.npe4__Relationships__r, 'Grandmother');
                }
                if (guardian == null) {
                    guardian = findGuardian(member.npe4__Relationships__r, 'Grandfather');
                }
                if (guardian == null) {
                    guardian = member.npe4__Relationships__r[0];
                }
                selectedGuardians.add(guardian);
            }
        }
    }
    
    private npe4__Relationship__c findGuardian(List<npe4__Relationship__c> guardians, String guardianType) {
        for (npe4__Relationship__c guardian : guardians) {
            if (guardian.npe4__Type__c == guardianType) {
                return guardian;
            }
        }
        return null;
    }
    
    public PageReference goBack() {
        currentPage = 'EDIT';
        return null;
    }
    
    private void loadEmailTemplate() {
        eTemplate = [SELECT Id, subject, body, HtmlValue FROM EmailTemplate WHERE Id = :selectedTemplateId];
    }
    
    private void loadPreviewEmail() {
        previewEmail = new Messaging.SingleEmailMessage();
        previewEmail.setTargetObjectId(UserInfo.getUserId());
        previewEmail.setTemplateId(selectedTemplateId);
        previewEmail.saveAsActivity = false;
        Messaging.sendEmail(new List<Messaging.Email> {previewEmail});
    }
    
    public PageReference previewMailer() {
        if (!mailMembers && ! mailMemberGuardians) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must specify at least one recipient group.'));
            return null;
        }
        generateRecipientList();
        HtmlPreview = getEmailHeader('Jane Doe') + emailBodyHtml;
        //loadEmailTemplate();
        currentPage = 'PREVIEW';
        return null;
    }
    
    public void saveTemplate() {
        update eTemplate;
    }
    
    private string getEmailHeader(String memberName) {
        string headerHtml = '<img alt="True Daughters" height="200" width="600" src="https://cs4.salesforce.com/servlet/servlet.ImageServer?id=015P0000000GMRO&oid=00DP0000003oUZq" /><br/>' + 
            '<p style="font-family:\'HelveticaNeue\',Helvetica,Arial;fone-size:14px;color:#000000;">Dear&nbsp;' + memberName + ',</p><p/>' +
            '<p style="font-family:\'HelveticaNeue\',Helvetica,Arial;">';
        return headerHtml;
    }
    
    private string getEmailFooter() {      
         string footerHtml = '</p>' + 
            '<p style="font-family:\'HelveticaNeue\',Helvetica,Arial;fone-size:14px;color:#000000;">Sincerely,</p><p/>' +
            '<p style="font-family:\'HelveticaNeue\',Helvetica,Arial;">' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + '<br/>' +
             UserInfo.getOrganizationName() + '<br/>' + UserInfo.getUserEmail() + '</p>';
        return footerHtml;
    }
    
    public PageReference sendMail() {
        emailCount = 0;
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        String headerHtml;

        for (Contact member : selectedMembers) {        
            if (String.isNotEmpty(member.Email)) {
                Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
                emailMessage.setTargetObjectId(member.Id);
                //emailMessage.setTemplateId(selectedTemplateId);            
                headerHtml = getEmailHeader(member.Name);
                emailMessage.HtmlBody = headerHtml + emailBodyHtml;
                emailMessage.Subject = emailSubject;
                emailMessage.setSaveAsActivity(true);
                emailMessages.add(emailMessage);
                if (emailMessages.size() == 100) {
                    sendBatchEmail(emailMessages);
                    emailMessages.clear();
                }
            }            
        }
        for (npe4__Relationship__c guardian : selectedGuardians) {
            if (String.isNotEmpty(guardian.npe4__RelatedContact__r.Email)) {
                Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
                emailMessage.setTargetObjectId(guardian.npe4__RelatedContact__c);
                headerHtml = getEmailHeader(guardian.npe4__RelatedContact__r.Name);
                emailMessage.HtmlBody = headerHtml + emailBodyHtml;
                emailMessage.Subject = emailSubject;
                emailMessage.setSaveAsActivity(false);
                emailMessages.add(emailMessage);
                if (emailMessages.size() == 100) {
                    sendBatchEmail(emailMessages);
                    emailMessages.clear();
                }
            }            
        }
        if (emailMessages.size() > 0) {
            sendBatchEmail(emailMessages);
        }
        currentPage = 'RESULT';
        return null;
    }
    
    private void sendBatchEmail(List<Messaging.SingleEmailMessage> emailMessages) {
        if (emailMessages.isEmpty()) {
            return;
        }
        emailCount += emailMessages.size();
        List<Messaging.SendEmailResult> results;
        try {
            results = Messaging.sendEmail(emailMessages);
        }catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sending Email: ' + e.getMessage()));
        }
    }
}