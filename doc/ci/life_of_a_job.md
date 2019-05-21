# Life of a GitLab CI/CD job

This document serves to map out the life of a GitLab job in GitLab CI/CD.  While an entire pipeline is made up of stages and many jobs, tracking the most basic unit of a pipeline - the job - from start to finish can help you understand the timing involved and the various moving pieces required for a job to start.

The sequence of jobs in stages and the pipeline overall are covered in various other parts of this documentation.  For the purposes of these diagrams, you can think of it tracing the "first" job in a pipeline (the first job in the first stage) or a pipeline that has exactly one stage and exactly one job.

Generally the life of a job looks something like:

```mermaid
graph LR
    id1[Job Triggered] --> id2[Enqueued in Sidekiq] 
    id2 --> id3[Picked by a Runner] 
    id3 --> id4[Runner executes job] 
    id4 --> id5[PASSED or FAILED]
```

Within each step above, there can be many steps - some which will take more time than others depending on a number of situations. The queue time for jobs will vary by available runners, the time from picking a job to execution can rely on the executor chosen, and so on.  In later sections, we will detail the specifics of these steps to understand in more depth the life of a job. 

## Trigger to Job Picked

```mermaid
sequenceDiagram
    participant T as Trigger
    participant D as Database
    participant R as Rails
    participant N as n Runners
    participant U as Chosen Runner
    T->>R: Trigger 
    Note over T,R: Push, tag, schedule, etc.
    R-->R: Parse yml, create model
    R->>D: Insert pipeline and jobs
    loop Every 5 seconds 
        N->>+R: Any jobs?
    end
    R->>D: Gather list of jobs
    Note over R,D: Which jobs can this runner handle?
    D->>R: Final list of jobs
    Note over D,N: Shared runner: project based priority
    Note over D,N: Group/project: oldest takes precedence
    R->>U: Send chosen job to runner asking for a job
```

## Picked to Execution (dependant on executor)
### Executor: docker+machine

```mermaid
sequenceDiagram
    participant M as D+M Runner
    participant A as Cloud API
    participant R as Spawned Runner
    participant G as GitLab
    participant D as Docker Registry
    Note over M: Job chosen!
    M->>A: Request new machine
    A->>R: Spawn new machine
    loop Every 1 second
        M->>A: Machine ready?
    end
    A->>M: Machine is ready!
    M->>R: Install runner
    M->>R: Run job
    R->>D: Pull build image
    R->>G: Clone repository
    R->>G: Download cache
    Note over R: Execute job code
```
