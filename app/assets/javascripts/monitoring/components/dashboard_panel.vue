<script>
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
  },
};
</script>
<template>
  <single-stat-chart v-if="panelType === 'single_stat'" value="100" unit="ms" title="latency" />
  <line-chart
    v-else-if="panelType === 'line_chart'"
    :graph-data="graphData"
    :container-width="elWidth"
  />
  <monitor-area-chart
    v-else
    :graph-data="graphData"
    :deployment-data="store.deploymentData"
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
  </monitor-area-chart>
</template>
