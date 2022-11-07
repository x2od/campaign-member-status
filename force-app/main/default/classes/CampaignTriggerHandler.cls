/**
 * @description This class handles the automation required on Adding/Editing Campaign records
 *
 * @author      Sercante LLC
 * @since       2022
 */
public without sharing class CampaignTriggerHandler {
	//a little poor-man's dependency injection mixed with Singleton pattern
	@TestVisible
	private static CampaignTriggerHandler instance;

	private CampaignMemberService campaignMemberService;

	public static Boolean bypass = false;

	public static CampaignTriggerHandler getInstance() {
		if (instance == null) {
			instance = new CampaignTriggerHandler();
		}
		return instance;
	}

	/**
	 * @description Default constructor. Runs getInstance of CampaignMemberService
	 * @see CampaignMemberService.getInstance
	 */
	public CampaignTriggerHandler() {
		this.CampaignMemberService = CampaignMemberService.getInstance();
	}

	/**
	 * @description   Constructor that takes `CampaignMemberService` object
	 * <br>Never called - should be deleted
	 *
	 * @param service Pass in `CampaignMemberService` when running this trigger handler
	 */
	public CampaignTriggerHandler(CampaignMemberService service) {
		this.CampaignMemberService = service;
	}

	/**
	 * Make sure people aren't trying to mess with the value of our Custom Field
	 */
	public void onBeforeInsert(List<Campaign> campaigns) {
		if (bypass) {
			return;
		}

		Map<String, List<Campaign_Type_Member_Status__mdt>> groupedProtectedStatuses = CampaignMemberService.getGroupedProtectedStatuses();

		for (Campaign camp : campaigns) {
			if (camp.isClone()) {
				continue;
			} //the rules for the cloned item should follow

			System.debug('Checking to see if the idiot checked it before hand');
			if (camp.Protect_Campaign_Member_Statuses__c) {
				System.debug('yup they gone done and did it');
				camp.addError('Protect_Campaign_Member_Statuses__c', 'Don\'t check this box silly');
				continue;
			}
			System.debug('Checking to see if ' + camp.Name + ' has Protected Member Statuses');
			if (groupedProtectedStatuses.containsKey(camp.Type)) {
				System.debug('This camp does have Protected Member Statuses, checking the box');
				camp.Protect_Campaign_Member_Statuses__c = true;
			}
		}
	}

	/**
	 * Let's actually go ahead and set up our new Campaign with the correct Statuses
	 */
	public void onAfterInsert(List<Campaign> campaigns) {
		if (bypass) {
			return;
		}

		Map<String, List<Campaign_Type_Member_Status__mdt>> groupedProtectedStatuses = CampaignMemberService.getGroupedProtectedStatuses();
		Set<Id> campaignIdsNeedingStatuses = new Set<Id>();
		for (Campaign camp : campaigns) {
			if (camp.Protect_Campaign_Member_Statuses__c) {
				campaignIdsNeedingStatuses.add(camp.Id);
			}
		}

		if (campaignIdsNeedingStatuses.isEmpty()) {
			System.debug('There are no Campaigns being created that have a Protected Type');
			return;
		}
		System.debug('We need to process ' + campaignIdsNeedingStatuses.size() + ' Campaigns to have Protected statuses');

		//get our DML lists ready
		List<CampaignMemberStatus> toUpdate = new List<CampaignMemberStatus>();
		List<CampaignMemberStatus> toInsert = new List<CampaignMemberStatus>();
		List<CampaignMemberStatus> toDelete = new List<CampaignMemberStatus>();

		//get our Campaigns and CampaignMemberStatuses that Salesforce created
		List<Campaign> campaignsToProcess = CampaignMemberService.getCampaignsWithMemberStatuses(campaignIdsNeedingStatuses);

		for (Campaign camp : campaignsToProcess) {
			System.debug('Campaign ' + camp.Name + '\'s type is one that should have Protected statuses');
			List<CampaignMemberStatus> cmsList = camp.CampaignMemberStatuses;
			System.debug('There are ' + cmsList.size() + ' existing CampaignMemberStatus records for the Campaign');

			//Salesforce Generates 2 by default. the cmsList is sorted DESC by IsDefault field
			//this code is a little brittle, however it should suffice for a while
			CampaignMemberStatus existingDefault = cmsList.get(0);
			CampaignMemberStatus existingResponded = cmsList.get(1);

			List<Campaign_Type_Member_Status__mdt> expectedStatuses = groupedProtectedStatuses.get(camp.Type);
			if (expectedStatuses.size() == 1) {
				Campaign_Type_Member_Status__mdt expectedStatus = expectedStatuses.get(0);
				System.debug('There is only 1 expected CampaignMemberStatus, so it is easy to set this up');
				//we need to be careful about which record we keep, so that we can safely have only 1 record AND make
				//sure it is Default & Responded.

				CampaignMemberStatus desiredRecord = existingDefault;
				CampaignMemberStatus deletedRecord = existingResponded;

				if (expectedStatus.Campaign_Member_Status__c == 'Responded') {
					//now if the only status we want to keep is Responded, we can't keep the "default" record,
					//so we will keep the old "Responded" record and just set it as default
					desiredRecord = existingResponded;
					desiredRecord.IsDefault = true;

					deletedRecord = existingDefault;
				} else {
					desiredRecord.HasResponded = true;
					desiredRecord.Label = expectedStatus.Campaign_Member_Status__c;
				}

				toUpdate.add(desiredRecord);
				toDelete.add(deletedRecord);
			} else {
				System.debug('There is more than 1 expected CampaignMemberStatus, so we need to figure things out');
				//First, process the Default Status
				Boolean processedSent = false;
				Integer sortOrder = 3;
				for (Campaign_Type_Member_Status__mdt expected : expectedStatuses) {
					System.debug('Checking to see what we need to do with expected status of ' + expected.Label);
					if (expected.IsDefault__c) {
						System.debug('It is the default status, updating the system-generated default status to match');
						existingDefault.Label = expected.Campaign_Member_Status__c;
						existingDefault.HasResponded = expected.HasResponded__c;

						System.debug(existingDefault);
						toUpdate.add(existingDefault);
					} else {
						System.debug('It is not the default status, checking to see what we need to do');
						if (!processedSent) {
							System.debug('We will update the existing Sent status to match');
							existingResponded.Label = expected.Campaign_Member_Status__c;
							existingResponded.HasResponded = expected.HasResponded__c;

							System.debug(existingResponded);
							toUpdate.add(existingResponded);
							processedSent = true;
						} else {
							System.debug('We need to create a new Status');
							CampaignMemberStatus newStatus = new CampaignMemberStatus(
								CampaignId = camp.Id,
								Label = expected.Campaign_Member_Status__c,
								HasResponded = expected.HasResponded__c,
								SortOrder = sortOrder++
							);

							System.debug(newStatus);
							toInsert.add(newStatus);
						}
					}
				}
			}
		}

		if (!toUpdate.isEmpty()) {
			System.debug('We are updating ' + toUpdate.size() + ' Status records');
			update toUpdate;
		}
		if (!toInsert.isEmpty()) {
			System.debug('We are inserting ' + toInsert.size() + ' Status records');
			insert toInsert;
		}
		if (!toDelete.isEmpty()) {
			System.debug('We are deleting ' + toDelete.size() + ' Status records');
			delete toDelete;
		}
	}

	/**
	 * Make sure people aren't messing with our Protect_Campaign_Member_Statuses__c value.
	 */
	public void onBeforeUpdate(List<Campaign> newRecords, Map<Id, Campaign> oldRecordsMap) {
		if (bypass) {
			return;
		}

		for (Campaign camp : newRecords) {
			Campaign oldCamp = oldRecordsMap.get(camp.Id);
			if (camp.Protect_Campaign_Member_Statuses__c && (camp.Type != oldCamp.Type)) {
				System.debug('Someone tried to change the Type of a Campaign with Protect_Campaign_Member_Statuses__c');
				camp.addError('Type', 'Campaign has Protected Campaign Member Statuses. Don\'t change the type.');
			}

			if (camp.Protect_Campaign_Member_Statuses__c == true && !oldCamp.Protect_Campaign_Member_Statuses__c) {
				System.debug('Someone tried to re-enable Protected Campaign Member Statuses. We are not equipped to do that so we are preventing it');
				camp.addError('Protect_Campaign_Member_Statuses__c', 'Once disabled, cannot be re-enabled.');
			}
		}
	}
}