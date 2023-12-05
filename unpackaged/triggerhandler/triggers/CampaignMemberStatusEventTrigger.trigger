trigger CampaignMemberStatusEventTrigger on CampaignMemberStatusChangeEvent(after insert) {
	new CMS_MemberStatusEventTriggerHandler().afterInsert();
}