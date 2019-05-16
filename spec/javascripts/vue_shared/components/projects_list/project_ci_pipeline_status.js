import Vue from 'vue';
import ProjectCiPipelineStatus from '~/vue_shared/components/projects_list/project_ci_pipeline_status.vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';

loadJSONFixtures('projects.json');
let vm;

const createComponent = (props, defaultComponent = ProjectCiPipelineStatus) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

describe('ProjectCiPipelineStatus', () => {
  beforeEach(() => {
    vm = createComponent({}, ProjectCiPipelineStatus);
  });

  afterEach(() => {
    vm.$destroy();
  });

  it('renders  without a path specified', () => {});

  // TODO: project list item should check the path is derived correctly
  it('renders  with a path specified', () => {});
});
