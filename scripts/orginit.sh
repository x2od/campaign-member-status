#!/bin/bash

echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Cleaning previous scratch org..."
sfdx force:org:delete -p -u CampaignMembers

echo "Creating new scratch org"
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias CampaignMembers --nonamespace --setdefaultusername --noancestors --durationdays 14

echo "Pushing metadata"
sfdx force:source:deploy -p triggerhandler --tracksource
sfdx force:source:push

echo "Opening org"
sfdx force:org:open

echo "Org is set up"