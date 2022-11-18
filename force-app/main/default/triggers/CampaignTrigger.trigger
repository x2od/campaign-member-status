trigger CampaignTrigger on Campaign(before insert, after insert, before update, after update, before delete, after undelete) {
	new CampaignTriggerHandler().run();
}