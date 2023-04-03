# For use with developer edition or playground
echo "Pushing source..."
sf deploy metadata  --source-dir triggerhandler
sf deploy metadata  --source-dir force-app
sf deploy metadata  --source-dir unpackaged

echo "opening org..."
sf org open