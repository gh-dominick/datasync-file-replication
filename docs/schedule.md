# Data Replication with AWS DataSync

### DataSync Components -- Task Scheduling

Recently release! You can schedule when the task runs within the task options.

- Schedule expressions be in **cron** or **rate**.

```bash
ScheduleExpression="cron(00 * * * ? *)"
```

```bash
ScheduleExpression="rate(60 minutes)"
```

#### Scheduling console
![Scheduling](/docs/images/task-schedule.png)

[Next: Task Filtering](/docs/filtering.md)
