"# toolbox" 
Setting up on a different computer
When creating a VS project, make sure that the folders match

working folder is toolBox/factoryData
Steps:
git init
git remote add origin https://github.com/gcarloscodeview/toolbox.git
git branch --set-upstream-to=origin/master master
git pull
git reset --hard origin/master  
git pull
git branch --set-upstream-to=origin/master master

# to pull a new remote branch
git reset --hard HEAD
git fetch --all
git reset --hard origin/your_branch

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3i000002n8tBAAQ

OBSTACLE:

Lookup fields with filters may not work:
DESCRIPTION:  If you have a lookup field with a filter and you create a record for the lookup, inserting the record may fail if the filter criteria fails.  Moreover, there doesn't seem to be an elegant way to determine the filter criteria for the filter.  There is an idea on this: 
https://success.salesforce.com/ideaView?id=08730000000aSCfAAM
Schema class does not show filter criteria

Our only hope on this one is to read the meta data into Apex and read the filter criteria from there.  I need to investigate this.


