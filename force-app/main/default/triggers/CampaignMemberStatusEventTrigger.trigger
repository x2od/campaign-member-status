trigger CampaignMemberStatusEventTrigger on CampaignMemberStatusChangeEvent(after insert) {
	CampaignMemberStatusEventTriggerHandler.getInstance().afterInsert(Trigger.new);
}