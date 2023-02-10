#!/bin/bash

echo "Cleaning previous scratch org..."
sfdx force:org:delete -p -u CampaignMemberStatus

#echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Creating new scratch org"
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias CampaignMemberStatus --nonamespace --setdefaultusername --noancestors --durationdays 14 -w 20 --targetdevhubusername=SpotOnProd
#sf env create scratch --target-dev-hub=SpotOnProd --definition-file config/project-scratch-def.json --alias CampaignMemberStatus --set-default --duration-days 14 -w 20 --track-source

# For use with namespaced scratch org in package development process
echo "Deploying metadata"
#sfdx force:source:deploy -p triggerhandler --tracksource
#sfdx force:source:deploy -p mktg-campaignmemberstatus --tracksource
#sfdx force:source:deploy -p unpackaged --tracksource

#sf deploy metadata --source-dir triggerhandler
#sf deploy metadata --source-dir mktg-campaignmemberstatus
#sf deploy metadata --source-dir unpackaged

sfdx force:source:push

sfdx force:apex:test:run -l RunLocalTests

sfdx force:user:permset:assign -n Campaign_Type_Member_Status_Admin

echo "opening org"
sfdx force:org:open
#sf env open

echo "Org is set up"