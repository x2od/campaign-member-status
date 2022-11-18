trigger CampaignMemberStatusEventTrigger on CampaignMemberStatusChangeEvent(after insert) {
	new CampaignMemberStatusEventTriggerHandler().run();
}