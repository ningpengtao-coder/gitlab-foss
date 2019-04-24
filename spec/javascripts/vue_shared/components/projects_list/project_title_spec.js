import Vue from 'vue';
import ProjectListItem from '~/vue_shared/components/projects_list/project_list_item.vue';

import mountComponent from 'spec/helpers/vue_mount_component_helper';

// TODO: move to shallow mount / vue test utils ??

loadJSONFixtures('projects.json');
const projects = getJSONFixture('projects.json');
const ownedProject = projects[0];
const selectedProject = projects[1];

const createComponent = (props, defaultComponent = ProjectListItem) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

describe('ProjectTitle', () => {
  let vm;

  beforeEach(() => {
    vm = createComponent({ project: selectedProject });
  });

  afterEach(() => {
    vm.$destroy();
  });

  it(`renders the project namespace name if the 'owner' property is not available`, () => {
    expect(vm.$el.querySelector('.namespace-name').innerText).toEqual(
      `${selectedProject.namespace.name} /`,
    );
  });
});
