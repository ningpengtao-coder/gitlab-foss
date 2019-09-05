<script>
  import { __ } from '~/locale';
  import {  mapActions, mapState } from 'vuex';
  import { GlAreaChart, GlLineChart } from '@gitlab/ui/dist/charts';
  import { GlLoadingIcon, GlDropdown, GlDropdownItem } from '@gitlab/ui';
  import Icon from '~/vue_shared/components/icon.vue';

  export default {
    components: {
      Icon,
      GlLoadingIcon,
      GlAreaChart,
      GlLineChart,
      GlDropdown,
      GlDropdownItem,
    },
    data() {
      return {
        chartUrl: '',
      };
    },
    computed: {
      ...mapState('dataSource', ['chartData', 'loading']),
      data() {
        return this.chartHasData() && this.chartData.source;
      },
      dataSources() {
        return [
          'Grafana', 'Prometheus', 'InfluxDB',
        ];
      },
      chartOptions() {
        return this.chartData.chartOptions;
      },
      showChart() {
        return !this.loading && this.chartHasData();
      },
    },
    methods: {
      ...mapActions('dataSource', ['fetchChartData']),
      onCreated(chart) {
        this.chart = chart;
      },
      chartHasData() {
        return Boolean(this.chartData);
      },
      getChartData(event) {
        this.fetchChartData(event.target.value);
      },
    },
  };
</script>
<template>
  <div class="d-block">
    <div v-if="loading" class="issues-analytics-loading text-center">
      <gl-loading-icon :inline="true" :size="4"/>
    </div>

    <h4 class="chart-title">Select data source</h4>
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
    <div class="row">
      <label class="dropdown-input pt-3 pb-3 mb-0 border-bottom block position-relative" @click.stop>
        <input
                ref="searchInput"
                v-model="chartUrl"
                :placeholder="__('Chart url')"
                type="search"
                class="form-control dropdown-input-field"
                @blur="getChartData"
        />
        <icon :size="18" name="search" class="ml-3 input-icon"/>
      </label>
    </div>


    <div v-if="showChart" class="issues-analytics-chart">
      <h4 class="chart-title">Test data source</h4>
      <gl-area-chart :data="data"
                     :option="chartOptions"
      ></gl-area-chart>
      <gl-line-chart :data="data"
                     :option="chartOptions"/>
    </div>

  </div>
</template>
