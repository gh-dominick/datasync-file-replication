# Data Replication with AWS DataSync

### DataSync Components -- Agent

The agent acts a intermediary between the source and destination storage systems to read and write data.

* Console login to the agent is not needed for basic functionality. However, you can use SSM Session Manager for troubleshooting purposes.

* When a sync job is triggered, the agent creates and attaches 4 network interfaces to itself for additional throughput.

[Next: Locations](/docs/locations.md)
