import Vue from 'vue';
import ProjectListItem from '~/vue_shared/components/projects_list/project_list_item.vue';
import ProjectAccess from '~/vue_shared/components/projects_list/project_access.vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';

// TODO: move to shallow mount / vue test utils ??

loadJSONFixtures('projects.json');
const projects = getJSONFixture('projects.json');
let vm;

const createComponent = (props, defaultComponent = ProjectListItem) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

describe('ProjectAccess', () => {
  const defaultAccess = 'Maintainer';
  beforeEach(() => {
    vm = createComponent(
      {
        isExploreProjectsTab: false,
        accessLevel: 30,
        humanAccess: defaultAccess,
      },
      ProjectAccess,
    );
  });

  afterEach(() => {
    vm.$destroy();
  });

  it(`renders if we are not on the explore tab and receive 'accessLevel' and 'humanAccess' props`, () => {
    expect(vm.showAccessLevel).toBe(true);
    expect(vm.$el.querySelector('.user-access-role').textContent).toBe(defaultAccess);
  });

  it(`does not render if 'accessLevel' is 0`, () => {
    vm = createComponent(
      {
        isExploreProjectsTab: false,
        accessLevel: 0,
        humanAccess: defaultAccess,
      },
      ProjectAccess,
    );

    expect(vm.showAccessLevel).toBe(false);
  });

  it(`does not render if we are on the explore project tab`, () => {
    vm = createComponent(
      {
        isExploreProjectsTab: true,
        accessLevel: 0,
        humanAccess: defaultAccess,
      },
      ProjectAccess,
    );

    expect(vm.showAccessLevel).toBe(false);
  });
});
