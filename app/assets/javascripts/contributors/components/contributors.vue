<script>
import { s__ } from '~/locale';
import { mapGetters, mapActions, mapState } from 'vuex';
import { engineeringNotation, sum, average } from '@gitlab/ui/utils/number_utils';
import { GlLoadingIcon } from '@gitlab/ui';
import { GlChartLegend } from '@gitlab/ui/charts';
import { GlAreaChart } from '@gitlab/ui/dist/charts';
import { getSvgIconPathContent } from '~/lib/utils/icon_utils';

export default {
  components: {
    GlAreaChart,
    GlLoadingIcon,
    GlChartLegend,
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
    ...mapState('contributors', ['chartData', 'loading']),
    ...mapGetters('contributors', ['hasFilters', 'appliedFilters']),
    data() {
      const { chartData, chartHasData } = this;
      const data = [];

      if (chartHasData()) {
        Object.keys(chartData).forEach(key => {
          const date = new Date(key);
          const label = `${getMonthNames(true)[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
          const val = chartData[key];

          data.push([label, val]);
        });
      }

      return data;
    },
    chartLabels() {
      return this.data.map(val => val[0]);
    },
    chartDateRange() {
      return `${this.chartLabels[0]} - ${this.chartLabels[this.chartLabels.length - 1]}`;
    },
    showChart() {
      return !this.loading && this.chartHasData();
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
  watch: {
    appliedFilters() {
      this.fetchChartData(this.endpoint);
    },
    showNoDataEmptyState(showEmptyState) {
      if (showEmptyState) {
        this.$nextTick(() => this.filterBlockEl.classList.add('hide'));
      }
    },
  },
  created() {
    this.setSvg('scroll-handle');
  },
  mounted() {
    this.fetchChartData(this.endpoint);
  },
  methods: {
    ...mapActions('contributors', ['fetchChartData']),
    onCreated(chart) {
      this.chart = chart;
    },
    chartHasData() {
      if (!this.chartData) {
        return false;
      }

      return Object.values(this.chartData).some(val => val > 0);
    },
    setSvg(name) {
      getSvgIconPathContent(name)
        .then(path => {
          if (path) {
            this.$set(this.svgs, name, `path://${path}`);
          }
        })
        .catch(() => {});
    },
  },
};
</script>
<template>
  <div class="issues-analytics-wrapper">
     <!--   <div v-if="loading" class="issues-analytics-loading text-center">
          <gl-loading-icon :inline="true" :size="4"/>
        </div>-->

    This is just the beginning
  </div>
</template>
