/**
 * @description  Trigger on `CampaignMemberStatusChangeEvent` with methods to call
 */
trigger CampaignMemberStatusEventTrigger on CampaignMemberStatusChangeEvent(after insert) {
	new CMS_MemberStatusEventTriggerHandler().afterInsert();
}