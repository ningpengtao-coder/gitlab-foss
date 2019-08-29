import Vue from 'vue';
import ContributorsGraphs from './components/contributors.vue';
import store from './stores';

export default () => {
  const el = document.querySelector('.js-contributors-graph');

  if (!el) return null;

  return new Vue({
    el,
    store,
    components: {
      ContributorsGraphs,
    },

    render(createElement) {
      return createElement('contributors-graphs', {
        props: {
          endpoint: el.dataset.projectGraphPath,
        },
      });
    },
  });
};
