import axios from '../../lib/utils/axios_utils';
import statusCodes from '../../lib/utils/http_status';
import { backOff } from '../../lib/utils/common_utils';
import { s__ } from '../../locale';

const MAX_REQUESTS = 3;

function backOffRequest(makeRequestCallback) {
  let requestCounter = 0;
  return backOff((next, stop) => {
    makeRequestCallback()
      .then(resp => {
        if (resp.status === statusCodes.NO_CONTENT) {
          requestCounter += 1;
          if (requestCounter < MAX_REQUESTS) {
            next();
          } else {
            stop(new Error('Failed to connect to the prometheus server'));
          }
        } else {
          stop(resp);
        }
      })
      .catch(stop);
  });
}

export default class MonitoringService {
  constructor({ metricsEndpoint, dashboardEndpoint, deploymentEndpoint, environmentsEndpoint }) {
    this.metricsEndpoint = metricsEndpoint;
    this.deploymentEndpoint = deploymentEndpoint;
    this.environmentsEndpoint = environmentsEndpoint;
    this.dashboardEndpoint = dashboardEndpoint;
  }

  getDashboardData(params = {}) {
    return axios
      .get(this.dashboardEndpoint, { params })
      .then(resp => resp.data)
      .then(response => {
        if (!response || response.status !== 'success') {
          throw new Error(s__('Metrics|Unexpected metrics data response from prometheus endpoint'));
        }
        return response.dashboard;
      });
  }

  getPrometheusMetricas(panelGroups) {
    const promises = panelGroups.reduce((groups, group) => {
      return group.panels.reduce((panels, panel) => {
        // todo: move this to store. This is needed because the template
        // refers to `queries`
        panel.queries = panel.metrics;
        // return an array of Promises (Prometheus fetch requests)
        return panel.queries.reduce((queries, metric) => {
          return queries.concat(
            this.getPrometheusMetrics(metric).then(res => {
              // can be matrix for ranges, or vector for single value
              if (res.resultType === 'matrix') {
                if (res.result.length > 0) {
                  panel.queries[0].result = res.result;
                  console.log('metriedId', panel.queries[0].metricId)
                  panel.queries[0].metricId = panel.queries[0].metric_id;
                }
              }
            }),
          );
        }, []);
      }, []);
    }, []);

    return Promise.all(promises);
  }

  /**
   * Returns list of metrics in data.result
   * {"status":"success", "data":{"resultType":"matrix","result":[]}}
   * 
   * @param {metric} metric 
   */
  getPrometheusMetrics(metric) {
    const queryType = Object.keys(metric).find(key => ['query', 'query_range'].includes(key));
    const query = metric[queryType];
    // TODO don't hardcode
    const prometheusEndpoint = `/root/metrics/environments/37/prometheus/api/v1/${queryType}`;

    // todo use timewindow
    const timeDiff = 8 * 60 * 60; // 8hours in seconnds
    const end = Math.floor(Date.now() / 1000);
    const start = end - timeDiff;

    const minStep = 60;
    const queryDataPoints = 600;
    const step = Math.max(minStep, Math.ceil(timeDiff / queryDataPoints));

    const params = {
      query,
      start,
      end,
      step,
    };

    return backOffRequest(() => axios.get(prometheusEndpoint, { params }))
      .then(res => res.data)
      .then(response => {
        if (response.status === 'error') {
          // {"status":"error","errorType":"bad_data","error":"exceeded maximum resolution of 11,000 points per timeseries. Try decreasing the query resolution (?step=XX)"}
        }

        // metrics for a single panel
        return response.data;
      });
  }

  getGraphsData(params = {}) {
    return backOffRequest(() => axios.get(this.metricsEndpoint, { params }))
      .then(resp => resp.data)
      .then(response => {
        if (!response || !response.data || !response.success) {
          throw new Error(s__('Metrics|Unexpected metrics data response from prometheus endpoint'));
        }
        return response.data;
      });
  }

  getDeploymentData() {
    if (!this.deploymentEndpoint) {
      return Promise.resolve([]);
    }
    return backOffRequest(() => axios.get(this.deploymentEndpoint))
      .then(resp => resp.data)
      .then(response => {
        if (!response || !response.deployments) {
          throw new Error(
            s__('Metrics|Unexpected deployment data response from prometheus endpoint'),
          );
        }
        return response.deployments;
      });
  }

  getEnvironmentsData() {
    return axios
      .get(this.environmentsEndpoint)
      .then(resp => resp.data)
      .then(response => {
        if (!response || !response.environments) {
          throw new Error(
            s__('Metrics|There was an error fetching the environments data, please try again'),
          );
        }
        return response.environments;
      });
  }
}
