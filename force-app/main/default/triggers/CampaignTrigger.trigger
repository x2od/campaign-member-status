trigger CampaignTrigger on Campaign(before insert, after insert, before update) {
	CampaignTriggerHandler handler = CampaignTriggerHandler.getInstance();
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			handler.onBeforeInsert(Trigger.new);
		} else if (Trigger.isUpdate) {
			handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
		}
	} else {
		if (Trigger.isInsert) {
			handler.onAfterInsert(Trigger.new);
		}
	}
}