##READ ME##

A copy of the required External Provider module and sitemap are contained 
within this folder for your convenience

From your terminal navigate to this folder and run:

./create-env.sh [DX-DirName] [Profile] 
'where [DX-DirName] can be whatever you want and [Profile] is the Profile ID of your tomcat'

The Graphql-core module tied to this env will be in the directory [CurrentDir]/gql-[Dx-DirName]
the first time you run the above process it will take ~10-15 minutes since it will have to get 
fresh DX repo and install it.
If you already have a DX module (on branch feature-BACKLOG-8990) already built and ready to be deployed
on your computer, copy/paste it into this folder and run the same process except [DX-DirName]
should be the same as the name of your DX module. This will cut down the time to for this process to
around 1-2 minutes.


# DX-GQL-Env-Resources
# DX-GQL-Env-Resources
