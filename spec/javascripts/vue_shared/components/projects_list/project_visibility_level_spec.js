import Vue from 'vue';
import ProjectVisibilityLevel from '~/vue_shared/components/projects_list/project_visibility_level.vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';

const createComponent = (props, defaultComponent = ProjectVisibilityLevel) => {
  const Component = Vue.extend(defaultComponent);
  console.log('props', props);

  return mountComponent(Component, props);
};

function expectIconAndDescription(dom, { icon, description }) {
  // console.log('dom', dom);
  // console.log('dom.$el', dom.$el);
  expect(dom.$el.getAttribute('class')).toContain(icon);
  expect(dom.$el.querySelector('i').getAttribute('title')).toBe(description);
}

let vm = '';
let icon = '';
let description = '';

describe('ProjectVisibilityLevel', () => {
  describe('template', () => {
    fdescribe('renders a lock', () => {
      icon = 'fa-lock';
      description = 'This is private';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level -1`, () => {
        vm = createComponent({
          level: -1,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });

      it(`with level 0`, () => {
        vm = createComponent({
          level: 0,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });

      it(`with level 5`, () => {
        vm = createComponent({
          level: 5,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });
    });

    describe('renders a lock', () => {
      icon = 'fa-shield';
      description = 'This is internal';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level 10`, () => {
        vm = createComponent({
          level: 10,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });

      it(`with level 15`, () => {
        vm = createComponent({
          level: 15,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });
    });

    describe('renders a globe', () => {
      icon = 'fa-globe';
      description = 'This is public 🚀⚡️';

      beforeEach(() => {
        vm = null;
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`with level 20`, () => {
        vm = createComponent({
          level: 20,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });

      it(`with level 25`, () => {
        vm = createComponent({
          level: 25,
          description,
        });
        expectIconAndDescription(vm, { icon, description });
      });
    });
  });
});
