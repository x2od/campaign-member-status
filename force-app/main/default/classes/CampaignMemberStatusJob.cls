/**
 * @description
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatus
 */
public class CampaignMemberStatusJob implements Schedulable {
	private CampaignMemberService sut = CampaignMemberService.getInstance();

	public void execute(SchedulableContext sc) {
		System.debug('Starting Scheduled Job CampaignMemberStatusJob');
		Set<Id> campaignIdsNeedingFixed = sut.getCampaignsNeedingToBeFixed();
		sut.enforceProtectedStatusesForCampaigns(campaignIdsNeedingFixed);
	}
}