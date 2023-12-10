/**
 * @description  Trigger on `Campaign` with methods to call
 */
trigger CampaignTrigger on Campaign(before insert, after insert, before update) { //NOPMD
	System.TriggerOperation triggerEvent = Trigger.operationType;
	switch on triggerEvent {
		when AFTER_INSERT {
			new CMS_CampaignTriggerHandler().afterInsert();
		}
		when BEFORE_INSERT {
			new CMS_CampaignTriggerHandler().beforeInsert();
		}
		when BEFORE_UPDATE {
			new CMS_CampaignTriggerHandler().beforeUpdate();
		}
	}
}