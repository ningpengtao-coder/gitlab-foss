<script>
  import { __ } from '~/locale';
  import { mapActions, mapState } from 'vuex';
  import { GlAreaChart, GlLineChart } from '@gitlab/ui/dist/charts';
  import {
    GlLoadingIcon,
    GlDropdown,
    GlDropdownItem,
    GlFormTextarea,
    GlButton,
    GlFormGroup,
    GlFormInput,
  } from '@gitlab/ui';
  import syntaxHighlight from './../utils/beautify';

  import Icon from '~/vue_shared/components/icon.vue';
  import json2json from 'awesome-json2json';
  import formatHighlight from 'json-format-highlight';
  import prometheus from '../sample_data/prometheus';
  // eslint-disable-next-line global-require
  // const grafanaJSON = require('./../sample_data/grafana.json');

  export default {
    components: {
      Icon,
      GlLoadingIcon,
      GlAreaChart,
      GlLineChart,
      GlDropdown,
      GlDropdownItem,
      GlFormTextarea,
      GlButton,
      GlFormGroup,
      GlFormInput,
    },
    data() {
      return {
        chartUrl: '',
        //userJson: '',
        chartJson: '',
        formatterFn: '',
        syntaxHighlight,
        formatHighlight,
        formattedInput: '',
        config: {
          prometheus,
        },
      };
    },
    computed: {
      ...mapState('dataSource', ['chartData', 'loading', 'userJson']),
      data() {
        return this.chartHasData() && this.chartData.source;
      },
      dataSources() {
        return [
          'grafana', 'prometheus', 'influxdb',
        ];
      },
      chartOptions() {
        return {
          'xAxis': {
            'name': 'Series Name',
            'type': 'value',
          },
        };
      },
      showChart() {
        return !this.loading && this.chartHasData();
      },
      formattedJSON() {
        return this.formatHighlight(this.userJson);
      },
    },
    methods: {
      ...mapActions('dataSource', ['fetchChartData', 'setChartData']),
      onCreated(chart) {
        this.chart = chart;
      },
      onBlur(event) {
        this.formattedInput = this.syntaxHighlight(event.target.value);
        this.json2json();
      },
      chartHasData() {
        return Boolean(this.chartData);
      },
      getChartData() {
        this.fetchChartData(this.chartUrl);
      },
      updateJSON() {
        this.formattedInput = '';
      },
      json2json() {
        function stringToObject(str) {
          return eval(`(${str})`);
        }

        const formatter = stringToObject(this.formatterFn);
        const userJson = stringToObject(this.userJson);
        console.log(formatter, userJson);
        const transformed = json2json(userJson, formatter);
        this.setChartData(transformed);
        this.chartJson = this.formatHighlight(transformed.source);
      },
      setDataSource(source) {
        if (this.config[source]) {
          const config = this.config[source];
          this.chartUrl = config.url;
        }
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
                        @click="setDataSource(source)">
                    <li>{{source}}</li>
                </gl-dropdown-item>

            </gl-dropdown>
        </div>

        <div class="row">
            <label class="col-8 col-md-9 gl-pr-0 w-100 mt-2" @click.stop>
                <input
                        ref="searchInput"
                        v-model="chartUrl"
                        :placeholder="__('Chart url')"
                        type="search"
                        class="form-control dropdown-input-field"
                />
            </label>
            <gl-button
                    @click="getChartData">
                Request sample data
            </gl-button>
        </div>

        <div class="row">
            <div class="col-4">
                <h5>User sample json</h5>
                <!--                <gl-form-textarea-->
                <!--                        v-if="!formattedInput"-->
                <!--                        v-model="userJson"-->
                <!--                        rows="15"-->
                <!--                        @blur="onBlur"-->
                <!--                ></gl-form-textarea>-->
                <div v-if="formattedJSON">
                    <pre v-html="formattedJSON"/>

                    <gl-button
                            @click="updateJSON">
                        Update JSON
                    </gl-button>
                </div>
            </div>
            <div class="col-4">
                <h5>Transformation rules</h5>
                <gl-form-textarea
                        v-model="formatterFn"
                        rows="15"></gl-form-textarea>
                <gl-button
                        @click="json2json">
                    Convert JSON
                </gl-button>
            </div>
            <div class="col-4">
                <h5>Transformed / chart json</h5>

                <pre v-html="chartJson"/>
            </div>
        </div>

        <!--   <div class="row">
               <gl-form-group
                       :label="xAxisLabel"
                       label-for="xAxislabel"
               >
                   <gl-form-input
                           id="xAxislabel"
                           v-model="xAxislabel"
                           placeholder="XAxis Label"
                   />
               </gl-form-group>
           </div>-->


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

<style>
    pre {
        height: 330px;
        overflow-y: scroll;
        margin-bottom: 10px;
    }
</style>
