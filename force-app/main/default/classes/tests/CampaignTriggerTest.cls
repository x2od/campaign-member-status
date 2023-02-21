/**
 * @description
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatusTests
 */
@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
@isTest
private class CampaignTriggerTest {
	/* @TestSetup
	static void makeData() {
		User u = new User(Id = UserInfo.getUserId(), UserPermissionsMarketingUser = true);
		update u;
	} */
	@isTest
	static void shouldPreventUsersFromMakingCampaignProtected() {
		// arrange
		Campaign record = new Campaign(Name = 'MyTest', Protect_Campaign_Member_Statuses__c = true);

		// act
		Test.startTest();
		Database.SaveResult result = Database.insert(record, false);
		Test.stopTest();

		// assert
		System.assert(result.isSuccess() == false);
		System.assert(result.getErrors().size() == 1);
	}

	@isTest(seeAllData=true)
	static void shouldMakeCampaignProtectedIfItHasTheRightType() {
		User u = new User(Id = UserInfo.getUserId(), UserPermissionsMarketingUser = true);
		System.runAs(u) {
			// arrange
			CampaignMemberService.getInstance().repo = new CampaignMemberRepositoryMocks.WebinarMock();
			Campaign record = new Campaign(Name = 'MyTest', Type = 'Webinar');

			//act
			Test.startTest();
			insert record;
			Test.stopTest();

			//assert
			Campaign result = [SELECT Name, Type, Protect_Campaign_Member_Statuses__c FROM Campaign WHERE Name = 'MyTest'];
			System.assertEquals(true, result.Protect_Campaign_Member_Statuses__c);
			System.assertEquals('Webinar', result.Type);
		}
	}

	@isTest
	static void shouldAlowNewCampaignWithoutProtectedType() {
		// arrange
		Campaign record = new Campaign(Name = 'MyTest', Type = 'Who Knows');

		//act
		Test.startTest();
		insert record;
		Test.stopTest();

		//assert
		Campaign result = [SELECT Name, Type, Protect_Campaign_Member_Statuses__c FROM Campaign WHERE Name = 'MyTest'];
		System.assertEquals(false, result.Protect_Campaign_Member_Statuses__c);
		System.assertEquals('Who Knows', result.Type);
	}

	@isTest(seeAllData=true)
	static void shouldCreateAllTheRightStatusesForSpecifiedType() {
		// arrange
		CampaignMemberService.getInstance().repo = new CampaignMemberRepositoryMocks.WebinarMock();
		Campaign record = new Campaign(Name = 'MyTest', Type = 'Webinar');

		//act
		Test.startTest();
		insert record;
		Test.stopTest();

		//assert
		List<CampaignMemberStatus> results = [
			SELECT Id, Label, CampaignId, HasResponded, IsDefault, SortOrder
			FROM CampaignMemberStatus
			WHERE CampaignId = :record.Id
		];
		System.assertEquals(4, results.size());
	}

	@isTest(seeAllData=true)
	static void shouldCreateAllTheRightStatusesInSingleStatusType() {
		// arrange
		CampaignMemberService.getInstance().repo = new CampaignMemberRepositoryMocks.AdvertisementMock();
		Campaign record = new Campaign(Name = 'MyTest', Type = 'Advertisement');

		//act
		Test.startTest();
		insert record;
		Test.stopTest();

		//assert
		List<CampaignMemberStatus> results = [
			SELECT Id, Label, CampaignId, HasResponded, IsDefault, SortOrder
			FROM CampaignMemberStatus
			WHERE CampaignId = :record.Id
		];
		System.assertEquals(1, results.size());
	}

	@isTest(seeAllData=true)
	static void shouldPreventChangingTypeForCampaignMember() {
		//arrange
		CampaignMemberService.getInstance().repo = new CampaignMemberRepositoryMocks.AdvertisementMock();
		Campaign record = new Campaign(Name = 'MyTest', Type = 'Advertisement');
		insert record;

		//act
		Test.startTest();
		record.Type = 'Webinar';
		Database.SaveResult result = Database.update(record, false);
		Test.stopTest();

		// assert
		System.assert(result.isSuccess() == false);
		//System.debug(result.getErrors());
		System.assertEquals(1, result.getErrors().size());
		System.assert(result.getErrors().get(0).getMessage().contains(System.Label.CMS_Do_Not_Change_Type));
	}

	@isTest(seeAllData=true)
	static void shouldPreventEnablingProtectedStatusAfterTheFact() {
		//arrange
		Campaign record = new Campaign(Name = 'MyTest', Type = 'Who Cares');
		insert record;

		//act
		Test.startTest();
		record.Protect_Campaign_Member_Statuses__c = true;
		Database.SaveResult result = Database.update(record, false);
		Test.stopTest();

		// assert
		System.assert(result.isSuccess() == false);
		//System.debug(result.getErrors());
		System.assertEquals(1, result.getErrors().size());
		System.debug(result.getErrors().get(0).getMessage());
		System.assert(result.getErrors().get(0).getMessage().contains(System.Label.CMS_Cannot_Re_enable));
	}

	@isTest(seeAllData=true)
	static void shouldCreateStatusesForClonedCampaign() {
		// arrange
		CampaignMemberService.getInstance().repo = new CampaignMemberRepositoryMocks.WebinarMock();
		Campaign original = new Campaign(Name = 'MyTest Original', Type = 'Webinar');
		insert original;

		Campaign updatedOriginal = [SELECT Name, Type, Protect_Campaign_Member_Statuses__c FROM Campaign WHERE Id = :original.Id];
		Campaign clone = updatedOriginal.clone();

		Test.startTest();
		//System.debug('**** Start Test');
		insert clone;
		//System.debug('**** End Test');
		Test.stopTest();

		//assert
		List<CampaignMemberStatus> results = [
			SELECT Id, Label, CampaignId, HasResponded, IsDefault, SortOrder
			FROM CampaignMemberStatus
			WHERE CampaignId = :clone.Id
		];
		System.assertEquals(4, results.size());
	}
}