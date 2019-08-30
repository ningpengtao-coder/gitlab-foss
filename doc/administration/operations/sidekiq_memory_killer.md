# Sidekiq MemoryKiller

The GitLab Rails application code suffers from memory leaks. For web requests
this problem is made manageable using
[unicorn-worker-killer](https://github.com/kzk/unicorn-worker-killer) which
restarts Unicorn worker processes in between requests when needed. The Sidekiq
MemoryKiller applies the same approach to the Sidekiq processes used by GitLab
to process background jobs.

Unlike unicorn-worker-killer, which is enabled by default for all GitLab
installations since GitLab 6.4, the Sidekiq MemoryKiller is enabled by default
_only_ for Omnibus packages. The reason for this is that the MemoryKiller
relies on Runit to restart Sidekiq after a memory-induced shutdown and GitLab
installations from source do not all use Runit or an equivalent.

With the default settings, the MemoryKiller will cause a Sidekiq restart no
more often than once every 15 minutes, with the restart causing about one
minute of delay for incoming background jobs.

Some background jobs rely on long-running external processes. To ensure these
are cleanly terminated when Sidekiq is restarted, each Sidekiq process should be
run as a process group leader (e.g., using `chpst -P`). If using Omnibus or the
`bin/background_jobs` script with `runit` installed, this is handled for you.

## Configuring the MemoryKiller

The MemoryKiller is controlled using environment variables.

- `SIDEKIQ_DAEMON_MEMORY_KILLER`: defaults to 0. When set to 1, the MemoryKiller
  works in daemon mode. Otherwise, the MemoryKiller works in legacy mode.

  In legacy mode, the MemoryKiller check the Sidekiq process RSS after each job.
  In daemon mode, the MemoryKiller check the Sidekiq process RSS every 3 seconds.

- `SIDEKIQ_MEMORY_KILLER_MAX_RSS`: if this variable is set, and its value is greater
  than 0, the MemoryKiller is enabled. Otherwise the MemoryKiller is disabled.

  In legacy mode, SIDEKIQ_MEMORY_KILLER_MAX_RSS acts as hard limit. If the Sidekiq
  process RSS (expressed in kilobytes) exceeds SIDEKIQ_MEMORY_KILLER_MAX_RSS,
  a delayed shutdown is triggered.
  In daemon mode, SIDEKIQ_MEMORY_KILLER_MAX_RSS acts as soft limit. The RSS
  of the Sidekiq process is allowed to exceed SIDEKIQ_MEMORY_KILLER_MAX_RSS within
  limited time.

  The default value for Omnibus packages is set
  [in the omnibus-gitlab
  repository](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-cookbooks/gitlab/attributes/default.rb).

- `SIDEKIQ_MEMORY_KILLER_HARD_LIMIT_RSS`: only for daemon mode. If the Sidekiq
  process RSS (expressed in kilobytes) exceeds SIDEKIQ_MEMORY_KILLER_HARD_LIMIT_RSS,
  a delayed shutdown is triggered.

- `SIDEKIQ_MEMORY_KILLER_GRACE_BALLOON_TIME`: only for daemon mode. Defaults to
  900 seconds (15 minutes). As long as the RSS of the Sidekiq process is under
  SIDEKIQ_MEMORY_KILLER_HARD_LIMIT_RSS, it can exceed SIDEKIQ_MEMORY_KILLER_MAX_RSS
  for 15 minutes. After that, a delayed shutdown is triggered.

- `SIDEKIQ_MEMORY_KILLER_CHECK_INTERVAL`: only for daemon mode. Defaults to
   3 seconds. Check Sidekiq process RSS every 3 seconds. If Sidekiq process RSS
   is out of range, a delayed shutdown is triggered.

- `SIDEKIQ_MEMORY_KILLER_GRACE_TIME`: defaults to 900 seconds (15 minutes). When
  a shutdown is triggered, the Sidekiq process will keep working for up to
  another 15 minutes.

  In legacy mode, Sidekiq process continue accepting new jobs during grace time.
  In daemon mode, Sidekiq process will stop accepting new jobs during grace time.

- `SIDEKIQ_MEMORY_KILLER_SHUTDOWN_WAIT`: defaults to 30 seconds. After graceful
  shutdown period(either timeout or all jobs finished), the MemoryKiller tells
  Sidekiq to shutdown. If the shutdown did not finish within 30 seconds, the
  MemoryKiller will terminate Sidekiq forcefully with SIGKILL, and an external
  supervision mechanism (e.g. Runit) must restart Sidekiq.
