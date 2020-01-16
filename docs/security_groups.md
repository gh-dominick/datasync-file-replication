# Data Replication with AWS DataSync

### Infrastructure Components -- Security Groups

The security group implementation will need to include the following criteria:

* DataySync agent security group
  - Requires port 443 outgoing to activation; once activated, this port can be closed.
* EFS client security group
  - Requires port 2049/TCP incoming from the DataSync agent
* VPC endpoint security group
  - Requires port 443 incoming and outgoing for activation

[Next](/docs/agent.md)
