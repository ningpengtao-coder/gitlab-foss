<script>
  import { __ } from '~/locale';
  import { mapGetters, mapActions, mapState } from 'vuex';
  import { engineeringNotation, sum, average } from '@gitlab/ui/utils/number_utils';
  import { GlAreaChart, GlLineChart } from '@gitlab/ui/dist/charts';
  import { GlLoadingIcon, GlDropdown, GlDropdownItem } from '@gitlab/ui';

  export default {
    components: {
      GlLoadingIcon,
      GlAreaChart,
      GlLineChart,
      GlDropdown,
      GlDropdownItem,
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
            name: __('DataSources'),
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
       dataSources() {
        return [
          'Grafana', 'Prometheus', 'InfluxDB',
        ];
      },
      lineChartData() {
        return [
          {
            "name": "Requested",
            "data": [
              [
                "Mon",
                1184
              ],
              [
                "Tue",
                1346
              ],
              [
                "Wed",
                1035
              ],
              [
                "Thu",
                1226
              ],
              [
                "Fri",
                1421
              ],
              [
                "Sat",
                1347
              ],
              [
                "Sun",
                1035
              ]
            ]
          },
          {
            "name": "Actual",
            "data": [
              [
                "Mon",
                1509
              ],
              [
                "Tue",
                1275
              ],
              [
                "Wed",
                1187
              ],
              [
                "Thu",
                1287
              ],
              [
                "Fri",
                1098
              ],
              [
                "Sat",
                1457
              ],
              [
                "Sun",
                1452
              ]
            ]
          },
          {
            "name": "Predicted",
            "data": [
              [
                "Mon",
                1041
              ],
              [
                "Tue",
                1468
              ],
              [
                "Wed",
                1273
              ],
              [
                "Thu",
                1503
              ],
              [
                "Fri",
                1209
              ],
              [
                "Sat",
                1416
              ],
              [
                "Sun",
                1213
              ]
            ]
          }
        ]
      },
      lineChartOptions() {
        return {
          'xAxis': {
            'name': 'Days',
            'type': 'category',
          },
        };
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
      <gl-loading-icon :inline="true" :size="4"/>
    </div>

    <div v-if="showChart" class="issues-analytics-chart">
      <h4 class="chart-title">Test data source</h4>
      <div class="row">
        <gl-dropdown
                class="col-8 col-md-9 gl-pr-0"
                menu-class="w-100 mw-100"
                toggle-class="dropdown-menu-toggle w-100 gl-field-error-outline"
                text="-- Select datasource --"
        >

          <gl-dropdown-item
                  v-for="source in dataSources"
                  class="w-100"
                  @click="$emit('select-project', source)">
            <li>{{source}}</li>
          </gl-dropdown-item>

        </gl-dropdown>
      </div>

      <gl-area-chart :data="data"
      ></gl-area-chart>
      <gl-line-chart :data="lineChartData"
                     :option="lineChartOptions"/>
    </div>

  </div>
</template>
