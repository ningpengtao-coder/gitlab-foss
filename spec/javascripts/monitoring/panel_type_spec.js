import { shallowMount } from '@vue/test-utils';
import PanelType from '~/monitoring/components/panel_type.vue';
import EmptyChart from '~/monitoring/components/charts/empty_chart.vue';
import TimeSeriesChart from '~/monitoring/components/charts/time_series.vue';
import AnomalyChart from '~/monitoring/components/charts/anomaly.vue';
import ChartDropdown from '~/monitoring/components/chart_dropdown.vue';
import { graphDataPrometheusQueryRange, graphDataPrometheusQueryAnomalyResult } from './mock_data';
import { createStore } from '~/monitoring/stores';

describe('Panel Type component', () => {
  let store;
  let panelType;
  const dashboardWidth = 100;

  describe('When no graphData is available', () => {
    let glEmptyChart;
    // Deep clone object before modifying
    const graphDataNoResult = JSON.parse(JSON.stringify(graphDataPrometheusQueryRange));
    graphDataNoResult.queries[0].result = [];

    beforeEach(() => {
      panelType = shallowMount(PanelType, {
        propsData: {
          clipboardText: 'dashboard_link',
          dashboardWidth,
          graphData: graphDataNoResult,
        },
      });
    });

    afterEach(() => {
      panelType.destroy();
    });

    describe('Empty Chart component', () => {
      beforeEach(() => {
        glEmptyChart = panelType.find(EmptyChart);
      });

      it('is a Vue instance', () => {
        expect(glEmptyChart.isVueInstance()).toBe(true);
      });

      it('it receives a graph title', () => {
        const props = glEmptyChart.props();

        expect(props.graphTitle).toBe(panelType.vm.graphData.title);
      });
    });
  });

  describe('when Graph data is available', () => {
    const exampleText = 'example_text';

    beforeEach(() => {
      store = createStore();
      panelType = type =>
        shallowMount(PanelType, {
          propsData: {
            clipboardText: exampleText,
            dashboardWidth,
            graphData: { ...graphDataPrometheusQueryAnomalyResult, type },
          },
          store,
        });
    });

    describe('Time Series Chart panel type', () => {
      it('is rendered', () => {
        const areaPanelType = panelType('area');

        expect(areaPanelType.find(TimeSeriesChart).isVueInstance()).toBe(true);
        expect(areaPanelType.find(TimeSeriesChart).exists()).toBe(true);
      });

      it('sets clipboard text on the dropdown', () => {
        const dropdown = () => panelType('area').find(ChartDropdown);

        expect(dropdown().props('chartLink')).toEqual(exampleText);
      });
    });

    describe('Anomaly Chart panel type', () => {
      it('is rendered', () => {
        const anomalyChart = panelType('anomaly');

        expect(anomalyChart.find(AnomalyChart).isVueInstance()).toBe(true);
        expect(anomalyChart.find(AnomalyChart).exists()).toBe(true);
      });

      it('sets clipboard text on the dropdown', () => {
        const dropdown = () => panelType('anomaly').find(ChartDropdown);

        expect(dropdown().props('chartLink')).toEqual(exampleText);
      });
    });
  });
});
