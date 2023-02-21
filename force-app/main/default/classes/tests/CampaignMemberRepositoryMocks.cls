/**
 * @description Mock classes for responses to be used across multiple Apex tests
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatusTests
 */
@isTest
public without sharing class CampaignMemberRepositoryMocks {
	/**
	 * Mock class for Campaign Type Member Status values for Webinar Campaign Type
	 */
	public class WebinarMock extends CampaignMemberRepository {
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

	/**
	 * Mock class for Advertisement Campaign Type Member Status Value (only one status)
	 */
	public class AdvertisementMock extends CampaignMemberRepository {
		public override Map<String, List<Campaign_Type_Member_Status__mdt>> getGroupedProtectedStatuses() {
			//System.debug('overriding actually getting MDTs from Salesforce, using hard coded Advertisement MDTs');
			Map<String, List<Campaign_Type_Member_Status__mdt>> response = new Map<String, List<Campaign_Type_Member_Status__mdt>>();
			List<Campaign_Type_Member_Status__mdt> values = new List<Campaign_Type_Member_Status__mdt>();
			Campaign_Type_Member_Status__mdt onlyStatus = new Campaign_Type_Member_Status__mdt();
			onlyStatus.DeveloperName = 'Advertisement_Responded';
			onlyStatus.Label = 'Advertisement-Responded';
			onlyStatus.Campaign_Type__c = 'Advertisement';
			onlyStatus.Campaign_Member_Status__c = 'Responded';
			onlyStatus.IsDefault__c = true;
			onlyStatus.HasResponded__c = true;
			values.add(onlyStatus);

			response.put('Advertisement', values);
			return response;
		}
	}
}