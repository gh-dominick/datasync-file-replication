# Data Replication with AWS DataSync

### Infrastructure Components -- Destination Filesystem

The file transfer destination can be within AWS or on-premise storage solution. It can either be an NFS/SMB shared, an EFS volume, or an S3 bucket. Depending on the destination type, you will need to ensure DataSync is supported within the region.

- In a cross-region replication of 2 EFS volumes setup, at least one endpoint needs to configured as an NFS share. AWS recommends NFS (source) to EFS (destination).

[Next: VPC Endpoint](/docs/vpc_endpoint.md)
