trigger CampaignTrigger on Campaign(before insert, after insert, before update) {
	//new CampaignTriggerHandler('CampaignTriggerHandler').run();

	new CampaignTriggerHelper(Trigger.new, Trigger.oldMap, Trigger.OperationType).run();
}