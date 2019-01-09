#!/usr/bin/env zsh

# Build and deploy DX and GraphQL for SDL Development and Testing

# What needs to be done:
#  1. Get dxm-dev-private repo from github
#  2. Do checkout-jahia.sh in dxm-dev-private then in ./jahia-ee-root and ./jahia-root switch to feature-BACKLOG-8990 branch
#  3. Build/Deploy DX to a profile
#  4. Navigate to the /DX-TOMCAT-PATH/digital-fatory-data/modules/
#  5. Remove default graphql*.jar files
#  6. Copy site-map-2.0.6-SNAPSHOT.jar into /DX-TOMCAT-PATH/digital-fatory-data/modules/
#  7. Get graphql-core repo from github then switch to custom-api branch
#  8. Deploy graphql-core branch using profile
#  9. Remove old external provider and deploy new one
# 10. Start DX

#---find port to tomcat with specified profile
grep -o -A 10 -e "<id>$2</id>" ~/.m2/settings.xml | while read -r line; do
    if [[ $line =~ '<jahia\.test\.url>[^<].*/' ]]; then
                tcPort=${MATCH[34, 37]};
                break;
    fi
done
echo $tcPort;

#---kill all processes on this port
kill -9 $(lsof -t -i:$tcPort);

#find and store path to main directory
mainDir=`pwd`;
echo "Found path to main directory " $mainDir;

#check if graphql-core according to specified dx directory already exists and remove it
if [ -d $mainDir/gql-$1 ]; then
	rm -Rf $mainDir/gql-$1
fi

#find path to target tomcat with specified profile
grep -o -A 10 -e "<id>$2</id>" ~/.m2/settings.xml | while read -r line; do
    if [[ $line =~ '<jahia\.deploy\.targetServerDirectory>/[^<].*/' ]]; then
                (( patternEnd = $MEND - 2))
                tcPath=${MATCH[37, $patternEnd]};
                break;
    fi
done
echo "Found tomcat path inside maven settings " $tcPath;

#clean tomcat directory
rm -Rf $tcPath/digital-factory-*; 
rm -Rf $tcPath/webapps/*; 
rm -Rf $tcPath/logs/*; 
rm -Rf $tcPath/work/*;

if [ ! -d $mainDir/$1 ]; then
	#get dx repo
	git clone git@github.com:Jahia/dxm-dev-private.git $1;
	cd $mainDir/$1;
	."/checkout-jahia.sh"; 

	#change to feature-BACKLOG-8990 branch
	cd $mainDir/$1/jahia-root;git checkout feature-BACKLOG-8990;
	cd $mainDir/$1/jahia-ee-root;git checkout feature-BACKLOG-8990;
	cd $mainDir/$1/jahia-pack-root;git checkout feature-BACKLOG-8990;
	cd $mainDir/$1;
	."/clean-ee.sh";."/install-ee.sh";
fi

#build and deploy to profile
cd $mainDir/$1;
./deploy-ee-with-tests.sh $2;
mvn -P $2 jahia:configure;

#remove the default GraphQL modules
rm -Rf $modulesPath/graphql*.jar;

#copy sitemap into TOMCAT_PATH/digital-factory-data/modules
modulesPath="$tcPath/digital-factory-data/modules/";
cp $mainDir/sitemap-2.0.6-SNAPSHOT.jar $modulesPath;

#get graphql-core repo and switch to custom-api branch
cd $mainDir;
git clone https://github.com/Jahia/graphql-core.git gql-$1;

#navigate to graphql-core directory and switch to custom-api branch
cd $mainDir/gql-$1; git checkout custom-api;

#update repo
git stash;git pull;

#deploy repo to profile
mvn -P $2 -D skipTests clean install jahia:deploy;

#remove old external provider and deploy new one
rm -Rf $modulesPath/external-provider*3.1.5.jar;
cd $mainDir/external-provider;
mvn -P $2 clean install jahia:deploy;

#start-up dx server
$tcPath/bin/catalina.sh run;
