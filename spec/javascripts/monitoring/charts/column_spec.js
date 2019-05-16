import { shallowMount } from '@vue/test-utils';
import { GlColumnChart } from '@gitlab/ui/dist/charts';
import ColumnChart from '~/monitoring/components/charts/column.vue';
import { createStore } from '~/monitoring/stores';
import * as types from '~/monitoring/stores/mutation_types';
import MonitoringMock from '../mock_data';

describe('Column component', () => {
  let columnChart;

  beforeEach(() => {
    const store = createStore();
    store.commit(types.RECEIVE_METRICS_DATA_SUCCESS, MonitoringMock.data);

    columnChart = shallowMount(ColumnChart, {
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
    columnChart.destroy();
  });

  describe('wrapped components', () => {
    describe('GitLab UI column chart', () => {
      let glColumnChart;

      beforeEach(() => {
        glColumnChart = columnChart.find(GlColumnChart);
      });

      it('is a Vue instance', () => {
        expect(glColumnChart.isVueInstance()).toBe(true);
      });
    });
  });
});
