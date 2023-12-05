/**
 * @description This class handles the automation required on Adding/Editing Campaign records
 *
 * @author      Sercante LLC
 * @since       2022
 * @author      David Schach
 * @since       2022
 * @group       CampaignMemberStatus
 */
public without sharing class CampaignTriggerHandler extends TriggerHandler {
	/* private List<Campaign> newRecords;
	private List<Campaign> oldRecords;
	private Map<Id, Campaign> newRecordsMap;
	private Map<Id, Campaign> oldRecordsMap; */

	private CampaignMemberService cmService;

	/**
	 * @description Constructor for `CampaignMemberTriggerHandler`
	 * @param handlerName Pass in the name of the handler for better performance
	 */
	public CampaignTriggerHandler(String handlerName) {
		//super('CampaignTriggerHandler');
		/* this.newRecords = Trigger.new;
		this.oldRecords = Trigger.old;
		this.newRecordsMap = (Map<Id, Campaign>) Trigger.newMap;
		this.oldRecordsMap = (Map<Id, Campaign>) Trigger.oldMap; */
	}

	/**
	 * @description     Make sure people aren't trying to mess with the value of our Custom Field
	 *
	 */
	public override void beforeInsert() {
		new CMS_CampaignTriggerHandler().beforeInsert();
	}

	/**
	 * @description     Set up our new Campaign with the correct Statuses
	 *
	 */
	public override void afterInsert() {
		new CMS_CampaignTriggerHandler().afterInsert();
	}

	/**
	 * @description         Make sure people aren't messing with our `Protect_Campaign_Member_Statuses__c` value.
	 */
	public override void beforeUpdate() {
		new CMS_CampaignTriggerHandler().beforeUpdate();
	}
}