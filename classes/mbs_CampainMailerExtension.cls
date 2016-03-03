public with sharing class mbs_CampainMailerExtension {
    private Campaign m_campaign;
    public Boolean previewMode {get; set;}
    public Boolean mailMembers {get; set;}
    public Boolean mailMemberGuardians {get; set;}
    public String emailSubject {get;set;}
    public String emailBodyHtml {get;set;}
    public String emailBodyText {get;set;}
    
    public List<Contact> selectedMembers {get; set;}
    public List<npe4__Relationship__c> selectedGuardians {get; set;}
    public EmailTemplate eTemplate {get;set;}
    private Messaging.SingleEmailMessage previewEmail;
    public mbs_CampainMailerExtension(ApexPages.StandardController stdController) {
        this.m_campaign = (Campaign)stdController.getRecord();
    }
    public void setHtmlPreview(String val) {
        eTemplate.HtmlValue = val;
    }
    public String getHtmlPreview() {
        return eTemplate.HtmlValue;
    }  
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
        if (selectedMembers.isEmpty() && selectedGuardians.isEmpty()) {
            previewMode = false;
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
        previewMode = false;
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
        previewMode = false;
        if (!mailMembers && ! mailMemberGuardians) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must specify at least one recipient group.'));
            return null;
        }
        generateRecipientList();
        loadEmailTemplate();
        previewMode = true;
        return null;
    }
    
    public void saveTemplate() {
        update eTemplate;
    }
    
    public PageReference sendMail() {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        for (Contact member : selectedMembers) {        
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setTargetObjectId(member.Id);
            emailMessage.setTemplateId(selectedTemplateId);
            //emailMessage.HtmlBody = eTemplate.HtmlValue;
            //emailMessage.Subject = eTemplate.Subject;
            //emailMessage.PlainTextBody = eTemplate.Body;
            emailMessage.setSaveAsActivity(true);
            emailMessages.add(emailMessage);
            if (emailMessages.size() == 100) {
                sendBatchEmail(emailMessages);
                emailMessages.clear();
            }
        }
        for (npe4__Relationship__c guardian : selectedGuardians) {
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setTargetObjectId(guardian.npe4__RelatedContact__c);
            emailMessage.setTemplateId(selectedTemplateId);
            emailMessage.setSaveAsActivity(false);
            emailMessages.add(emailMessage);
            if (emailMessages.size() == 100) {
                sendBatchEmail(emailMessages);
                emailMessages.clear();
            }
        }
        if (emailMessages.size() > 0) {
            sendBatchEmail(emailMessages);
        }
        return null;
    }
    
    private void sendBatchEmail(List<Messaging.SingleEmailMessage> emailMessages) {
        if (emailMessages.isEmpty()) {
            return;
        }
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailMessages);
    }
}