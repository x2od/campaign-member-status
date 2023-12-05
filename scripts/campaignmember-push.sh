# UNMANAGED for use with developer edition or playground

#echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

# For use with developer edition or playground
echo "Pushing source..."
sf project deploy start 

echo "opening org..."
sf org open