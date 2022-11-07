/**
 * @description
 *
 * @author      Sercante LLC
 * @since       2022
 */
public without sharing class CampaignMemberStatusEventTriggerHandler {
	private static CampaignMemberStatusEventTriggerHandler instance;

	public static CampaignMemberStatusEventTriggerHandler getInstance() {
		if (instance == null) {
			instance = new CampaignMemberStatusEventTriggerHandler();
		}
		return instance;
	}

	public void afterInsert(List<CampaignMemberStatusChangeEvent> events) {
		System.debug('We are processing ' + events.size() + ' Change events');
		Set<Id> campaignMemberIds = new Set<Id>();

		for (CampaignMemberStatusChangeEvent event : events) {
			EventBus.ChangeEventHeader header = event.ChangeEventHeader;
			System.debug('changeType = ' + header.changetype);

			if (header.changetype == 'UPDATE') {
				//List<String> changedFields = header.changedfields; // list of fields updated
				System.debug('Update details: ');
				System.debug(event);
				for (String recordId : header.getRecordIds()) {
					campaignMemberIds.add(Id.valueOf(recordId));
				}
			}
		}
		if (!campaignMemberIds.isEmpty()) {
			Set<Id> campaignIds = new Set<Id>();
			for (CampaignMemberStatus a : [SELECT CampaignId FROM CampaignMemberStatus WHERE Id IN :campaignMemberIds]) {
				campaignIds.add(a.CampaignId);
			}
			CampaignMemberService.getInstance().enforceProtectedStatusesForCampaigns(campaignIds);
		}
	}
}