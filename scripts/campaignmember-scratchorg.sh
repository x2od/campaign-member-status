#!/bin/bash

echo "Cleaning previous scratch org..."
sf org delete scratch --no-prompt --target-org CampaignMemberStatus

#echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Creating new scratch org"
sf org create scratch --definition-file config/project-scratch-def.json --alias CampaignMemberStatus --no-namespace --set-default --duration-days 10 --track-source --wait 20

# For use with namespaced scratch org in package development process
echo "Deploying metadata"
sf project deploy start
sf project deploy start --source-dir unpackaged

sf org assign permset --name Campaign_Type_Member_Status_Admin --target-org CampaignMemberStatus

sf apex run test --test-level RunLocalTests --output-dir testresults --result-format human --code-coverage --wait 20

echo "opening org"
sf org open

echo "Org is set up"