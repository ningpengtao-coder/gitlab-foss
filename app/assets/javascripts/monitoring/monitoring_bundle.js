import Vue from 'vue';
import store from './stores';
import { parseBoolean } from '~/lib/utils/common_utils';
import Dashboard from 'ee_else_ce/monitoring/components/dashboard.vue';

export default (props = {}) => {
  const el = document.getElementById('prometheus-graphs');

  if (el && el.dataset) {
    // eslint-disable-next-line no-new
    new Vue({
      el,
      render(createElement) {
        return createElement(Dashboard, {
          props: {
            ...el.dataset,
            hasMetrics: parseBoolean(el.dataset.hasMetrics),
            showTimeWindowDropdown: gon.features.metricsTimeWindow,
            usePrometheusEndpoint: gon.features.environmentMetricsUsePrometheusEndpoint,
            ...props,
          },
        });
      },
      store,
    });
  }
};
