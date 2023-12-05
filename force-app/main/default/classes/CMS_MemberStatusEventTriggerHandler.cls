/**
 * @description
 *
 * @author      Sercante LLC
 * @since       2022
 * @author      David Schach
 * @since       2023
 * @group       CampaignMemberStatus
 */
public without sharing class CMS_MemberStatusEventTriggerHandler {
	private List<CampaignMemberStatusChangeEvent> newRecords;

	/**
	 * @description Constructor for trigger handler
	 */
	public CMS_MemberStatusEventTriggerHandler() {
		this.newRecords = Trigger.new;
	}

	/**
	 * @description Execute after inserting (creating) change event records
	 */
	public void afterInsert() {
		//System.debug('We are processing ' + newRecords.size() + ' Change newRecords');
		Set<Id> campaignMemberIds = new Set<Id>();

		for (CampaignMemberStatusChangeEvent event : newRecords) {
			EventBus.ChangeEventHeader header = event.ChangeEventHeader;
			//System.debug('changeType = ' + header.changetype);

			if (header.changetype == 'UPDATE') {
				//List<String> changedFields = header.changedfields; // list of fields updated
				//System.debug('Update details: ');
				//System.debug(event);
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