/**
 * @description Test class
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatusTests
 */
@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
@isTest
private class CampaignMemberServiceTest {
	@isTest(seeAllData=true)
	static void shouldEnforceProtectedStatusesForCampaign() {
		//arrange
		Test.enableChangeDataCapture();
		CampaignMemberService sut = CampaignMemberService.getInstance();
		sut.repo = new CampaignMemberRepositoryMocks.WebinarMock();

		Campaign camp = new Campaign(Name = 'MyTest', Type = 'Webinar', IsActive = true);
		insert camp;
		Test.getEventBus().deliver(); //clear the bus so that we later get Update events

		//act
		Test.startTest();
		//System.debug('start of test');

		//here we mess up our data
		delete [SELECT Id FROM CampaignMemberStatus WHERE Label = '3Watched On Demand'];
		CampaignMemberStatus registered = [SELECT Id FROM CampaignMemberStatus WHERE Label = '1Registered'];
		registered.HasResponded = true;
		update registered;
		System.Assert.isTrue(sut.getCampaignsNeedingToBeFixed().contains(camp.Id));
		Test.stopTest();

		//assert
		List<CampaignMemberStatus> results = [SELECT Id, Label, IsDefault, HasResponded FROM CampaignMemberStatus WHERE CampaignId = :camp.Id ORDER BY Label];
		Assert.areEqual('1Registered', results.get(0).Label);
		Assert.areEqual(false, results.get(0).HasResponded);
		Assert.areEqual('2Attended', results.get(1).Label);
		Assert.areEqual('3Watched On Demand', results.get(2).Label);
		Assert.areEqual('4Did Not Attend', results.get(3).Label);
	}
}