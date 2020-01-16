# Data Replication with AWS DataSync

### Infrastructure Components -- VPC Endpoint

The DataSync VPC Endpoints allows communication between resources that are configured with direct public access. The EFS volume and DataSync agent can both be deployed within private subnets. When the agent is activated, it initiates a private link with the VPC endpoint.

* When utilizing a VPC endpoint for replication across two VPCs (cross-region), make sure that both VPCs have been peered.

[Next](/docs/security_groups.md)
