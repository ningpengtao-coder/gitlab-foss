import Vue from 'vue';
import ProjectListItem from '~/vue_shared/components/projects_list/project_list_item.vue';
import mountComponent from 'spec/helpers/vue_mount_component_helper';

// TODO: move to shallow mount / vue test utils ??

loadJSONFixtures('projects.json');
const projects = getJSONFixture('projects.json');
const selectedProject = projects[1];

const createComponent = (props, defaultComponent = ProjectListItem) => {
  const Component = Vue.extend(defaultComponent);

  return mountComponent(Component, props);
};

describe('ProjectCounts', () => {
  let vm;
  const path = selectedProject.path_with_namespace;
  const urls = {
    forks: `/${path}/forks`,
    issues: `/${path}/issues`,
    'merge-requests': `/${path}/merge_requests`,
  };

  beforeEach(() => {
    vm = createComponent({ project: selectedProject });
  });

  afterEach(() => {
    vm.$destroy();
  });

  it('renders a warning if the project is archived', () => {
    const archivedVm = createComponent({ project: { ...selectedProject, archived: true } });

    expect(archivedVm.$el.querySelector('.icon-container .badge').textContent).toBe('archived');

    expect(archivedVm.$el.querySelector('.icon-container .badge').classList).toContain(
      'badge-warning',
    );
  });

  it('renders the correct urls for forks, issues and merge requests', () => {
    Object.entries(urls).forEach(([key, url]) => {
      expect(vm.$el.querySelector(`.icon-container .${key}`).href).toContain(url);
    });
  });

  it('renders the correct star count', () => {
    const stars = Number(vm.$el.querySelector('.stars').textContent);

    expect(stars).toEqual(selectedProject.star_count);
  });

  it('renders the correct fork count', () => {
    const forks = Number(vm.$el.querySelector('.forks').textContent);

    expect(forks).toEqual(selectedProject.forks_count);
  });

  it('renders the correct issue count', () => {
    const issues = Number(vm.$el.querySelector('.issues').textContent);

    expect(issues).toEqual(selectedProject.open_issues_count);
  });

  it('renders the correct merge request count', () => {
    const mergeRequests = Number(vm.$el.querySelector('.merge-requests').textContent);

    expect(mergeRequests).toEqual(selectedProject.merge_requests_count);
  });
});
