<script>
import Api from '~/api';
import ProjectListItem from './project_list_item.vue';

const fetchProjects = (q = '') => Api.projects(q, { simple: false, order_by: 'last_activity_at' });

/**
 * Renders a list of projects
 */
export const PROJECT_TABS = {
  default: '',
  explore: 'EXPLORE',
  starred: 'STARRED',
};

const basename = url =>
  url
    .split('/')
    .filter(i => i.length)
    .reverse()[0];

const currentTab = () => {
  const tab = basename(window.location.pathname);
  return PROJECT_TABS[tab] || PROJECT_TABS.default;
};

// TODO: not sure if theres a better way
const isExploreProjectsTab = () => {
  return currentTab() === PROJECT_TABS.EXPLORE;
};

export default {
  components: {
    ProjectListItem,
  },
  props: {
    projects: {
      type: Array,
      default: [],
    },
    size: 48, // size of what?
    hideArchived: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    isExploreProjectsTab,
  },
};
</script>
<template>
  <div>
    <!-- TODO: loading spinner -->
    <!-- TODO: empty project state -->
    <ul class="projects-list">
      <template v-for="project in projects">
        <project-list-item
          :key="project.id"
          :project="project"
          :is-explore="isExploreProjectsTab"
          :hide-archived="hideArchived"
        />
      </template>
    </ul>
  </div>
</template>
