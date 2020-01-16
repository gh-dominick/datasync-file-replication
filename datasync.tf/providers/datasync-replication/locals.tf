locals {
  datasync-agent-userdata = <<USERDATA
#cloud-config
repo_update: true
repo_upgrade: all

write_files:
- content: |
    #!/bin/bash

    function getActivationKey
    {
        local sourceLocationRegion=$1
        local privateLinkEndpoint=$2
        curl --silent "localhost:8080/?activationRegion=${!sourceLocationRegion}&gatewayType=SYNC&endpointType=PRIVATE_LINK&privateLinkEndpoint=${!privateLinkEndpoint}&no_redirect"
    }

    function createAgent
    {
        local agentIp=$1
        local sourceLocationRegion=$2
        local stackName=$3
        local activationKey=$4
        local accountId=$5
        local sourceSubnetId=$6
        local vpcEndpointId=$7
        aws datasync create-agent --activation-key ${!activationKey} --agent-name ${!agentIp} --vpc-endpoint-id ${!vpcEndpointId} --subnet-arns "arn:aws:ec2:${var.region}:${!accountId}:subnet/${!sourceSubnetId}" --security-group-arns "arn:aws:ec2:${!sourceLocationRegion}:${!accountId}:security-group/${!sourceSecurityGroupId}" --region ${!sourceLocationRegion} --tags Key=StackName,Value=${!stackName} --output text
    }

    function createSourceDataSyncLocationEfs
    {
        local sourceEfsFilesystemId=$1
        local sourceSubdirectory=$2
        local sourceSubnetId=$3
        local sourceSecurityGroupId=$4
        local agentSecurityGroupId=$5
        local sourceLocationRegion=$6
        local accountId=$7
        local stackName=$8
        aws datasync create-location-efs --efs-filesystem-arn "arn:aws:elasticfilesystem:${var.region}:${!accountId}:file-system/${!sourceEfsFilesystemId}" --subdirectory ${!sourceSubdirectory} --ec2-config "SubnetArn=arn:aws:ec2:${var.region}:${!accountId}:subnet/${!sourceSubnetId},SecurityGroupArns=arn:aws:ec2:${!sourceLocationRegion}:${!accountId}:security-group/${!sourceSecurityGroupId},arn:aws:ec2:${!sourceLocationRegion}:${!accountId}:security-group/${!agentSecurityGroupId}"  --region ${var.region} --tags Key=StackName,Value=${!stackName} --output text
    }

    function createDataSyncLocationEfs
    {
        local destinationEfsIp=$1
        local destinationSubdirectory=$2
        local agentArns=$3
        local sourceLocationRegion=$4
        local stackName=$5
        aws datasync create-location-nfs --server-hostname ${!destinationEfsIp} --subdirectory ${!destinationSubdirectory} --on-prem-config "AgentArns=${!agentArns}" --region ${!sourceLocationRegion} --tags Key=StackName,Value=${!stackName} --output text
    }

    function createDataSyncTask
    {
        local sourceLocationArn=$1
        local destinationLocationArn=$2
        local agentIp=$3
        local stackName=$4
        aws datasync create-task --source-location-arn ${!sourceLocationArn} --destination-location-arn ${!destinationLocationArn} --options VerifyMode=NONE,OverwriteMode=ALWAYS,Atime=BEST_EFFORT,Mtime=PRESERVE,PreserveDeletedFiles=REMOVE,PreserveDevices=PRESERVE,PosixPermissions=PRESERVE,TaskQueueing=ENABLED --name "Stack:${!stackName} Agent:${!agentIp}" --region ${!sourceLocationRegion} --tags Key=StackName,Value=${!stackName} --output text
    }

    function startDataSyncTaskExecution
    {
        local taskArn=$1
        aws datasync start-task-execution --task-arn ${!taskArn} --region ${var.region} --output text
    }
  path: /tmp/functions_datasync.sh
  permissions: 0777

- content: |
    #!/bin/bash

    source /tmp/functions_datasync.sh
    echo -e "$(date -u +%FT%T.%3N)\tDataSync":" Execute\tRunning task execution function startDataSyncTaskExecution()" >> /tmp/datasync_task_execution.log 2>&1
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to run task execution function" >> /tmp/datasync_task_execution.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tTask executed ${!executionId}" >> /tmp/datasync_task_execution.log 2>&1
  path: /tmp/start_datasync_task_execution.sh
  permissions: 0777

- content: |
    #!/bin/bash
    agentIp=${!1}
    sourceEfsFilesystemId=${SourceEfsFilesystemId}
    sourceSubdirectory=${SourceSubdirectory}
    sourceSubnetId=${SourceSubnetId}
    sourceSecurityGroupId=${EfsClientSecurityGroup}
    destinationEfsIp=${DestinationEfsIp}
    destinationSubdirectory=${DestinationSubdirectory}
    accountId=${AWS::AccountId}
    stackName=${AWS::StackName}
    privateLinkEndpoint=${PrivateLinkEndpointIp}
    agentSecurityGroupId=${AgentSecurityGroup}
    vpcEndpointId=${VpcEndpoint}

    if [ $# -lt 1 ]; then
      echo "Invalid # of arguments. Requires: Agent IP"
      exit 1
    fi

    # source datasync functions
    source /tmp/functions_datasync.sh
    # start create delete datasync resources script
    echo -e "aws cloudformation delete-stack --stack-name ${!stackName} --region ${var.region}" >> /tmp/delete_datasync_resources.sh

    # get activation key
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tSelf-activating and generating activation key on agent on ${!agentIp}" >> /tmp/datasync_setup.log 2>&1
    activationKey=$(getActivationKey ${var.region} ${!privateLinkEndpoint})
    if [ "$?" != "0" ]
    then
       echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to self-activate or generate activation key on ${!agentIp}" >> /tmp/datasync_setup.log 2>&1
       exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tKey generated: ${!activationKey}" >> /tmp/datasync_setup.log 2>&1

    # activate agent
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tCreating agent in ${var.region} for ${!agentIp} using activation key ${!activationKey}" >> /tmp/datasync_setup.log 2>&1
    agentArns=$(createAgent ${!agentIp} ${var.region} ${!stackName} ${!activationKey} ${!accountId} ${!sourceSubnetId} ${!vpcEndpointId})
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to create agent in ${var.region} for ${!agentIp} using activation key ${!activationKey}" >> /tmp/datasync_setup.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tAgent created: ${!agentArns}" >> /tmp/datasync_setup.log 2>&1
    sed -i "1iaws datasync delete-agent --agent-arn ${!agentArns} --region ${var.region}" /tmp/delete_datasync_resources.sh

    # source datasync functions
    source /tmp/functions_datasync.sh

    # start create delete datasync resources script
    echo -e "aws cloudformation delete-stack --stack-name ${!stackName} --region ${AWS::Region}" >> /tmp/delete_datasync_resources.sh
    # create source location (efs)
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tCreating source location(efs) for ${!sourceEfsFilesystemId}" >> /tmp/datasync_setup.log 2>&1
    sourceLocationArn=$(createSourceDataSyncLocationEfs ${!sourceEfsFilesystemId} ${!sourceSubdirectory} ${!sourceSubnetId} ${!sourceSecurityGroupId} ${!agentSecurityGroupId} ${var.region} ${!accountId} ${!stackName})
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to create source location for ${!sourceEfsFilesystemId}" >> /tmp/datasync_setup.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tSource location(efs) created: ${!sourceLocationArn}" >> /tmp/datasync_setup.log 2>&1
    sed -i "1iaws datasync delete-location --location-arn ${!sourceLocationArn} --region ${var.region}" /tmp/delete_datasync_resources.sh

    # create destination location (efs)
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tCreating destination location(efs) for ${!destinationEfsIp}" >> /tmp/datasync_setup.log 2>&1
    destinationLocationArn=$(createDataSyncLocationEfs ${!destinationEfsIp} ${!destinationSubdirectory} ${!agentArns} ${var.region} ${!stackName})
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to create destination location for ${!destinationEfsIp}" >> /tmp/datasync_setup.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tDestination location(efs) created: ${!destinationLocationArn}" >> /tmp/datasync_setup.log 2>&1
    sed -i "1iaws datasync delete-location --location-arn ${!destinationLocationArn} --region ${var.region}" /tmp/delete_datasync_resources.sh

    # create task
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tCreating task between ${!sourceEfsFilesystemId}${!sourceSubdirectory} and ${!destinationEfsIp}${!destinationSubdirectory}" >> /tmp/datasync_setup.log 2>&1
    taskArn=$(createDataSyncTask ${!sourceLocationArn} ${!destinationLocationArn} ${var.region} ${!agentIp} ${!stackName})
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to create task between ${!sourceEfsFilesystemId}${!sourceSubdirectory} and ${!destinationEfsIp}${!destinationSubdirectory}" >> /tmp/datasync_setup.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tTask created: ${!taskArn}" >> /tmp/datasync_setup.log 2>&1
    sed -i "1iaws datasync delete-task --task-arn ${!taskArn} --region ${var.region}" /tmp/delete_datasync_resources.sh

    # update datasync task execution script with task arn
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Execute\tUpdating /tmp/start_datasync_task_execution.sh with task arn" >> /tmp/datasync_setup.log 2>&1
    sed -i -e "5i executionId=\$\(startDataSyncTaskExecution ${!taskArn} ${var.region}\)" /tmp/start_datasync_task_execution.sh
    if [ "$?" != "0" ]
    then
        echo -e "$(date -u +%FT%T.%3N)\tDataSync: Error\t\tFailed to update /tmp/start_datasync_task_execution.sh" >> /tmp/datasync_setup.log 2>&1
        exit 1
    fi
    echo -e "$(date -u +%FT%T.%3N)\tDataSync: Success\tDatasync task execution script /tmp/start_datasync_task_execution.sh updated with task arn" >> /tmp/datasync_setup.log 2>&1

  path: /tmp/create_datasync_resources.sh
  permissions: 0777

packages:
- python34

runcmd:
- curl -O https://bootstrap.pypa.io/get-pip.py
- python3 get-pip.py --user
- export PATH=~/.local/bin:$PATH
- pip3 install awscli --upgrade --user
- source /tmp/functions_datasync.sh
- agentIp=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
- sleep 60
- echo /tmp/create_datasync_resources.sh ${!agentIp}
- echo -e "$(date -u +%FT%T.%3N)\tDataSync":" Execute\tCreating datasync resources" >> /tmp/datasync_setup.log 2>&1
- /tmp/create_datasync_resources.sh ${!agentIp}
- if [ "$?" != "0" ]; then echo -e "$(date -u +%FT%T.%3N)\tDataSync":" Error\t\tFailed to create datasync resources" >> /tmp/datasync_setup.log 2>&1; else echo -e "$(date -u +%FT%T.%3N)\tDataSync":" Success\tCreated datasync resources" >> /tmp/datasync_setup.log 2>&1; fi
}
