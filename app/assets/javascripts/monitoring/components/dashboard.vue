<script>
import { GlDropdown, GlDropdownItem } from '@gitlab/ui';
import _ from 'underscore';
import { mapActions, mapState, mapGetters } from 'vuex';
import Icon from '~/vue_shared/components/icon.vue';
import '~/vue_shared/mixins/is_ee';
import DashboardPanel from './dashboard_panel.vue';
import MonitorAreaChart from './charts/area.vue';
import LineChart from './charts/line.vue';

import SingleStatChart from './charts/single_stat.vue';
import HeatmapChart from './charts/heatmap.vue';
import GraphGroup from './graph_group.vue';
import EmptyState from './empty_state.vue';
import { timeWindows } from '../constants';
import { getTimeDiff } from '../utils';

const sidebarAnimationDuration = 150;
let sidebarMutationObserver;

export default {
  components: {
    MonitorAreaChart,
    GraphGroup,
    DashboardPanel,
    EmptyState,
    Icon,
    GlDropdown,
    GlDropdownItem,
    LineChart,
    SingleStatChart,
    HeatmapChart,
  },

  props: {
    hasMetrics: {
      type: Boolean,
      required: false,
      default: true,
    },
    showPanels: {
      type: Boolean,
      required: false,
      default: true,
    },
    documentationPath: {
      type: String,
      required: true,
    },
    settingsPath: {
      type: String,
      required: true,
    },
    clustersPath: {
      type: String,
      required: true,
    },
    tagsPath: {
      type: String,
      required: true,
    },
    projectPath: {
      type: String,
      required: true,
    },
    metricsEndpoint: {
      type: String,
      required: true,
    },
    deploymentEndpoint: {
      type: String,
      required: false,
      default: null,
    },
    emptyGettingStartedSvgPath: {
      type: String,
      required: true,
    },
    emptyLoadingSvgPath: {
      type: String,
      required: true,
    },
    emptyNoDataSvgPath: {
      type: String,
      required: true,
    },
    emptyUnableToConnectSvgPath: {
      type: String,
      required: true,
    },
    environmentsEndpoint: {
      type: String,
      required: true,
    },
    currentEnvironmentName: {
      type: String,
      required: true,
    },
    showTimeWindowDropdown: {
      type: Boolean,
      required: true,
    },
    usePrometheusEndpoint: {
      type: Boolean,
      required: true,
    },
    dashboardEndpoint: {
      type: String,
      required: false,
      default: '',
    },
  },
  data() {
    return {
      state: 'gettingStarted',
      elWidth: 0,
      selectedTimeWindow: '',
    };
  },
  computed: {
    ...mapGetters(['groups']),
    ...mapState(['emptyState', 'showEmptyState', 'environments', 'deploymentData']),
    groupsWithData() {
      if (!this.usePrometheusEndpoint) {
        return this.groups;
      }

      function hasQueryResult(acc, panel) {
        const metrics = panel.metrics.filter(query => query.result.length > 0);

        if (metrics.length > 0) {
          acc.push({
            ...panel,
            metrics,
          });
        }

        return acc;
      }

      return this.groups.reduce((acc, group) => {
        const panels = group.panels.reduce(hasQueryResult, []);

        if (panels.length > 0) {
          acc.push({
            ...group,
            panels,
          });
        }
        return acc;
      }, []);
    }
  },
  created() {
    if (this.usePrometheusEndpoint) {
      this.setDashboardEndpoint(this.dashboardEndpoint);
    } else {
      this.setMetricsEndpoint(this.metricsEndpoint);
    }
    this.setDeploymentsEndpoint(this.deploymentEndpoint);
    this.setEnvironmentsEndpoint(this.environmentsEndpoint);

    this.timeWindows = timeWindows;
    this.selectedTimeWindow = this.timeWindows.eightHours;
  },
  beforeDestroy() {
    if (sidebarMutationObserver) {
      sidebarMutationObserver.disconnect();
    }
  },
  mounted() {
    if (!this.hasMetrics) {
      // TODO: This should be coming from a mutation/computedGetter
      // this.state = 'gettingStarted';
    } else {
      if (this.usePrometheusEndpoint) {
        this.fetchDashboard();
      } else {
        this.fetchMetricsData(getTimeDiff(this.timeWindows.eightHours));
      }
      this.fetchDeploymentsData();
      this.fetchEnvironmentsData();

      sidebarMutationObserver = new MutationObserver(this.onSidebarMutation);
      sidebarMutationObserver.observe(document.querySelector('.layout-page'), {
        attributes: true,
        childList: false,
        subtree: false,
      });
    }
  },
  methods: {
    ...mapActions([
      'fetchDashboard',
      'fetchDeploymentsData',
      'fetchEnvironmentsData',
      'fetchMetricsData',
      'setMetricsEndpoint',
      'setDashboardEndpoint',
      'setDeploymentsEndpoint',
      'setEnvironmentsEndpoint',
    ]),
    getGraphAlerts(queries) {
      if (!this.allAlerts) return {};
      const metricIdsForChart = queries.map(q => q.metricId);
      return _.pick(this.allAlerts, alert => metricIdsForChart.includes(alert.metricId));
    },
    getGraphAlertValues(queries) {
      return Object.values(this.getGraphAlerts(queries));
    },
    onSidebarMutation() {
      setTimeout(() => {
        this.elWidth = this.$el.clientWidth;
      }, sidebarAnimationDuration);
    },
    activeTimeWindow(key) {
      return this.timeWindows[key] === this.selectedTimeWindow;
    },
  },
};
</script>

