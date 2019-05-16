import { shallowMount } from '@vue/test-utils';
import { GlLineChart } from '@gitlab/ui/dist/charts';
import LineChart from '~/monitoring/components/charts/line.vue';
import { createStore } from '~/monitoring/stores';
import * as types from '~/monitoring/stores/mutation_types';
import MonitoringMock from '../mock_data';

describe('Line Chart component', () => {
  let lineChart;

  beforeEach(() => {
    const store = createStore();
    store.commit(types.RECEIVE_METRICS_DATA_SUCCESS, MonitoringMock.data);

    lineChart = shallowMount(LineChart, {
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
    lineChart.destroy();
  });

  describe('wrapped components', () => {
    describe('GitLab UI line chart', () => {
      let glLineChart;

      beforeEach(() => {
        glLineChart = lineChart.find(GlLineChart);
      });

      it('is a Vue instance', () => {
        expect(glLineChart.isVueInstance()).toBe(true);
      });
    });
  });
});
