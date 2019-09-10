<script>
import _ from 'underscore';
import dateFormat from 'dateformat';
import { GlLink, GlButton } from '@gitlab/ui';
import { GlLineChart, GlChartSeriesLabel } from '@gitlab/ui/dist/charts';
import { debounceByAnimationFrame, roundOffFloat } from '~/lib/utils/common_utils';
import { hexToRgb } from '~/lib/utils/color_utils';
import { getSvgIconPathContent } from '~/lib/utils/icon_utils';
import Icon from '~/vue_shared/components/icon.vue';
import {
  chartHeight,
  graphTypes,
  lineTypes,
  symbolSizes,
  areaOpacityValues,
  dateFormats,
  colorValues,
} from '../../constants';
import {
  graphDataValidatorForAnomalyValues,
  getEarliestDatapoint,
  makeTimeAxis,
} from '../../utils';

export default {
  components: {
    GlLineChart,
    GlButton,
    GlChartSeriesLabel,
    GlLink,
    Icon,
  },
  inheritAttrs: false,
  props: {
    graphData: {
      type: Object,
      required: true,
      validator: graphDataValidatorForAnomalyValues,
    },
    containerWidth: {
      type: Number,
      required: true,
    },
    deploymentData: {
      type: Array,
      required: false,
      default: () => [],
    },
    projectPath: {
      type: String,
      required: false,
      default: '',
    },
    singleEmbed: {
      type: Boolean,
      required: false,
      default: false,
    },
    thresholds: {
      type: Array,
      required: false,
      default: () => [],
    },
  },
  data() {
    return {
      tooltip: {
        title: '',
        content: [],
        commitUrl: '',
        isDeployment: false,
        sha: '',
      },
      width: 0,
      height: chartHeight,
      svgs: {},
      primaryColor: null,
    };
  },
  computed: {
    dataSeries() {
      // for anomaly only 3 queries are considered, metric, upper boundary and lower boundary
      const [metricDataSeries, upperDataSeries, lowerDataSeries] = this.graphData.queries.map(
        query => {
          const values = query.result[0] ? query.result[0].values : [];
          return {
            label: query.label,
            data: values.filter(([, value]) => !Number.isNaN(value)),
          };
        },
      );
      return {
        metric: metricDataSeries,
        upper: upperDataSeries,
        lower: lowerDataSeries,
      };
    },
    yOffset() {
      // in case the any part of the chart is displayed below 0
      // calculate an offset for the whole chart, so the bounday can be displayed
      const mins = Object.keys(this.dataSeries).map(seriesName =>
        this.dataSeries[seriesName].data.reduce((min, datapoint) => {
          const [, yVal] = datapoint;
          return Math.floor(Math.min(min, yVal));
        }, Infinity),
      );
      return -Math.min(...mins);
    },
    lineStyle() {
      // line appearance is found in the metric series
      const style = _.defaults(
        { ...this.graphData.queries[0].appearance },
        {
          line: {},
        },
      );

      style.line.color = style.line.color || this.primaryColor;
      // set width even if undefined, echarts defaults to a different width when set
      style.line.width = _.isNumber(style.line.width) ? style.line.width : undefined;
      style.line.type = style.line.type || lineTypes.default;
      return style.line;
    },
    areaStyle() {
      // area appearance is found in the upper series
      const style = _.defaults(
        { ...this.graphData.queries[1].appearance },
        {
          area: {},
        },
      );
      style.area.color = style.area.color || this.primaryColor;
      style.area.opacity = _.isNumber(style.area.opacity)
        ? style.area.opacity
        : areaOpacityValues.default;
      return style.area;
    },
    areaColorAsRgba() {
      if (this.areaStyle.color && _.isNumber(this.areaStyle.opacity)) {
        const rgb = hexToRgb(this.areaStyle.color);
        return `rgba(${rgb.join(',')},${this.areaStyle.opacity})`;
      }
      return null;
    },
    chartData() {
      return [
        {
          type: 'line',
          name: this.formatLegendLabel(this.dataSeries.metric),
          data: this.dataSeries.metric.data.map(datapoint => {
            const [xVal, yVal] = datapoint;
            return [xVal, yVal + this.yOffset];
          }),
          symbol: 'circle',
          symbolSize: (val, params) => {
            if (this.isDatapointAnomaly(params.dataIndex)) {
              return symbolSizes.anomaly;
            }
            // 0 causes echarts to throw an error, use small number instead
            // see https://gitlab.com/gitlab-org/gitlab-ui/issues/423
            return 0.001;
          },
          itemStyle: {
            color: params => {
              if (this.isDatapointAnomaly(params.dataIndex)) {
                return colorValues.anomalySymbol;
              }
              return this.primaryColor;
            },
          },
          lineStyle: this.lineStyle,
        },
      ];
    },
    chartOptions() {
      const calcOffsetY = (data, offsetCallback) =>
        data.map((value, valueIndex) => {
          const [x, y] = value;
          return [x, y + offsetCallback(valueIndex)];
        });

      return {
        xAxis: makeTimeAxis(),
        yAxis: {
          name: this.yAxisLabel,
          axisLabel: {
            formatter: num => roundOffFloat(num - this.yOffset, 3).toString(),
          },
        },
        series: [
          // The boundary is rendered by 2 series
          // One area invisible series (opacity: 0) stacked on a visible one
          this.makeBoundarySeries({
            name: this.formatLegendLabel(this.dataSeries.lower),
            data: calcOffsetY(this.dataSeries.lower.data, () => this.yOffset),
          }),
          this.makeBoundarySeries({
            name: this.formatLegendLabel(this.dataSeries.upper),
            data: calcOffsetY(this.dataSeries.upper.data, i => -this.dataSeries.lower.data[i][1]),
            areaStyle: this.areaStyle,
          }),
          this.deploymentSeries,
        ],
        dataZoom: this.dataZoomConfig,
      };
    },
    dataZoomConfig() {
      const handleIcon = this.svgs['scroll-handle'];
      return handleIcon ? { handleIcon } : {};
    },
    recentDeployments() {
      return this.deploymentData.reduce((acc, deployment) => {
        const earliestDatapoint = getEarliestDatapoint(this.chartData);
        if (earliestDatapoint && deployment.created_at >= getEarliestDatapoint(this.chartData)) {
          const { id, created_at, sha, ref, tag } = deployment;
          acc.push({
            id,
            createdAt: created_at,
            sha,
            commitUrl: `${this.projectPath}/commit/${sha}`,
            tag,
            tagUrl: tag ? `${this.tagsPath}/${ref.name}` : null,
            ref: ref.name,
            showDeploymentFlag: false,
          });
        }
        return acc;
      }, []);
    },
    deploymentSeries() {
      return {
        type: graphTypes.deploymentData,
        data: this.recentDeployments.map(deployment => [deployment.createdAt, 0]),
        symbol: this.svgs.rocket,
        symbolSize: symbolSizes.default,
        itemStyle: {
          color: this.primaryColor,
        },
      };
    },
    yAxisLabel() {
      return this.dataSeries.metric.label;
    },
  },
  watch: {
    containerWidth: 'onResize',
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.debouncedResizeListener);
  },
  created() {
    this.debouncedResizeListener = debounceByAnimationFrame(this.onResize);
    window.addEventListener('resize', this.debouncedResizeListener);

    this.setSvg('rocket');
    this.setSvg('scroll-handle');
  },
  methods: {
    formatLegendLabel(query) {
      return query.label;
    },
    formatTooltipText(params) {
      this.tooltip.title = dateFormat(params.value, dateFormats.default);
      this.tooltip.content = [];
      params.seriesData.forEach(datapoint => {
        const [xVal, yVal] = datapoint.value;
        this.tooltip.isDeployment = datapoint.componentSubType === graphTypes.deploymentData;
        if (this.tooltip.isDeployment) {
          const [deploy] = this.recentDeployments.filter(
            deployment => deployment.createdAt === xVal,
          );
          this.tooltip.sha = deploy.sha.substring(0, 8);
          this.tooltip.commitUrl = deploy.commitUrl;
        } else {
          const { seriesName, color } = datapoint;
          const value = (yVal - this.yOffset).toFixed(3);
          this.tooltip.content.push({
            name: seriesName,
            value,
            color,
          });
        }
      });
    },
    isDatapointAnomaly(dataIndex) {
      const [, yVal] = this.dataSeries.metric.data[dataIndex];
      const [, yLower] = this.dataSeries.lower.data[dataIndex];
      const [, yUpper] = this.dataSeries.upper.data[dataIndex];
      return yVal < yLower || yVal > yUpper;
    },
    makeBoundarySeries(series) {
      const stackKey = 'anomaly-boundary-series-stack';
      return {
        type: 'line',
        stack: stackKey,
        lineStyle: {
          color: this.areaColorAsRgba, // appears in the legend
        },
        color: this.areaColorAsRgba, // appears in the tooltip
        symbol: 'none',
        ...series,
      };
    },
    setSvg(name) {
      getSvgIconPathContent(name)
        .then(path => {
          if (path) {
            this.$set(this.svgs, name, `path://${path}`);
          }
        })
        .catch(e => {
          // eslint-disable-next-line no-console, @gitlab/i18n/no-non-i18n-strings
          console.error('SVG could not be rendered correctly: ', e);
        });
    },
    onChartUpdated(chart) {
      [this.primaryColor] = chart.getOption().color;
    },
    onResize() {
      if (!this.$refs.chart) return;
      const { width } = this.$refs.chart.$el.getBoundingClientRect();
      this.width = width;
    },
  },
};
</script>

