// Using https://gitlab.com/gitlab-org/gitlab-ce/-/jobs/278912562

export default {
  id: 278912562,
  status: 'failed',
  complete: true,
  state:
    'eyJvZmZzZXQiOjQ5NzU5NCwibl9vcGVuX3RhZ3MiOjAsImZnX2NvbG9yIjpudWxsLCJiZ19jb2xvciI6bnVsbCwic3R5bGVfbWFzayI6MCwic2VjdGlvbnMiOltdLCJsaW5lbm9faW5fc2VjdGlvbiI6MTJ9',
  append: false,
  truncated: false,
  offset: 0,
  size: 497594,
  total: 497594,

  lines: [
    {
      offset: 1000,
      content: [{ text: __('Running with gitlab-runner 12.1.0 (de7731dd)') }],
    },
    {
      offset: 1001,
      content: [{ text: __(' on docker-auto-scale-com 8a6210b8') }],
    },
    {
      offset: 1002,
      content: [
        {
          text:
            'Using Docker executor with image dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33',
        },
      ],
      sections: ['prepare-executor'],
      section_header: true,
    },
    {
      offset: 1003,
      content: [{ text: __('Starting service postgres:9.6.14 ...') }],
      sections: ['prepare-executor'],
    },
    {
      offset: 1004,
      content: [{ text: __('Pulling docker image postgres:9.6.14 ...') }],
      sections: ['prepare-executor'],
    },
    {
      offset: 1005,
      content: [
        {
          text: `Using docker image sha256:ac400042d32f8e146477ae5b3528f1e4232fc8e83b2fd9fe0cbe08900e45bae1 for
      postgres:9.6.14 ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      offset: 1006,
      content: [{ text: 'Starting service redis:alpine ...' }],
      sections: ['prepare-executor'],
    },
    {
      offset: 1007,
      content: [{ text: 'Pulling docker image redis:alpine ...' }],
      sections: ['prepare-executor'],
    },
    {
      offset: 1008,
      content: [
        {
          text: `Using docker image sha256:ed7d2ff5a6232b43bdc89a2220ed989f532c3794422aa2a86823b8bc62e71447 for
      redis:alpine ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      offset: 1009,
      content: [{ text: __('Waiting for services to be up and running...') }],
      sections: ['prepare-executor'],
    },
    {
      offset: 1010,
      content: [
        {
          text: `Pulling docker image
      dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33
      ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      offset: 1011,
      content: [
        {
          text: `Using docker image sha256:f5b71ccc7a53408ea88959433baf23f7d716bb431d0475a4f3d9ba213d7841c1 for
      dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33
      ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      offset: 1012,
      content: [],
      sections: ['prepare-executor'],
      section_footer: true,
      section_duration: '10:00'
    },
    {
      offset: 1013,
      content: [
        {
          text: __(`Running on runner-8a6210b8-project-13083-concurrent-0 via
      runner-8a6210b8-gsrm-1566561403-37c881a0...`),
        },
      ],
      sections: ['prepare-script'],
      section_header: true,
    },

    {
      offset: 1014,
      content: [
        { text: __('Fetching changes with git depth set to 20..'), style: 'term-fg-l-green term-bold' },
      ],
      sections: ['get-sources'],
      section_header: true,
    },
    {
      offset: 1015,
      content: [
        {
          text: __('Reinitialized existing Git repository in /builds/gitlab-org/gitlab-ce/.git/ '),
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1016,
      content: [
        {
          text: 'From https://gitlab.com/gitlab-org/gitlab-ce',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1017,
      content: [
        {
          text: ' * [new branch] 66454-create-feature-flag -&gt; origin/66454-create-feature-flag',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1018,
      content: [
        {
          text: __('Checking out 061606b4 as 66454-create-feature-flag...'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1019,
      content: [
        {
          text: 'Removing .gitlab_shell_secret',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1020,
      content: [
        {
          text: 'Removing .gitlab_workhorse_secret',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1021,
      content: [
        {
          text: 'Removing config/database_geo.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1022,
      content: [
        {
          text: 'Removing config/gitlab.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1023,
      content: [
        {
          text: 'Removing config/redis.cache.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1024,
      content: [
        {
          text: __('Skipping Git submodules setup'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['get-sources'],
    },
    {
      offset: 1025,
      content: [],
      sections: ['get-sources'],
    },
    {
      offset: 1026,
      content: [],
      sections: ['get-sources'],
      section_footer: true,
      section_duration: '30:00'
    },
    {
      offset: 1027,
      content: [
        {
          text: __('Checking cache for debian-stretch-ruby-2.6.3-node-12.x-3...'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['restore-cache'],
      section_header: true,
    },
    {
      offset: 1028,
      content: [],
      sections: ['restore-cache'],
    },
    {
      offset: 1029,
      content: [
        {
          text:
            'Downloading cache.zip from https://storage.googleapis.com/gitlab-com-runners-cache/project/13083/debian-stretch-ruby-2.6.3-node-12.x-3',
        },
      ],
      sections: ['restore-cache'],
    },
    {
      offset: 1030,
      content: [],
      sections: ['restore-cache'],
    },
    {
      offset: 1031,
      content: [
        {
          text: __('Successfully extracted cache'),
          style: 'term-fg-l-green term-bold ',
        },
      ],
      sections: ['restore-cache'],
    },
    {
      offset: 1032,
      content: [],
      sections: ['restore-cache'],
      section_footer: true,
      section_duration: '00:10'
    },
    {
      offset: 1033,
      content: [
        {
          text: __('Downloading artifacts for compile-assets pull-cache (278912482)...'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
      section_header: true,
    },
    {
      offset: 1034,
      content: [],
      sections: ['download-artifacts'],
    },
    {
      offset: 1035,
      content: [
        {
          text: __('Downloading artifacts from coordinator... ok '),
          style: 'term-fg-l-green term-bold',
        },
        {
          text: __(' id'),
        },
        {
          text: '=278912482 responseStatus',
        },
        {
          text: __('=200 OK token'),
        },
        {
          text: __('=DUNW1asp'),
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1036,
      content: [
        {
          text: __('Downloading artifacts for setup-test-env (278912484)...'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1037,
      content: [
        {
          text: 'Downloading artifacts from coordinator... ok  id=278912484 responseStatus=200 OK token=gdMnE5zT',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1038,
      content: [
        {
          text: `WARNING: tmp/tests/gitlab-shell/.gitlab_shell_secret: chmod
          tmp/tests/gitlab-shell/.gitlab_shell_secret: no such file or directory (suppressing
          repeats)`,
          style: 'term-fg-yellow',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1039,
      content: [
        {
          text: __('Downloading artifacts for retrieve-tests-metadata (278912485)...'),
          style: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1040,
      content: [
        {
          text: 'Downloading artifacts from coordinator... ok id=278912485 responseStatus=200 OK token=rCtxUhsy',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      offset: 1041,
      content: [],
      sections: ['download-artifacts'],
      section_footer: true,
      section_duration: '01:00:58'
    },
    {
      offset: 1042,
      content: [
        {
          text: __('Downloading artifacts from coordinator... ok '),
        },
        {
          text: __(' id'),
          style: 'term-fg-l-green term-bold',
        },
        {
          text: '=278912484 responseStatus=200 OK token=gdMnE5zT',
        },
      ],
      sections: ['download-artifacts'],
    },
  ],
};
