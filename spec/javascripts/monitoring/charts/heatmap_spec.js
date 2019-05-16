import { shallowMount } from '@vue/test-utils';
import { GlHeatmap } from '@gitlab/ui/dist/charts';
import HeatmapChart from '~/monitoring/components/charts/heatmap.vue';
import { createStore } from '~/monitoring/stores';
import * as types from '~/monitoring/stores/mutation_types';
import MonitoringMock from '../mock_data';

describe('Heatmap Chart component', () => {
  let heatmapChart;

  beforeEach(() => {
    const store = createStore();
    store.commit(types.RECEIVE_METRICS_DATA_SUCCESS, MonitoringMock.data);

    heatmapChart = shallowMount(HeatmapChart, {
      propsData: {
        graphData: {
          x_label: 'time',
          y_label: 'usage',
          queries: [{ result: {} }], // TODO: Update mock data
        },
        containerWidth: 100,
      },
    });
  });

  afterEach(() => {
    heatmapChart.destroy();
  });

  describe('wrapped components', () => {
    describe('GitLab UI heatmap chart', () => {
      let glHeatmapChart;

      beforeEach(() => {
        glHeatmapChart = heatmapChart.find(GlHeatmap);
      });

      it('is a Vue instance', () => {
        expect(glHeatmapChart.isVueInstance()).toBe(true);
      });
    });
  });
});
