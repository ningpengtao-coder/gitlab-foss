import { shallowMount } from '@vue/test-utils';
import { GlSingleStat } from '@gitlab/ui/dist/charts';
import SingleStatChart from '~/monitoring/components/charts/single_stat.vue';

describe('Single Stat Chart component', () => {
  let singleStatChart;

  beforeEach(() => {
    singleStatChart = shallowMount(SingleStatChart, {
      propsData: {
        title: 'Time to render',
        value: 1,
        unit: 'sec',
      },
    });
  });

  afterEach(() => {
    singleStatChart.destroy();
  });

  describe('wrapped components', () => {
    describe('GitLab UI single stat chart', () => {
      let glSingleStatChart;

      beforeEach(() => {
        glSingleStatChart = singleStatChart.find(GlSingleStat);
      });

      it('is a Vue instance', () => {
        expect(glSingleStatChart.isVueInstance()).toBe(true);
      });
    });
  });

  describe('computed', () => {
    describe('valueWithUnit', () => {
      it('should interpolate the value and unit props', () => {
        expect(singleStatChart.vm.valueWithUnit).toBe('1sec');
      });
    });
  });
});
