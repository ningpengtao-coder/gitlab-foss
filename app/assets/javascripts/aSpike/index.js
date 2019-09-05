import Vue from 'vue';
import ASpike from './components/issues_analytics.vue';
import store from './stores';

export default () => {
  const el = document.querySelector('#js-releases-page');
  if (!el) return null;


  return new Vue({
    el,
    store,
    components: {
      ASpike,
    },
    render(createElement) {
      return createElement('a-spike', {
        props: {
          endpoint: 'some',
        },
      });
    },
  });
};
