import Vue from 'vue';
import ProjectTitle from '~/vue_shared/components/projects_list/project_title.vue';

import mountComponent from 'spec/helpers/vue_mount_component_helper';

// TODO: move to shallow mount / vue test utils ??

loadJSONFixtures('projects.json');
const selectedProject = getJSONFixture('projects.json')[1];
console.log('selectedProject', selectedProject);
const {
  namespace: { name: namespaceName },
  name,
  path_with_namespace: pathWithNamespace,
} = selectedProject;

const createComponent = props => {
  const Component = Vue.extend(ProjectTitle);

  return mountComponent(Component, props);
};

describe('ProjectTitle', () => {
  let vm;

  beforeEach(() => {
    vm = createComponent({
      namespace: namespaceName,
      name,
      pathWithNamespace,
    });
  });

  afterEach(() => {
    vm.$destroy();
  });

  describe('computed', () => {
    describe('namespaceName', () => {
      it('should add a backslash after the namespace', () => {
        expect(vm.namespaceName).toBe(`${namespaceName} /`);
      });
    });

    describe('path', () => {
      it('should be a relative url', () => {
        expect(vm.path).toBe(`/${pathWithNamespace}`);
      });
    });
  });

  describe('template', () => {
    it(`renders the project name`, () => {
      expect(vm.$el.querySelector('.project-name').innerText).toEqual(name);
    });

    it(`renders the project namespace`, () => {
      expect(vm.$el.querySelector('.namespace-name').innerText).toEqual(`${namespaceName} /`);
    });

    it(`renders the full project title correctly`, () => {
      expect(vm.$el.querySelector('.project-full-name').innerText).toEqual(
        `${namespaceName} / ${name}`,
      );
    });

    it(`renders a link to the project path`, () => {
      expect(vm.$el.querySelector('h2 a').getAttribute('href')).toBe(`/${pathWithNamespace}`);
    });
  });
});
