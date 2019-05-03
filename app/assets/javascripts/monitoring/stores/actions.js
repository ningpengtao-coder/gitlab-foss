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

export const setDeploymentsEndpoint = ({ commit }, deploymentsEndpoint) => {
  commit(types.SET_DEPLOYMENTS_ENDPOINT, deploymentsEndpoint);
};

export const setEnvironmentsEndpoint = ({ commit }, environmentsEndpoint) => {
  commit(types.SET_ENVIRONMENTS_ENDPOINT, environmentsEndpoint);
};

export const requestMetricsData = ({ commit }) => commit(types.REQUEST_METRICS_DATA);
export const receiveMetricsDataSuccess = ({ commit }, data) =>
  commit(types.RECEIVE_METRICS_DATA_SUCCESS, data);
export const receiveMetricsDataFailure = ({ commit }, error) =>
  commit(types.RECEIVE_METRICS_DATA_FAILURE, error);

export const fetchMetricsData = ({ state, dispatch }, params) => {
  dispatch('requestMetricsData');

  return backOffRequest(() => axios.get(state.metricsEndpoint, { params }))
    .then(resp => resp.data)
    .then(response => {
      if (!response || !response.data || !response.success) {
        dispatch('receiveMetricsDataFailure', null);
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
export const fetchPrometheusMetric = ({ commit, getters }, metric) => {
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

  prom(prometheusEndpoint, params).then(result => {
    commit(types.SET_QUERY_RESULT, { metricId: metric.metric_id, result });
  })
}

function prom(prometheusEndpoint, params) {
  return backOffRequest(() => axios.get(prometheusEndpoint, { params }))
    .then(res => res.data)
    .then(response => {
      if (response.status === 'error') {
        // {"status":"error","errorType":"bad_data","error":"exceeded maximum resolution of 11,000 points per timeseries. Try decreasing the query resolution (?step=XX)"}
      }

      const { resultType, result } = response.data;

      if (resultType === 'matrix') {
        if (result.length > 0) {
          return result
        }
      }
  });
}

export const fetchDeploymentsData = ({ state, commit }) => {
  if (!state.deploymentEndpoint) {
    return Promise.resolve([]);
  }
  return backOffRequest(() => axios.get(state.deploymentEndpoint))
    .then(resp => resp.data)
    .then(response => {
      if (!response || !response.deployments) {
        createFlash(s__('Metrics|Unexpected deployment data response from prometheus endpoint'));
      }

      commit(types.RECEIVE_DEPLOYMENTS_DATA_SUCCESS, response.deployments);
    })
    .catch(() => {
      commit(types.RECEIVE_DEPLOYMENTS_DATA_FAILURE);
      createFlash(s__('Metrics|There was an error getting deployment information.'));
    });
};

export const fetchEnvironmentsData = ({ state, commit }) => {
  if (!state.environmentsEndpoint) {
    return Promise.resolve([]);
  }
  return axios
    .get(state.environmentsEndpoint)
    .then(resp => resp.data)
    .then(response => {
      if (!response || !response.environments) {
        createFlash(
          s__('Metrics|There was an error fetching the environments data, please try again'),
        );
      }
      commit(types.RECEIVE_ENVIRONMENTS_DATA_SUCCESS, response.environments);
    })
    .catch(() => {
      commit(types.RECEIVE_ENVIRONMENTS_DATA_FAILURE);
      createFlash(s__('Metrics|There was an error getting environments information.'));
    });
};

// prevent babel-plugin-rewire from generating an invalid default during karma tests
export default () => {};
