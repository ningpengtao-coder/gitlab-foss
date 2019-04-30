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

describe('ProjectListItem', () => {
  let vm;

  beforeEach(() => {
    // const pathname = '/dashboard/projects';
    // spyOn(window.location, 'pathname', 'get').and.returnValue(pathname);
    vm = createComponent({ project: selectedProject });
  });

  afterEach(() => {
    vm.$destroy();
  });

  // TODO: Possible BE changes needed for missing fields:
  // - Populate namespace with correct data:
  //  * no group set => should default to the user's name
  //  * subgroups??
  //  * pipeline-status
  //  * last_activity_at (api) != last_activity_date (haml)
  //  * open_merge_requests_count
  //  * open_issues_count
  //  * project visibility
  // - description field: should show the last commit as a description if available otherwise just the project description

  // TODO: additional cases
  // - project.archived?

  describe('data', () => {
    it('returns default data props', () => {
      const projectFields = [
        'id',
        'name',
        'description',
        'path',
        'path_with_namespace',
        'created_at',
        'tag_list',
        'star_count',
        'forks_count',
        'open_issues_count',
        'last_activity_at',
      ];
      projectFields.forEach(field => {
        expect(vm.project[field]).toBe(selectedProject[field]);
      });

      const namespaceFields = ['id', 'name', 'path', 'kind', 'full_path', 'parent_id'];
      namespaceFields.forEach(field => {
        expect(vm.project.namespace[field]).toBe(selectedProject.namespace[field]);
      });
    });
  });

  describe('template', () => {
    describe('User owns project', () => {
      beforeEach(() => {
        vm = createComponent({ project: ownedProject });
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`renders the owner name for the namespace`, () => {
        expect(vm.$el.querySelector('.namespace-name').innerText).toEqual(
          `${ownedProject.owner.name} /`,
        );
      });

      it(`renders the project name`, () => {
        expect(vm.$el.querySelector('.project-name').innerText).toEqual(`${ownedProject.name}`);
      });
    });

    describe('User does not own the project', () => {
      beforeEach(() => {
        vm = createComponent({ project: selectedProject });
      });

      afterEach(() => {
        vm.$destroy();
      });

      it(`renders the project name for the namespace`, () => {
        expect(vm.$el.querySelector('.namespace-name').innerText).toEqual(
          `${selectedProject.namespace.name} /`,
        );
      });

      it(`renders the project name`, () => {
        expect(vm.$el.querySelector('.project-name').innerText).toEqual(`${selectedProject.name}`);
      });
    });

    fdescribe('Viewing explore projects', () => {
      beforeEach(() => {
        vm = createComponent({ project: selectedProject, isExploreTab: true });
      });

      afterEach(() => {
        vm.$destroy();
      });

      it('does not render project access', () => {});
    });

    describe('Project meta', () => {
      it('renders the correct project name', () => {
        expect(vm.$el.querySelector('.project-name').innerText).toBe(selectedProject.name);
      });

      it('renders the project avatar as a link', () => {
        expect(vm.$el.querySelector('.avatar-container a').href).toContain(selectedProject.path);
      });

      it('renders the correct project description', () => {
        expect(vm.$el.querySelector('.description').innerText).toBe(selectedProject.description);
        expect(vm.$el.querySelector('.description').classList).not.toContain('no-description');
      });

      it('does not render the description if it is missing', () => {
        ['', null].forEach(description => {
          const noDescVm = createComponent({ project: { ...selectedProject, description } });

          expect(noDescVm.$el.querySelector('.description')).toBeNull();
          expect(noDescVm.$el.classList).toContain('no-description');
        });
      });
    });
  });
});
