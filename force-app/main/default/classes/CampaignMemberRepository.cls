/**
 * @description Utility class to return statuses by Campaign Type
 *
 * @author      Sercante LLC
 * @since       2022
 * @group       CampaignMemberStatus
 */
public without sharing virtual class CampaignMemberRepository {
	/**
	 * @description Return `Campaign Type Member Status` CMDT records by Campaign Type
	 *
	 * @return      `Map<String, List<Campaign_Type_Member_Status__mdt>>`
	 */
	public virtual Map<String, List<Campaign_Type_Member_Status__mdt>> getGroupedProtectedStatuses() {
		List<Campaign_Type_Member_Status__mdt> protectedStatuses = [
			SELECT Label, Campaign_Type__c, Campaign_Member_Status__c, IsDefault__c, HasResponded__c
			FROM Campaign_Type_Member_Status__mdt
			ORDER BY Campaign_Type__c, IsDefault__c DESC, HasResponded__c DESC
		];

		Map<String, List<Campaign_Type_Member_Status__mdt>> groupedProtectedStatuses = new Map<String, List<Campaign_Type_Member_Status__mdt>>();
		for (Campaign_Type_Member_Status__mdt status : protectedStatuses) {
			if (!groupedProtectedStatuses.containsKey(status.Campaign_Type__c)) {
				groupedProtectedStatuses.put(status.Campaign_Type__c, new List<Campaign_Type_Member_Status__mdt>());
			}
			groupedProtectedStatuses.get(status.Campaign_Type__c).add(status);
		}
		return groupedProtectedStatuses;
	}
}