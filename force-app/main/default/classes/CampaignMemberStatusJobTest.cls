/**
 * @description
 *
 * @author      Sercante LLC
 * @since       2022
 */
@isTest
private class CampaignMemberStatusJobTest {
	public static Boolean gotProtectedStatuses = false;
	public static Boolean executed = false;

	@isTest
	static void shouldWork() {
		//arrange
		MockService mock = new MockService();
		CampaignMemberService.instance = mock;

		//act
		Test.startTest();
		System.schedule('testJob', '0 0 23 * * ?', new CampaignMemberStatusJob());
		Test.stopTest();

		//assert
		System.assert(gotProtectedStatuses);
		System.assert(executed);
	}

	private class MockService extends CampaignMemberService {
		public override Set<Id> getCampaignsNeedingToBeFixed() {
			System.debug('called getCampaignsNeedingToBeFixed mock');
			CampaignMemberStatusJobTest.gotProtectedStatuses = true;
			return new Set<Id>();
		}

		public override void enforceProtectedStatusesForCampaigns(Set<Id> campaignIds) {
			System.debug('called enforceProtectedStatusesForCampaigns mock');
			CampaignMemberStatusJobTest.executed = true;
		}
	}
}