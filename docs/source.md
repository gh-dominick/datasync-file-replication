# Data Replication with AWS DataSync

### Infrastructure Components -- Source Filesystem

The source filesystem can either be an on-premise NFS share server, an EFS volume, or an S3 bucket.

* If the source is an on-premise NFS/SMB share or an EFS volume, the DataSync agent needs to be deployed within the source environment.

* The DataSync agent for an on-premise share can be deployed on a VMware ESXi hypervisor via a downloaded DataSync .ova image.

* If the source is an S3 bucket, the agent will need to be deployed within the destination environment.

[Next](/docs/destination.md)
