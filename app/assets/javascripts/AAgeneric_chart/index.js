import Vue from 'vue';
import GenericChart from './components/generic_chart.vue';
import store from './stores';

export default () => {
  const el = document.querySelector('#js-releases-page');
  if (!el) return null;


  return new Vue({
    el,
    store,
    components: {
      GenericChart,
    },
    render(createElement) {
      return createElement('generic-chart', {
        props: {
          endpoint: 'some',
        },
      });
    },
  });
};
