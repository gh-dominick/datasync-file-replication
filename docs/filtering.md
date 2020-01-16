# Data Replication with AWS DataSync

### DataSync Components -- Task Filtering

The filtering options allows you to include and/or exclude specified file types, patterns, and directories within the transfer process.

- When using the AWS CLI, use the | (pipe) as the delimiter.

- Currently, include filters support the * character only as the rightmost character in a pattern. For example, /documents*|/code* is supported but *.txt is not supported. (Jan. 2020)
