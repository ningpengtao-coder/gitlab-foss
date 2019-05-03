<script>
import _ from 'underscore';
import MonitorAreaChart from './charts/area.vue';
import LineChart from './charts/line.vue';
import SingleStatChart from './charts/single_stat.vue';

export default {
  components: {
    MonitorAreaChart,
    LineChart,
    SingleStatChart,
  },
  props: {
    panelType: {
      type: String,
      required: false,
      default: 'area',
    },
    graphData: {
      type: Object,
      required: true,
    },
    deploymentData: {
      type: Array,
      required: false,
    },
    elWidth: {
      type: Number,
      required: true,
    }
  },
  methods: {
    getGraphAlerts(queries) {
      if (!this.allAlerts) return {};
      const metricIdsForChart = queries.map(q => q.metricId);
      return _.pick(this.allAlerts, alert => metricIdsForChart.includes(alert.metricId));
    },
    getGraphAlertValues(queries) {
      return Object.values(this.getGraphAlerts(queries));
    },
    getComponentType() {
      return MonitorAreaChart;
    }
  }
};
</script>

<template>
  <component
    :is="getComponentType"
    :graph-data="graphData"
    :deployment-data="deploymentData"
    :thresholds="getGraphAlertValues(graphData.queries)"
    :container-width="elWidth"
    group-id="monitor-area-chart"
  >
    <alert-widget
      v-if="isEE && prometheusAlertsAvailable && alertsEndpoint && graphData"
      :alerts-endpoint="alertsEndpoint"
      :relevant-queries="graphData.queries"
      :alerts-to-manage="getGraphAlerts(graphData.queries)"
      @setAlerts="setAlerts"
    />
  </component>
  <!--
  <single-stat-chart
    v-else-if="graphData.type === 'single_stat'"
    value="100"
    unit="ms"
    title="latency"
  />
  <line-chart
    v-else-if="graphData.type === 'line_chart'"
    :graph-data="graphData"
    :container-width="elWidth"
  />
  <heatmap-chart
    v-else-if="graphData.type === 'heatmap_chart'"
    :graph-data="graphData"
  />
   -->
</template>
