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
		sut.repo = new WebinarMock();

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

	private class WebinarMock extends CampaignMemberRepository {
		public override Map<String, List<Campaign_Type_Member_Status__mdt>> getGroupedProtectedStatuses() {
			//System.debug('overriding actually getting MDTs from Salesforce, using hard coded Webinar MDTs');
			Map<String, List<Campaign_Type_Member_Status__mdt>> response = new Map<String, List<Campaign_Type_Member_Status__mdt>>();
			List<Campaign_Type_Member_Status__mdt> values = new List<Campaign_Type_Member_Status__mdt>();
			Campaign_Type_Member_Status__mdt registered = new Campaign_Type_Member_Status__mdt();
			registered.DeveloperName = 'Webinar_Registered';
			registered.Label = 'Webinar-Registered';
			registered.Campaign_Type__c = 'Webinar';
			registered.Campaign_Member_Status__c = '1Registered';
			registered.IsDefault__c = true;
			registered.HasResponded__c = false;
			values.add(registered);

			Campaign_Type_Member_Status__mdt attended = new Campaign_Type_Member_Status__mdt();
			attended.DeveloperName = 'Webinar_Attended';
			attended.Label = 'Webinar-Attended';
			attended.Campaign_Type__c = 'Webinar';
			attended.Campaign_Member_Status__c = '2Attended';
			attended.IsDefault__c = false;
			attended.HasResponded__c = true;
			values.add(attended);

			Campaign_Type_Member_Status__mdt watchedOnDemand = new Campaign_Type_Member_Status__mdt();
			watchedOnDemand.DeveloperName = 'Webinar_WatchedOnDemand';
			watchedOnDemand.Label = 'Webinar-WatchedOnDemand';
			watchedOnDemand.Campaign_Type__c = 'Webinar';
			watchedOnDemand.Campaign_Member_Status__c = '3Watched On Demand';
			watchedOnDemand.IsDefault__c = false;
			watchedOnDemand.HasResponded__c = true;
			values.add(watchedOnDemand);

			Campaign_Type_Member_Status__mdt didNotAttend = new Campaign_Type_Member_Status__mdt();
			didNotAttend.DeveloperName = 'Webinar_DidNotAttend';
			didNotAttend.Label = 'Webinar-DidNotAttend';
			didNotAttend.Campaign_Type__c = 'Webinar';
			didNotAttend.Campaign_Member_Status__c = '4Did Not Attend';
			didNotAttend.IsDefault__c = false;
			didNotAttend.HasResponded__c = false;
			values.add(didNotAttend);

			response.put('Webinar', values);
			return response;
		}
	}
}