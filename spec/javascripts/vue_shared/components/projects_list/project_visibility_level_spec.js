import Vue from 'vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';
import { visibilityOptions } from '~/pages/projects/shared/permissions/constants';
import ProjectVisibilityLevel, {
  visibilityIconClass,
} from '~/vue_shared/components/projects_list/project_visibility_level.vue';

const createComponent = (props, defaultComponent = ProjectVisibilityLevel) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

function expectIconAndDescription(dom, { icon, description }) {
  expect(dom.$el.querySelector('i').getAttribute('class')).toContain(icon);
  expect(dom.$el.getAttribute('title')).toBe(description);
}

let vm = '';

describe('ProjectVisibilityLevel', () => {
  describe('visibilityIconClass', () => {
    it(`returns 'fa-lock' for level '${visibilityOptions.PRIVATE}'`, () => {
      expect(visibilityIconClass(visibilityOptions.PRIVATE)).toBe('fa-lock');
    });

    it(`returns 'fa-shield' for level '${visibilityOptions.INTERNAL}'`, () => {
      expect(visibilityIconClass(visibilityOptions.INTERNAL)).toBe('fa-shield');
    });

    it(`returns 'fa-globe' for level '${visibilityOptions.PUBLIC}'`, () => {
      expect(visibilityIconClass(visibilityOptions.PUBLIC)).toBe('fa-globe');
    });
  });

  describe('computed', () => {});

  describe('template', () => {
    describe('renders a lock', () => {
      const privateIcon = 'fa-lock';
      const privateDescription = 'This is private';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level -1`, () => {
        vm = createComponent({
          level: -1,
          description: privateDescription,
        });
        expectIconAndDescription(vm, { icon: privateIcon, description: privateDescription });
      });

      it(`with level 0`, () => {
        vm = createComponent({
          level: 0,
          description: privateDescription,
        });
        expectIconAndDescription(vm, { icon: privateIcon, description: privateDescription });
      });

      it(`with level 5`, () => {
        vm = createComponent({
          level: 5,
          description: privateDescription,
        });
        expectIconAndDescription(vm, { icon: privateIcon, description: privateDescription });
      });
    });

    describe('renders a shield', () => {
      const internalIcon = 'fa-shield';
      const internalDescription = 'This is internal';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level 10`, () => {
        vm = createComponent({
          level: 10,
          description: internalDescription,
        });
        expectIconAndDescription(vm, { icon: internalIcon, description: internalDescription });
      });

      it(`with level 15`, () => {
        vm = createComponent({
          level: 15,
          description: internalDescription,
        });
        expectIconAndDescription(vm, { icon: internalIcon, description: internalDescription });
      });
    });

    describe('renders a globe', () => {
      const publicIcon = 'fa-globe';
      const publicDescription = 'This is public 🚀⚡️';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level 20`, () => {
        vm = createComponent({
          level: 20,
          description: publicDescription,
        });
        expectIconAndDescription(vm, { icon: publicIcon, description: publicDescription });
      });

      it(`with level 25`, () => {
        vm = createComponent({
          level: 25,
          description: publicDescription,
        });
        expectIconAndDescription(vm, { icon: publicIcon, description: publicDescription });
      });
    });
  });
});
