# Data Replication with AWS DataSync

### Overview

The AWS DataSync service allows you to setup a data replication process for backup and disaster recovery purposes. DataSync fully verifies data integrity by calculating each file's checksum. It also offers detailed logs of transfer errors such as locked or deleted files.

#### On-premise to AWS
![On-prem](/docs/images/on-prem-2-aws.png)

#### EFS to EFS or S3
![EFS](/docs/images/efs-2-efs-s3.png)

#### S3 to EFS
![S3](/docs/images/s3-2-efs.png)

[Next: Agent Server](/docs/source.md)