<template>
  <div v-if="!showEmptyState" class="prometheus-graphs prepend-top-default">
    <div
      v-if="environmentsEndpoint"
      class="dropdowns d-flex align-items-center justify-content-between"
    >
      <div class="d-flex align-items-center">
        <strong>{{ s__('Metrics|Environment') }}</strong>
        <gl-dropdown
          class="prepend-left-10 js-environments-dropdown"
          toggle-class="dropdown-menu-toggle"
          :text="currentEnvironmentName"
        >
          <gl-dropdown-item
            v-for="environment in environments"
            :key="environment.id"
            :href="environment.metrics_path"
            :active="environment.name === currentEnvironmentName"
            active-class="is-active"
            >{{ environment.name }}</gl-dropdown-item
          >
        </gl-dropdown>
      </div>
      <div v-if="showTimeWindowDropdown" class="d-flex align-items-center">
        <strong>{{ s__('Metrics|Show last') }}</strong>
        <gl-dropdown
          class="prepend-left-10 js-time-window-dropdown"
          toggle-class="dropdown-menu-toggle"
          :text="selectedTimeWindow"
        >
          <gl-dropdown-item
            v-for="(value, key) in timeWindows"
            :key="key"
            :active="activeTimeWindow(key)"
            @click="getGraphsDataWithTime(key)"
            >{{ value }}</gl-dropdown-item
          >
        </gl-dropdown>
      </div>
    </div>
    <graph-group
      v-for="(groupData, index) in groupsWithData"
      :key="index"
      :name="groupData.group"
      :show-panels="showPanels"
    >
      <dashboard-panel
        v-for="(graphData, graphIndex) in groupData.metrics"
        :graphData="graphData"
        :deploymentData="deploymentData"
        :key="graphIndex"
        :el-width="elWidth"
      />
    </graph-group>
  </div>
  <empty-state
    v-else
    :selected-state="emptyState"
    :documentation-path="documentationPath"
    :settings-path="settingsPath"
    :clusters-path="clustersPath"
    :empty-getting-started-svg-path="emptyGettingStartedSvgPath"
    :empty-loading-svg-path="emptyLoadingSvgPath"
    :empty-no-data-svg-path="emptyNoDataSvgPath"
    :empty-unable-to-connect-svg-path="emptyUnableToConnectSvgPath"
  />
</template>
