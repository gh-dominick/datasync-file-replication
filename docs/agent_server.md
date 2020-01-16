# Data Replication with AWS DataSync
### Agent Server

The agent server acts as a central point that connects the various filesystems and initiates the data transfer.

Resources
  - EC2 Fleet - cost savings
    - Must be running on at least **m5.2xlarge** instance size (Jan. 2020). This is to allow sufficient memory buffer to copy larger files.
    - Uses specific AWS DataSync AMI
  - Launch Template - use with EC2 instances
    - Includes UserData
  - IAM Role & Profile
    - Requires explicit permission to interact with EFS and DataSync

[Next: Source Filesystem](/docs/source.md)
