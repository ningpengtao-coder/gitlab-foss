<script>
import { GlHeatmap } from '@gitlab/ui/dist/charts';

export default {
  components: {
    GlHeatmap,
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
    },
  },
  computed: {
    chartData() {
      // TODO: Check API for visual customization options
      // TODO: Check data formatting for heatmap
      return this.graphData.series;
    },
    title() {
      return this.graphData.title !== undefined ? this.graphData.title : '';
    },
    // TODO: Check zoom options
  },
};
</script>
<template>
  <div class="prometheus-graph col-12 col-lg-6">
    <div class="prometheus-graph-header">
      <h5 ref="graphTitle" class="prometheus-graph-title">{{ title }}</h5>
      <!-- Do we need widgets for heatmaps? -->
      <!-- <div ref="graphWidgets" class="prometheus-graph-widgets"><slot></slot></div> -->
    </div>
    <gl-heatmap
      ref="heatmapChart"
      v-bind="$attrs"
      :data-series="chartData"
      :options="chartOptions"
      :x-series-labels="graphData.x_series_labels"
      :y-series-labels="graphData.y_series_labels"
    />
  </div>
</template>
