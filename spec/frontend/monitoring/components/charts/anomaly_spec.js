import Anomaly from '~/monitoring/components/charts/anomaly.vue';

import { GlLineChart } from '@gitlab/ui/dist/charts';
import { shallowMount } from '@vue/test-utils';
import { getSvgIconPathContent } from '~/lib/utils/icon_utils';
import { graphTypes } from '~/monitoring/constants';
import {
  anomalyDeploymentData,
  mockProjectPath,
  anomalyMockGraphData,
  anomalyMockGraphDataWithAppearance,
  anomalyMockResultValues,
} from '../../mock_data';
import { TEST_HOST } from 'helpers/test_constants';

const blue = '#0000FF';
const blueAsRgb = '0,0,255';
const mockWidgets = 'mockWidgets';
const projectPath = `${TEST_HOST}${mockProjectPath}`;

jest.mock('~/lib/utils/icon_utils'); // mock getSvgIconPathContent

const makeAnomalyGraphData = (datasetName, template = anomalyMockGraphData) => {
  const queries = anomalyMockResultValues[datasetName].map((values, index) => ({
    ...template.queries[index],
    result: [
      {
        metrics: {},
        values,
      },
    ],
  }));
  return { ...template, queries };
};

const makeAnomalyChart = props =>
  shallowMount(Anomaly, {
    propsData: { containerWidth: 100, ...props },
    slots: {
      default: mockWidgets,
    },
    sync: false,
  });

