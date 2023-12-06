/**
 * @description Schedulable job to run daily to clean up Campaigns with bad member statuses
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatus
 */
public class CampaignMemberStatusJob implements Schedulable {
	/**
	 * @description Instantiate the `CampaignMemberService` class using `getInstance()` so we also instantiate its `repo` variable
	 */
	private CampaignMemberService cmservice = CampaignMemberService.getInstance();

	/**
	 * @description Execute the scheduled job
	 *
	 * @param sc    `SchedulableContext` for running this job daily
	 */
	public void execute(SchedulableContext sc) {
		//System.debug('Starting Scheduled Job CampaignMemberStatusJob');
		Set<Id> campaignIdsNeedingFixed = cmservice.getCampaignsNeedingToBeFixed();
		cmservice.enforceProtectedStatusesForCampaigns(campaignIdsNeedingFixed);
	}
}