<template>
  <div class="prometheus-graph col-12" :class="{ 'col-lg-6': !singleEmbed }">
    <div class="prometheus-graph-header">
      <h5 class="prometheus-graph-title js-graph-title">{{ graphData.title }}</h5>
      <div class="prometheus-graph-widgets js-graph-widgets">
        <slot></slot>
      </div>
    </div>
    <gl-line-chart
      ref="chart"
      v-bind="$attrs"
      :data="chartData"
      :option="chartOptions"
      :include-legend-avg-max="false"
      :format-tooltip-text="formatTooltipText"
      :thresholds="thresholds"
      :width="width"
      :height="height"
      @updated="onChartUpdated"
    >
      <template v-if="tooltip.isDeployment">
        <template slot="tooltipTitle">{{ __('Deployed') }}</template>
        <div slot="tooltipContent" class="d-flex align-items-center">
          <icon name="commit" class="mr-2" />
          <gl-link :href="tooltip.commitUrl">{{ tooltip.sha }}</gl-link>
        </div>
      </template>
      <template v-else>
        <template slot="tooltipTitle">
          <div class="text-nowrap">{{ tooltip.title }}</div>
        </template>
        <template slot="tooltipContent">
          <div
            v-for="(seriesLabel, key) in tooltip.content"
            :key="key"
            class="d-flex justify-content-between"
          >
            <gl-chart-series-label :color="tooltip.content.length > 1 ? seriesLabel.color : ''">{{
              seriesLabel.name
            }}</gl-chart-series-label>
            <div class="prepend-left-32">{{ seriesLabel.value }}</div>
          </div>
        </template>
      </template>
    </gl-line-chart>
  </div>
</template>