describe('Anomaly chart component', () => {
  describe('general functions', () => {
    let anomalyChart;
    let anomalyGraphData;

    beforeEach(() => {
      anomalyGraphData = makeAnomalyGraphData('noAnomaly');

      getSvgIconPathContent.mockReturnValue(Promise.resolve('PATH'));

      anomalyChart = makeAnomalyChart({
        graphData: anomalyGraphData,
        deploymentData: anomalyDeploymentData,
        projectPath,
        containerWidth: 0,
        showBorder: false,
        singleEmbed: false,
        thresholds: [],
      });
    });

    it('renders chart title', () => {
      expect(anomalyChart.find('.js-graph-title').text()).toBe(anomalyGraphData.title);
    });

    it('contains graph widgets from slot', () => {
      expect(anomalyChart.find('.js-graph-widgets').text()).toBe(mockWidgets);
    });
  });

  describe('computed', () => {
    const graphData = makeAnomalyGraphData('noAnomaly');
    let anomalyChart;
    beforeEach(() => {
      anomalyChart = makeAnomalyChart({
        graphData,
        containerWidth: 100,
      });
    });

    describe('yOffset', () => {
      it('calculates no offset for positive values', () => {
        expect(anomalyChart.vm.yOffset === 0).toEqual(true);
      });

      it('calculates offset for a negative boundary', () => {
        const expectedOffset = 4;
        anomalyChart.setProps({
          graphData: makeAnomalyGraphData('negativeBoundary'),
        });
        expect(anomalyChart.vm.yOffset).toEqual(expectedOffset);
      });
    });
  });

  describe('wrapped gl-line chart', () => {
    describe('general functions', () => {
      const graphData = makeAnomalyGraphData('noAnomaly');
      let glChart;
      let wrapper;
      let props;

      beforeEach(() => {
        wrapper = makeAnomalyChart({
          graphData,
          deploymentData: anomalyDeploymentData,
        });
        wrapper.vm.primaryColor = blue;
        glChart = wrapper.find(GlLineChart);
      });

      it('is a Vue instance', () => {
        expect(glChart.exists()).toBe(true);
        expect(glChart.isVueInstance()).toBe(true);
      });

      it('renders the main "metric"', () => {
        const { values } = graphData.queries[0].result[0];

        props = glChart.props();
        expect(props.data.length).toBe(1);
        expect(values).toEqual(props.data[0].data);
      });

      describe('appearance', () => {
        const graphDataAppearance = makeAnomalyGraphData(
          'noAnomaly',
          anomalyMockGraphDataWithAppearance,
        );

        beforeEach(done => {
          wrapper.setProps({
            graphData: graphDataAppearance,
          });
          wrapper.vm.$nextTick(done);
        });

        it('renders the main "metric" with appearance', () => {
          props = glChart.props();
          expect(props.data[0].lineStyle).toEqual(
            expect.objectContaining({
              type: 'dashed',
              width: 4,
            }),
          );
        });

        it('renders the main boundary area with appearance', () => {
          props = glChart.props();
          expect(props.option.series[1].areaStyle).toEqual(
            expect.objectContaining({
              opacity: 0.9,
            }),
          );
        });
      });

      describe('deployment data', () => {
        let deploymentSeries;

        beforeEach(() => {
          [deploymentSeries] = props.option.series.filter(
            s => s.type === graphTypes.deploymentData,
          );
        });
        it('is displayed with all data', () => {
          expect(deploymentSeries.data.length).toEqual(anomalyDeploymentData.length);
        });
        it('is displayed at the bottom of the chart', () => {
          expect(deploymentSeries.data.filter(d => d[1] === 0).length).toEqual(
            anomalyDeploymentData.length,
          );
        });
      });

      describe('the anomaly boundary', () => {
        let upperValues;
        let lowerValues;
        let boundarySeries;

        beforeEach(() => {
          props = glChart.props();
          upperValues = graphData.queries[1].result[0].values;
          lowerValues = graphData.queries[2].result[0].values;
          boundarySeries = props.option.series.filter(s => s.stack);
        });

        it('is 2 stacked line series', () => {
          boundarySeries.forEach(series => {
            expect(series).toEqual(
              expect.objectContaining({
                lineStyle: {
                  // a lower opacity shade of `blue`
                  color: expect.stringContaining(blueAsRgb),
                },
                // a lower opacity shade of `blue`
                color: expect.stringContaining(blueAsRgb),
                type: 'line',
              }),
            );
          });
        });

        it('is a visible area on top of an invisible area', () => {
          const [lowerSeries, upperSeries] = boundarySeries;

          expect(lowerSeries.areaStyle).toBeUndefined();
          expect(lowerSeries.data.length).toEqual(lowerValues.length);
          expect(lowerSeries.data).toEqual(lowerValues);
          expect(upperSeries.areaStyle.opacity).toEqual(expect.any(Number));
        });

        it('is calculated correctly', () => {
          const [, upperSeries] = boundarySeries;
          upperSeries.data.forEach((d, index) => {
            const [, yVal] = d;
            const [, yUpper] = upperValues[index];
            const [, yLower] = lowerValues[index];
            expect(yVal).toBeCloseTo(yUpper - yLower);
          });
        });
      });

      it('all series maintain the same lengths', () => {
        expect(wrapper.vm.dataSeries.metric.data).toHaveLength(
          graphData.queries[0].result[0].values.length,
        );
        expect(wrapper.vm.dataSeries.metric.data).toHaveLength(
          graphData.queries[1].result[0].values.length,
        );
        expect(wrapper.vm.dataSeries.metric.data).toHaveLength(
          graphData.queries[2].result[0].values.length,
        );
      });
    });

    describe('with anomalies', () => {
      const wrapperGraphData = makeAnomalyGraphData('oneAnomaly');
      let props;

      beforeEach(() => {
        const wrapper = makeAnomalyChart({
          graphData: wrapperGraphData,
        });
        const glChart = wrapper.find(GlLineChart);
        wrapper.vm.primaryColor = blue;
        props = glChart.props();
      });

      it('renders one anomaly using a big symbol (circle)', () => {
        const symbolSizeFn = props.data[0].symbolSize;

        expect(symbolSizeFn).toBeInstanceOf(Function);
        expect(symbolSizeFn(undefined, { dataIndex: 0 })).toBeCloseTo(0);
        expect(symbolSizeFn(undefined, { dataIndex: 1 })).not.toBeCloseTo(0);
        expect(symbolSizeFn(undefined, { dataIndex: 2 })).toBeCloseTo(0);
      });
      it('renders one anomaly using non-default color', () => {
        const colorFn = props.data[0].itemStyle.color;

        expect(colorFn).toBeInstanceOf(Function);
        expect(colorFn({ dataIndex: 0 })).toEqual(blue);
        expect(colorFn({ dataIndex: 1 })).not.toEqual(blue);
        expect(colorFn({ dataIndex: 2 })).toEqual(blue);
      });
    });

    describe('with offset', () => {
      const wrapperGraphData = makeAnomalyGraphData('negativeBoundary');
      let wrapper;
      let props;
      let lowerValues;
      beforeEach(() => {
        wrapper = makeAnomalyChart({
          graphData: wrapperGraphData,
        });
        props = wrapper.find(GlLineChart).props();
        lowerValues = wrapperGraphData.queries[2].result[0].values;
      });

      it('is calculated correctly with an offset', () => {
        const expectedOffset = 4; // Rounded up negative of -3.70
        const [lowerSeries] = props.option.series.filter(s => s.stack);
        lowerSeries.data.forEach((d, index) => {
          const [, yVal] = d;
          const [, yLower] = lowerValues[index];
          expect(yVal).toBeCloseTo(yLower + expectedOffset);
        });
      });
    });
  });
});
