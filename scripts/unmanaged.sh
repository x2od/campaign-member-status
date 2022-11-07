# UNMANAGED for use with developer edition or playground

echo "Clearing namespace"
sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

# For use with developer edition or playground
echo "Pushing source..."
sfdx force:source:deploy -p force-app

echo "opening org..."
sfdx force:org:open