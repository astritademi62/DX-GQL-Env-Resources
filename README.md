
# DX-GQL-Env-Resources Readme

## Build and deploy DX and GraphQL for SDL Development and Testing

A copy of the required External Provider module and sitemap are contained 
within this folder for your convenience

Extract external-provider into main dir.

From this directory and run command:
       
    chmod 755 create-env.sh //only needs to be run once to make script executable
    
    ./create-env.sh [DX-DirName] [Profile] 
    
'where [DX-DirName] can be whatever you want and [Profile] is the Profile ID of your tomcat'

------------------------
The first time you run the above process it will take ~10-15 minutes since it will have to get 
fresh DX repo and install it.
Every subsequent time you want to rebuild your ENV just run the same command as above but make
sure [DX-DirName] is the same as before.
The Graphql-core module will be in the directory [CurrentDir]/gql-[Dx-DirName]

------------------------
If you already have a DX module (on branch feature-BACKLOG-8990) already built and ready to be deployed
on your computer, copy/paste it into this folder and run the same process except [DX-DirName]
should be the same as the name of your DX module. This will cut down the time for this process to
around 1-2 minutes.
