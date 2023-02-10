#!/bin/bash

echo "Cleaning previous scratch org..."
sf org delete scratch --no-prompt --target-org CampaignMemberStatus

#echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Creating new scratch org"
#sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias CampaignMemberStatus --nonamespace --setdefaultusername --noancestors --durationdays 14 -w 20
sf env create scratch --definition-file config/project-scratch-def.json --alias CampaignMemberStatus --no-namespace --set-default --duration-days 3 --track-source --wait 20

# For use with namespaced scratch org in package development process
echo "Deploying metadata"
#sf deploy metadata --source-dir triggerhandler
#sf deploy metadata --source-dir force-app
#sf deploy metadata --source-dir unpackaged

sfdx force:source:push

sf org assign permset --name Campaign_Type_Member_Status_Admin --target-org CampaignMemberStatus

sfdx force:apex:test:run -l RunLocalTests -r human -w 20

echo "opening org"
sfdx force:org:open
#sf env open

echo "Org is set up"