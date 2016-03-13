@isTest(seeAllData=true)
public class mbs_CampaignMailerExtensionTest {
	@isTest 
    public static void testMailer() {
        Account acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        Document document;
        document = new Document();
        document.Body = Blob.valueOf('/9j/4AAQSkZJRgABAQEASABIAAD/4QNoRXhpZgAASUkqAAgAAAAEABoBBQABAAAAPgAAABsBBQABAAAARgAAACgBAwABAAAAAgAAAGmHBAABAAAATgAAAHgAAABIAAAAAQAAAEgAAAABAAAAAwAAkAcABAAAADAyMTAAoAcABAAAADAxMDABoAMAAQAAAP//AAAAAAAABgADAQMAAQAAAAYAAAAaAQUAAQAAAMYAAAAbAQUAAQAAAM4AAAAoAQMAAQAAAAIAAAABAgQAAQAAANYAAAACAgQAAQAAAIoCAAAAAAAASAAAAAEAAABIAAAAAQAAAP/Y/+AAEEpGSUYAAQEAAAEAAQAA/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMPFB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEcITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/8AAEQgACAAEAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A5OUJcFWtjJGoUKwSNsFgOTRRRXO6juc7kf/Z/+EFtWh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8APD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiB4bWxuczp4bXBNTT0naHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyc+CiAgPHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD5FMEE4QTEwNUQzMUYzNDQxNDAyQjIzMjE4MDgxNkZENjwveG1wTU06T3JpZ2luYWxEb2N1bWVudElEPgogIDx4bXBNTTpJbnN0YW5jZUlEPnhtcC5paWQ6MTUwM0Y3NTQ0NjQwRTUxMTlCQjFEOTJGMDlCOTlCMzc8L3htcE1NOkluc3RhbmNlSUQ+CiAgPHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD5FMEE4QTEwNUQzMUYzNDQxNDAyQjIzMjE4MDgxNkZENjwveG1wTU06T3JpZ2luYWxEb2N1bWVudElEPgogIDx4bXBNTTpEb2N1bWVudElEIHJkZjpyZXNvdXJjZT0neG1wLmRpZDoxNTAzRjc1NDQ2NDBFNTExOUJCMUQ5MkYwOUI5OUIzNycgLz4KICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOjE1MDNGNzU0NDY0MEU1MTE5QkIxRDkyRjA5Qjk5QjM3PC94bXBNTTpJbnN0YW5jZUlEPgogPC9yZGY6RGVzY3JpcHRpb24+CgogPHJkZjpEZXNjcmlwdGlvbiB4bWxuczp4bXA9J2h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8nPgogIDx4bXA6TWV0YWRhdGFEYXRlPjIwMTUtMDgtMTFUMTI6MzA6NTItMDQ6MDA8L3htcDpNZXRhZGF0YURhdGU+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHhtbG5zOmV4aWY9J2h0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvJz4KICA8ZXhpZjpYUmVzb2x1dGlvbj43MjwvZXhpZjpYUmVzb2x1dGlvbj4KICA8ZXhpZjpZUmVzb2x1dGlvbj43MjwvZXhpZjpZUmVzb2x1dGlvbj4KICA8ZXhpZjpSZXNvbHV0aW9uVW5pdD5JbmNoPC9leGlmOlJlc29sdXRpb25Vbml0PgogIDxleGlmOkNvbXByZXNzaW9uPkpQRUcgY29tcHJlc3Npb248L2V4aWY6Q29tcHJlc3Npb24+CiAgPGV4aWY6WFJlc29sdXRpb24+NzI8L2V4aWY6WFJlc29sdXRpb24+CiAgPGV4aWY6WVJlc29sdXRpb24+NzI8L2V4aWY6WVJlc29sdXRpb24+CiAgPGV4aWY6UmVzb2x1dGlvblVuaXQ+SW5jaDwvZXhpZjpSZXNvbHV0aW9uVW5pdD4KICA8ZXhpZjpFeGlmVmVyc2lvbj5FeGlmIFZlcnNpb24gMi4xPC9leGlmOkV4aWZWZXJzaW9uPgogIDxleGlmOkZsYXNoUGl4VmVyc2lvbj5GbGFzaFBpeCBWZXJzaW9uIDEuMDwvZXhpZjpGbGFzaFBpeFZlcnNpb24+CiAgPGV4aWY6Q29sb3JTcGFjZT5VbmNhbGlicmF0ZWQ8L2V4aWY6Q29sb3JTcGFjZT4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0ncic/Pgr/4gxYSUNDX1BST0ZJTEUAAQEAAAxITGlubwIQAABtbnRyUkdCIFhZWiAHzgACAAkABgAxAABhY3NwTVNGVAAAAABJRUMgc1JHQgAAAAAAAAAAAAAAAAAA9tYAAQAAAADTLUhQICAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABFjcHJ0AAABUAAAADNkZXNjAAABhAAAAGx3dHB0AAAB8AAAABRia3B0AAACBAAAABRyWFlaAAACGAAAABRnWFlaAAACLAAAABRiWFlaAAACQAAAABRkbW5kAAACVAAAAHBkbWRkAAACxAAAAIh2dWVkAAADTAAAAIZ2aWV3AAAD1AAAACRsdW1pAAAD+AAAABRtZWFzAAAEDAAAACR0ZWNoAAAEMAAAAAxyVFJDAAAEPAAACAxnVFJDAAAEPAAACAxi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');
        document.ContentType = 'image/jpg';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [select id from folder where name = 'Campaign Mailer Images'].id;
        insert document;
        Contact daughter = new Contact();
        daughter.FirstName = 'Nancy';
        daughter.LastName = 'Drew';
        daughter.Email = 'nancy.drew@fake.com';
        daughter.AccountId = acct.Id;
        insert daughter;
        System.debug('daughterId=' + daughter.Id);
        Contact mother = new Contact();
        mother.FirstName = 'Kate';
        mother.LastName = 'Drew';
        mother.Email = 'kate.drew@fake.com';
        mother.AccountId = acct.Id;
        insert mother;       
        System.debug('motherId=' + mother.Id);
        npe4__Relationship__c relationship = new npe4__Relationship__c();
        relationship.npe4__Contact__c = daughter.Id;
        relationship.npe4__RelatedContact__c = mother.Id;
        relationship.npe4__Type__c = 'Mother';
        insert relationship;
        Campaign camp = new Campaign();
        camp.Name = 'Test Camp';
        camp.IsActive = true;
        insert camp;
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = camp.Id;
        cm.ContactId = daughter.Id;
        insert cm;
        ApexPages.StandardController stdCampaign = new ApexPages.StandardController(camp);
        Test.startTest();
        mbs_CampainMailerExtension extension = new mbs_CampainMailerExtension(stdCampaign);
        System.assertEquals(true, extension.getIsEditPage(), 'should start on edit page');
        System.assert(extension.EmailImages.size() > 1, 'should be at least one available image');
        System.assertNotEquals(null, extension.EmailImages[0].Name, 'email image should have a name');
        System.assertNotEquals(null, extension.EmailImages[0].ExternalLink, 'email image should have a link');
        System.assertNotEquals(null, extension.EmailImages[0].CreatedDate, 'email image should have a created date');
        extension.mailMembers = true;
        extension.mailMemberGuardians = true;
        extension.emailSubject = 'This is a test email';
        extension.emailBodyHtml = 'This is the sample body';
        extension.previewMailer();
        System.assertEquals(true, extension.getIsPreviewPage(), 'should be on preview page');
        System.assertEquals(1, extension.selectedMembers.size(), 'should have a member selected');	
        System.assertEquals(1, extension.selectedGuardians.size(), 'should have a guardian selected');
        System.currentPageReference().getParameters().put('guardianId', extension.selectedGuardians[0].Id);
        extension.removeGuardianFromList();
        System.assertEquals(0, extension.selectedGuardians.size(), 'guardian should have been removed');
        System.currentPageReference().getParameters().put('memberId', extension.selectedMembers[0].Id);
        extension.removeMemberFromList();
        System.assertEquals(1, extension.selectedMembers.size(), 'member should not have been removed');
        extension.goBack();
        extension.previewMailer();
        System.assertEquals(1, extension.selectedGuardians.size(), 'guardian should be put back');
        System.currentPageReference().getParameters().put('memberId', extension.selectedMembers[0].Id);
        extension.removeMemberFromList();
        System.assertEquals(0, extension.selectedMembers.size(), 'member should have been removed');
        System.currentPageReference().getParameters().put('guardianId', extension.selectedGuardians[0].Id);
        extension.removeGuardianFromList();
        System.assertEquals(1, extension.selectedGuardians.size(), 'guardian should not have been removed');
        extension.goBack();
        extension.previewMailer();
        System.assertEquals(1, extension.selectedMembers.size(), 'member should be put back');
        extension.sendMail();
        System.assertEquals(true, extension.getIsResultPage(), 'should be on preview page');
        System.assertEquals(2, extension.sentContacts.size(), 'should have sent two email');
        Test.stopTest();

    }
}