<script>
import { GlSingleStat } from '@gitlab/ui/dist/charts';

export default {
  components: {
    GlSingleStat,
  },
  inheritAttrs: false,
  props: {
    title: {
      type: String,
      required: true,
    },
    value: {
      type: Number,
      required: true,
    },
    unit: {
      type: String,
      required: true,
    },
  },
  computed: {
    valueWithUnit() {
      return `${this.value}${this.unit}`;
    },
  },
};
</script>
<template>
  <div class="prometheus-graph col-12 col-lg-6">
    <div class="prometheus-graph-header">
      <h5 ref="graphTitle" class="prometheus-graph-title">{{ graphData.title }}</h5>
      <!-- Do we need widgets for this graph type? -->
      <!-- <div ref="graphWidgets" class="prometheus-graph-widgets"><slot></slot></div> -->
    </div>
    <gl-single-stat :value="valueWithUnit" :title="title" variant="success" />
  </div>
</template>
