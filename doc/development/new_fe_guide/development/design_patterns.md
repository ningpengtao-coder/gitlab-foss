# Design patterns

## Realtime features

We use polling to simulate realtime features at GitLab. Here is the general architecture setup.

- Backend will include `Poll-Interval` in the response header. This will dictate the interval at which to poll from the frontend.
- Use [poll.js][poll-js] to manage the polling intervals.
- Use [Visibility.js][visibility-js] to manage polling on active browser tabs

Polling should be disabled when the following responses are received from the backend:
- `Poll-Interval: -1`
- HTTP status of `4XX` or `5XX`

## Configuring new scripts to run on specific pages

> TODO: Add Content

## Vue features

> TODO: Add Content

### Folder Structure

All Vue features should follow a similar folder structure as the one listed below.

```
new_feature
├── components
│   └── new_feature.vue
│   └── ...
├── store
│  └── new_feature_store.js
├── service
│  └── new_feature_service.js
└── index.js
```

#### Index file

This index file should include the root Vue instance of the new feature. The Store and Service should be imported, initialized and provided as props to the main component.

#### Vuex

We use Vuex for managing data.

[poll-js]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/app/assets/javascripts/lib/utils/poll.js
[visibility-js]: https://github.com/ai/visibilityjs
