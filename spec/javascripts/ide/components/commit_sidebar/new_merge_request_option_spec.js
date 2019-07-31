import Vue from 'vue';
import store from '~/ide/stores';
import NewMergeRequestOption from '~/ide/components/commit_sidebar/new_merge_request_option.vue';
import { createComponentWithStore } from 'spec/helpers/vue_mount_component_helper';
import { projectData, branches } from 'spec/ide/mock_data';
import { resetStore } from 'spec/ide/helpers';

describe('create new MR checkbox', () => {
  let vm;
  const createComponent = ({ hasMR = false, currentBranchId = 'master' } = {}) => {
    const Component = Vue.extend(NewMergeRequestOption);

    vm = createComponentWithStore(Component, store);

    vm.$store.state.currentBranchId = currentBranchId;
    vm.$store.state.currentProjectId = 'abcproject';

    const proj = Object.assign({}, { ...projectData });
    proj.branches[currentBranchId] = branches.find(branch => branch.name === currentBranchId);

    Vue.set(vm.$store.state.projects, 'abcproject', proj);

    if (hasMR) {
      vm.$store.state.currentMergeRequestId = '1';
      vm.$store.state.projects[store.state.currentProjectId].mergeRequests[
        store.state.currentMergeRequestId
      ] = { foo: 'bar' };
    }

    return vm.$mount();
  };

  afterEach(() => {
    vm.$destroy();

    resetStore(vm.$store);
  });

  describe('for default branch', () => {
    it('is rendered if MR exists', () => {
      createComponent({
        hasMR: true,
        currentBranchId: 'master',
      });

      expect(vm.$el.textContent).not.toBe('');
    });

    it('is rendered if no MR exists', () => {
      createComponent({
        hasMR: false,
        currentBranchId: 'master',
      });

      expect(vm.$el.textContent).not.toBe('');
    });
  });

  describe('for protected branch', () => {
    describe('when user does not have the write access', () => {
      it('is rendered if MR exists', () => {
        createComponent({
          hasMR: true,
          currentBranchId: 'protected/no-access',
        });

        expect(vm.$el.textContent).not.toBe('');
      });

      it('is rendered if MR does not exists', () => {
        createComponent({
          hasMR: false,
          currentBranchId: 'protected/no-access',
        });

        expect(vm.$el.textContent).not.toBe('');
      });
    });

    describe('when user has the write access', () => {
      it('is hidden if MR exists', () => {
        createComponent({
          hasMR: true,
          currentBranchId: 'protected/access',
        });

        expect(vm.$el.textContent).toBe('');
      });

      it('is rendered if MR does not exists', () => {
        createComponent({
          hasMR: false,
          currentBranchId: 'protected/access',
        });

        expect(vm.$el.textContent).not.toBe('');
      });
    });
  });

  describe('for regular branch', () => {
    it('is hidden if MR exists', () => {
      createComponent({
        hasMR: true,
        currentBranchId: 'regular',
      });

      expect(vm.$el.textContent).toBe('');
    });

    it('is rendered if no MR exists', () => {
      createComponent({
        hasMR: false,
        currentBranchId: 'regular',
      });

      expect(vm.$el.textContent).not.toBe('');
    });
  });

  it('dispatches toggleShouldCreateMR when clicking checkbox', () => {
    createComponent();
    const el = vm.$el.querySelector('input[type="checkbox"]');
    spyOn(vm.$store, 'dispatch');
    el.dispatchEvent(new Event('change'));

    expect(vm.$store.dispatch.calls.allArgs()).toEqual(
      jasmine.arrayContaining([['commit/toggleShouldCreateMR', jasmine.any(Object)]]),
    );
  });
});
