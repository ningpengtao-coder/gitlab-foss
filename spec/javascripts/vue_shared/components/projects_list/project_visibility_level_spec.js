import Vue from 'vue';
import ProjectVisibilityLevel from '~/vue_shared/components/projects_list/project_visibility_level.vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';

// TODO: move to shallow mount / vue test utils ??

loadJSONFixtures('projects.json');
// const projects = getJSONFixture('projects.json');
let vm;

const createComponent = (props, defaultComponent = ProjectVisibilityLevel) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

describe('ProjectVisibilityLevel', () => {
  const defaultAccess = 'Maintainer';
  beforeEach(() => {
    vm = createComponent(
      {
        isExploreProjectsTab: false,
        accessLevel: 30,
        humanAccess: defaultAccess,
      },
      ProjectVisibilityLevel,
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
      ProjectVisibilityLevel,
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
      ProjectVisibilityLevel,
    );

    expect(vm.showAccessLevel).toBe(false);
  });
});
