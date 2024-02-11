# Maintainer
Shobhit Kumar Saurabh  
Email : shobjit.savrabn@gmail.com
# Introduction 
This is automation solution for Mediawiki deploy from CI/CD tool and setup the UI for end user to start using Mediawiki.

# Tools Used
Below tools/Platform/Technologies were used to implement this solution
1. Azure Repo from Azure Devops
2. Microsoft Azure Cloud.
3. RHEL 7 Linux OS loaded Azure VM.
4. Azure Pipeline in yaml.
5. Powershell.
6. Shell Scripting.
7. Azure Bicep for writting InfraStructure as Code (IAC).
8. Apache Server httpd24
9. mysql
10.php

# How to use this solution
Please follow below steps one by one

1. Download the code from public guthub repositiory as zip ands extract to you local folder anywhere.
2. Create a ADO project in azure devops url is https://dev.azure.com/{orgname]}
3  Ensure you have valid azure subscription where at least a VM can be provisioned.
4. Create a Service connection in Azure devops with name "rgshobhit" , if you will choose another name please modify the yaml pipeline to use the updated service connection name.
5. Create a pipeline (yaml based) by using exsisting file called "azure-pipelines.yml"
6. Modify the pool-name as per your Azure Devops Project.
7. run the pipeline , wait for it success.
8. Open portal.azure.com and go to you VM. copy the DNS name.
9. Open browser of your choice and browse url http://<DNS Name of VM> 
10. You should see Mediawiki home page. 
11. Proceed as instructred in home page.

# Assumptions
1. I Installed Mediawiki 1.35
2. I did not use Kubernetes as I do not have quota enabled in my personal subscription of Azure to create AKS cluster and If I request that it will take 2-3 business days.
3. I used Azure Bicep to provision IAC.
4. I use Azure in stead of AWS and GCP.

# Further Work Recommendation.

1. Implementiang brnaching strategy and brnaching policy for Ado Project.
2. Adding stages and environment for YAML pipeline and assign proper approver and reviewer for each environemnt like DEV/SIT/TEST/PRD etc.
3. Improve Error handling in script.sh.
4. The whole soluiton can be improved for upgrading the Mediawiki version.
