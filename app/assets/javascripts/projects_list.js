import Vue from 'vue';
import VueProjectsList from '~/vue_shared/components/projects_list/index.vue';
import FilterableList from './filterable_list';

/**
 * Makes search request for projects when user types a value in the search input.
 * Updates the html content of the page with the received one.
 */

function fetchData(mountPoint) {
  const { projects = [] } = mountPoint.dataset;
  console.log('fetchData::projects', JSON.parse(projects));
  return JSON.parse(projects);
}

export function initProjectsList() {
  const mountPoint = document.querySelector('.vjs-projects-list');
  return new Vue({
    el: mountPoint,
    render: createElement =>
      createElement(VueProjectsList, {
        props: { projects: fetchData(mountPoint) },
      }),
  });
}
export default class ProjectsList {
  constructor() {
    const form = document.querySelector('form#project-filter-form');
    const filter = document.querySelector('.js-projects-list-filter');
    const holder = document.querySelector('.js-projects-list-holder');

    if (form && filter && holder) {
      const list = new FilterableList(form, filter, holder);
      list.initSearch();
    }

    if (window.gon.features.vueProjectsList) initProjectsList();
  }
}
