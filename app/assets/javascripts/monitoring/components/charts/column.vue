<script>
import { GlColumnChart } from '@gitlab/ui/dist/charts';
import { debounceByAnimationFrame } from '~/lib/utils/common_utils';
import { chartHeight } from '../../constants';
import { makeDataSeries } from '~/helpers/monitor_helper';

let debouncedResize;

export default {
  components: {
    GlColumnChart,
  },
  inheritAttrs: false,
  props: {
    graphData: {
      type: Object,
      required: true,
      validator(data) {
        return (
          Array.isArray(data.queries) &&
          data.queries.filter(query => {
            if (Array.isArray(query.result)) {
              return (
                query.result.filter(res => Array.isArray(res.values)).length === query.result.length
              );
            }
            return false;
          }).length === data.queries.length
        );
      },
      containerWidth: {
        type: Number,
        required: true,
      },
    },
  },
  data() {
    return {
      width: 0,
      height: chartHeight,
    };
  },
  computed: {
    chartData() {
      // TODO: Check API for visual customization options
      return this.graphData.queries.reduce((acc, query) => {
        const { appearance } = query;

        const series = makeDataSeries(query.result, {
          areaStyle: {
            opacity:
              appearance && appearance.area && typeof appearance.area.opacity === 'number'
                ? appearance.area.opacity
                : undefined,
          },
        });

        return acc.concat(series);
      }, []);
    },
    xAxisTitle() {
      return this.graphData.x_label !== undefined ? this.graphData.x_label : '';
    },
    yAxisTitle() {
      return this.graphData.y_label !== undefined ? this.graphData.x_label : '';
    },
    xAxisType() {
      // Default to category in case there's no predefined xAxisType
      return this.graphData.x_type !== undefined ? this.graphData.x_type : 'category';
    },
    // TODO: Check zoom options
  },
  watch: {
    containerWidth: 'onResize',
  },
  beforeDestroy() {
    window.removeEventListener('resize', debouncedResize);
  },
  created() {
    debouncedResize = debounceByAnimationFrame(this.onResize);
    window.addEventListener('resize', debouncedResize);
  },
  methods: {
    onChartUpdated() {
      // Do something when the chart gets updated or don't
    },
    onResize() {
      const { width } = this.$refs.columnChart.$el.getBoundingClientRect();
      this.width = width;
    },
  },
};
</script>
<template>
  <div class="prometheus-graph col-12 col-lg-6">
    <div class="prometheus-graph-header">
      <h5 ref="graphTitle" class="prometheus-graph-title">{{ graphData.title }}</h5>
      <div ref="graphWidgets" class="prometheus-graph-widgets"><slot></slot></div>
    </div>
    <gl-column-chart
      ref="columnChart"
      v-bind="$attrs"
      :data="chartData"
      :width="width"
      :height="height"
      :x-axis-title="xAxisTitle"
      :y-axis-title="yAxisTitle"
      :x-axis-type="xAxisType"
      @updated="onChartUpdated"
    />
  </div>
</template>
