import Vue from 'vue';
import store from '~/ide/stores';
import commitActions from '~/ide/components/commit_sidebar/actions.vue';
import consts from '~/ide/stores/modules/commit/constants';
import { createComponentWithStore } from 'spec/helpers/vue_mount_component_helper';
import { resetStore } from 'spec/ide/helpers';
import { projectData, branches } from 'spec/ide/mock_data';

describe('IDE commit sidebar actions', () => {
  let vm;
  let updateCommitActionSpy;

  const createComponent = ({ hasMR = false, currentBranchId = 'master' } = {}) => {
    const Component = Vue.extend(commitActions);

    vm = createComponentWithStore(Component, store);

    vm.$store.state.currentBranchId = currentBranchId;
    vm.$store.state.currentProjectId = 'abcproject';

    const proj = { ...projectData };
    proj.branches[currentBranchId] = branches.find(branch => branch.name === currentBranchId);

    Vue.set(vm.$store.state.projects, 'abcproject', proj);

    if (hasMR) {
      vm.$store.state.currentMergeRequestId = '1';
      vm.$store.state.projects[store.state.currentProjectId].mergeRequests[
        store.state.currentMergeRequestId
      ] = { foo: 'bar' };
    }

    vm.$mount();

    return vm;
  };

  afterEach(() => {
    vm.$destroy();

    resetStore(vm.$store);
  });

  it('renders 2 groups', () => {
    createComponent();

    expect(vm.$el.querySelectorAll('input[type="radio"]').length).toBe(2);
  });

  it('renders current branch text', () => {
    createComponent();

    expect(vm.$el.textContent).toContain('Commit to master branch');
  });

  it('hides merge request option when project merge requests are disabled', done => {
    createComponent({ mergeRequestsEnabled: false });

    vm.$nextTick(() => {
      expect(vm.$el.querySelectorAll('input[type="radio"]').length).toBe(2);
      expect(vm.$el.textContent).not.toContain('Create a new branch and merge request');

      done();
    });
  });

  describe('commitToCurrentBranchText', () => {
    it('escapes current branch', () => {
      const injectedSrc = '<img src="x" />';
      createComponent({ currentBranchId: injectedSrc });

      expect(vm.commitToCurrentBranchText).not.toContain(injectedSrc);
    });
  });

  describe('updateSelectedCommitAction', () => {
    it('does not return anything if currentBranch does not exist', () => {
      updateCommitActionSpy = spyOn(vm, 'updateCommitAction');
      vm.updateSelectedCommitAction();

      expect(updateCommitActionSpy).not.toHaveBeenCalled();
    });

    describe('default branch', () => {
      it('dispatches correct action for default branch', () => {
        createComponent({
          currentBranchId: 'master',
        });
        updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

        vm.updateSelectedCommitAction();

        expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_NEW_BRANCH);
      });
    });

    describe('protected branch', () => {
      describe('with write access', () => {
        it('dispatches correct action when MR exists', () => {
          createComponent({
            hasMR: true,
            currentBranchId: 'protected/access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_CURRENT_BRANCH);
        });

        it('dispatches correct action when MR does not exists', () => {
          createComponent({
            hasMR: false,
            currentBranchId: 'protected/access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_CURRENT_BRANCH);
        });
      });

      describe('without write access', () => {
        it('dispatches correct action when MR exists', () => {
          createComponent({
            hasMR: true,
            currentBranchId: 'protected/no-access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_NEW_BRANCH);
        });

        it('dispatches correct action when MR does not exists', () => {
          createComponent({
            hasMR: false,
            currentBranchId: 'protected/no-access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_NEW_BRANCH);
        });
      });
    });

    describe('regular branch', () => {
      describe('with write access', () => {
        it('dispatches correct action when MR exists', () => {
          createComponent({
            hasMR: true,
            currentBranchId: 'regular',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_CURRENT_BRANCH);
        });

        it('dispatches correct action when MR does not exists', () => {
          createComponent({
            hasMR: false,
            currentBranchId: 'regular',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_CURRENT_BRANCH);
        });
      });

      describe('without write access', () => {
        it('dispatches correct action when MR exists', () => {
          createComponent({
            hasMR: true,
            currentBranchId: 'regular/no-access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_NEW_BRANCH);
        });

        it('dispatches correct action when MR does not exists', () => {
          createComponent({
            hasMR: false,
            currentBranchId: 'regular/no-access',
          });
          updateCommitActionSpy = spyOn(vm, 'updateCommitAction');

          vm.updateSelectedCommitAction();

          expect(updateCommitActionSpy).toHaveBeenCalledWith(consts.COMMIT_TO_NEW_BRANCH);
        });
      });
    });
  });
});
