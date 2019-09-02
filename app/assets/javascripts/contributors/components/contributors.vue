<script>
import { s__ } from '~/locale';
import { mapGetters, mapActions, mapState } from 'vuex';
import { engineeringNotation, sum, average } from '@gitlab/ui/utils/number_utils';
import { GlLoadingIcon } from '@gitlab/ui';
import { GlChartLegend } from '@gitlab/ui/charts';
import { GlAreaChart } from '@gitlab/ui/dist/charts';
import { getSvgIconPathContent } from '~/lib/utils/icon_utils';
import ContributorsStatGraphUtil from '../../pages/projects/graphs/show/stat_graph_contributors_util';

const chartOptions = {
  'xAxis': {
    'type': 'time',
    'name': 'Time',
    'axisLabel': {},
    minInterval: 3600 * 24 * 1000 * 365,
  },
  yAxis: {
    name: 'Number of commits',
  }
};

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
      chartOptions,
    };
  },
  computed: {
    ...mapState('contributors', ['chartData', 'loading']),
    ...mapGetters('contributors', ['hasFilters', 'appliedFilters']),
    chartData2() {
      // const { chartData, chartHasData } = this;
      // const data = [];
      //
      // if (chartHasData()) {
      //   Object.keys(chartData).forEach(key => {
      //     const date = new Date(key);
      //     const label = `${getMonthNames(true)[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
      //     const val = chartData[key];
      //
      //     data.push([label, val]);
      //   });
      // }
      //
      // return data;
      if (!this.chartHasData) return;

      const data = this.totalCommits.map((item) => {
        return [new Date(item.date), item.commits];
      });

      return [
        {
          name: 'Commits',
          data
        },
      ];
    },
    chartHasData() {
      return !this.loading && this.chartData;
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

    contributors() {
      const commitsByAuthor = ContributorsStatGraphUtil.get_author_data(this.parsedLog, 'commits').slice(0, 5);
      return commitsByAuthor.map((item) => {
        return {
          ...item,
          dates: [{
            name: 'Commits',
            data: Object.keys(item.dates).map((date) => {
              return [new Date(date), item.dates[date]];
            }),
          }],
        };
      });
    },
    // chartOptions() {
    //   return {
    //     dataZoom: [
    //       {
    //         type: 'slider',
    //         startValue: 0,
    //         handleIcon: this.svgs['scroll-handle'],
    //       },
    //     ],
    //   };
    // },
    parsedLog() {
      return ContributorsStatGraphUtil.parse_log(this.chartData);
    },
    totalCommits() {
      return ContributorsStatGraphUtil.get_total_data(this.parsedLog, 'commits');
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
    getTotalData(){
      return ContributorsStatGraphUtil.get_total_data(this.parsed_log, this.field);
    }
  },
};
</script>
<template>
    <div class="issues-analytics-wrapper">
        <div v-if="loading" class="issues-analytics-loading text-center">
            <gl-loading-icon :inline="true" :size="4"/>
        </div>
        <gl-area-chart v-if="!loading"
                       :data="chartData2"
                       :option="chartOptions"/>
        <div class="contributors-list row" v-if="!loading">
            <div class="person col-6" v-for="contributor in contributors">
                <h4>{{contributor.author_name}}</h4>
                <p>{{contributor.author_email}}</p>
                <p>{{contributor.commits}}</p>
                <gl-area-chart :data="contributor.dates"
                               :option="chartOptions"/>
            </div>
        </div>
    </div>
</template>
