<script>
  import { s__ } from '~/locale';
  import { mapGetters, mapActions, mapState } from 'vuex';
  import { engineeringNotation, sum, average } from '@gitlab/ui/utils/number_utils';
  import { GlLoadingIcon } from '@gitlab/ui';
  import { GlAreaChart } from '@gitlab/ui/dist/charts';


  export default {
    components: {
      GlLoadingIcon,
      GlAreaChart,
    },
    props: {
      endpoint: {
        type: String,
        required: true,
      },
    },
    data() {
      return {
        svgs: {},
        chart: null,
        seriesInfo: [
          {
            type: 'solid',
            name: s__('IssuesAnalytics | Issues created'),
            color: '#1F78D1',
          },
        ],
      };
    },
    computed: {
      ...mapState('dataSource', ['chartData', 'loading']),
      ...mapGetters('dataSource', ['hasFilters', 'appliedFilters']),
      data() {
        return [];
      },
      showChart() {
        return true;
      },
      chartLabels() {
        return this.data.map(val => val[0]);
      },
      chartOptions() {
        return {
          dataZoom: [
            {
              type: 'slider',
              startValue: 0,
              handleIcon: this.svgs['scroll-handle'],
            },
          ],
        };
      },
      series() {
        return this.data.map(val => val[1]);
      },
      seriesAverage() {
        return engineeringNotation(average(...this.series), 0);
      },
      seriesTotal() {
        return engineeringNotation(sum(...this.series));
      },
    },
    methods: {
      ...mapActions('issueAnalytics', ['fetchChartData']),
      onCreated(chart) {
        this.chart = chart;
      },
      chartHasData() {
        if (!this.chartData) {
          return false;
        }

        return Object.values(this.chartData).some(val => val > 0);
      },
    },
  };
</script>
<template>
  <div class="d-block">
    <div v-if="loading" class="issues-analytics-loading text-center">
      <gl-loading-icon :inline="true" :size="4" />
    </div>

    <div v-if="showChart" class="issues-analytics-chart">
      <h4 class="chart-title">Test area chart</h4>

      <gl-area-chart :data="data"
      ></gl-area-chart>
    </div>

  </div>
</template>
