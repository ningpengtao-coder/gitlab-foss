import * as types from './mutation_types';
import axios from '~/lib/utils/axios_utils';
import createFlash from '~/flash';
import statusCodes from '../../lib/utils/http_status';
import { backOff } from '../../lib/utils/common_utils';
import { s__, __ } from '../../locale';

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
            stop(new Error(__('Failed to connect to the prometheus server')));
          }
        } else {
          stop(resp);
        }
      })
      .catch(stop);
  });
}

export const setDashboardEndpoint = ({ commit }, endpoint) => {
  commit(types.SET_DASHBOARD_ENDPOINT, endpoint);
}

export const setMetricsEndpoint = ({ commit }, metricsEndpoint) => {
  commit(types.SET_METRICS_ENDPOINT, metricsEndpoint);
}

// requestSomething should commit the mutations
export const requestMetricsData = () => ({ commit }) => commit(types.REQUEST_METRICS_DATA);
// receiveSuccess and receiveError as callbacks for the fetchSomething function
export const receiveMetricsDataSuccess = ({ commit }, data) =>
  commit(types.RECEIVE_METRICS_DATA_SUCCESS, data);
export const receiveMetricsDataFailure = ({ commit }, error) =>
  commit(types.RECEIVE_METRICS_DATA_FAILURE, error);

// fetchSomething are the actions that need to be exposed to the user
export const fetchMetricsData = ({ state, dispatch }, params) => {
  return backOffRequest(() => axios.get(state.metricsEndpoint, { params })) // TODO: Check if passing params is defined as a state or part of the exposed function
    .then(resp => resp.data)
    .then(response => {
      if (!response || !response.data || !response.success) {
        dispatch('receiveMetricsDataFailure', {}); // TODO: Do we send and error?
        createFlash(s__('Metrics|Unexpected metrics data response from prometheus endpoint'));
      }
      dispatch('receiveMetricsDataSuccess', response.data);
    })
    .catch(error => {
      dispatch('receiveMetricsDataFailure', error); // TODO: Do we send and error?
    });
};


export const fetchDashboard = ({ state, commit, dispatch }, params) => {
  return axios
    .get(state.dashboardEndpoint, { params })
    .then(resp => resp.data)
    .then(response => {
      if (!response || response.status !== 'success') {
        throw new Error(s__('Metrics|Unexpected metrics data response from prometheus endpoint'));
      }

      commit(types.SET_GROUPS, response.dashboard.panel_groups);
      dispatch('fetchPrometheusMetrics');
    })
    .catch((e) => {
      throw e;
    });
}

export const fetchPrometheusMetrics = ({ state, dispatch }) => {
  state.groups.forEach(group => {
    group.panels.forEach(panel => {
      panel.queries = panel.metrics;
      panel.queries.forEach(metric => {
        dispatch('fetchPrometheusMetric', metric);
      });
    });
  })
}

/**
   * Returns list of metrics in data.result
   * {"status":"success", "data":{"resultType":"matrix","result":[]}}
   * 
   * @param {metric} metric 
   */
export const fetchPrometheusMetric = ({ commit }, metric) => {
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

      const { resultType, result } = response.data;

      if (resultType === 'matrix') {
        if (result.length > 0) {
          // TODO: maybe use Object.freeze here since results don't need to be reactive
          commit(types.SET_QUERY_RESULT, { metricId: metric.metric_id, result });
        }
      }
    // .then(res => {
    // if (res.resultType === 'matrix') {
    //   if (res.result.length > 0) {
    //     panel.queries[0].result = res.result;
    //     panel.queries[0].metricId = panel.queries[0].metric_id;

  });
}
