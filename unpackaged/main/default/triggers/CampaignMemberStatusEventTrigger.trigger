trigger CampaignMemberStatusEventTrigger on CampaignMemberStatusChangeEvent(after insert) {
	//new CampaignMemberStatusEventTriggerHandler('CampaignMemberStatusEventTriggerHandler').run();
	new CampaignMemberStatusEventHelper().run();
}