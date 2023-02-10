# UNMANAGED for use with developer edition or playground

echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

# For use with developer edition or playground
echo "Pushing source..."
sfdx force:source:deploy -p triggerhandler --tracksource
sfdx force:source:deploy -p mktg-campaignmemberstatus
sfdx force:source:deploy -p unpackaged --tracksource

echo "opening org..."
sfdx force:org:open