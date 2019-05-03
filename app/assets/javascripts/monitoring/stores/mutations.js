import Vue from 'vue';
import * as types from './mutation_types';
import { normalizeMetrics, sortMetrics } from './utils';

export default {
  [types.REQUEST_METRICS_DATA](state) {
    state.emptyState = 'loading';
    state.showEmptyState = true;
  },
  [types.RECEIVE_METRICS_DATA_SUCCESS](state, groupData) {
    state.groups = groupData.map(group => ({
      ...group,
      metrics: normalizeMetrics(sortMetrics(group.metrics)),
    }));
    if (state.groups.length < 1) {
      state.emptyState = 'noData';
    } else {
      state.showEmptyState = false;
    }
  },
  [types.RECEIVE_METRICS_DATA_FAILURE](state, error) {
    state.emptyState = error ? 'unableToConnect' : 'noData'; // TODO: use error to deterine the appropiately determine which empty state to use
    state.showEmptyState = true;
  },
  [types.SET_DASHBOARD_ENDPOINT](state, endpoint) {
    state.dashboardEndpoint = endpoint;
  },
  [types.RECEIVE_DEPLOYMENTS_DATA_SUCCESS](state, deployments) {
    state.deployments = deployments;
  },
  [types.RECEIVE_DEPLOYMENTS_DATA_FAILURE](state) {
    state.deployments = [];
  },
  [types.RECEIVE_ENVIRONMENTS_DATA_SUCCESS](state, environments) {
    state.environments = environments;
  },
  [types.RECEIVE_ENVIRONMENTS_DATA_FAILURE](state) {
    state.environments = [];
  },
  [types.SET_METRICS_ENDPOINT](state, endpoint) {
    state.metricsEndpoint = endpoint;
  },
  [types.SET_ENVIRONMENTS_ENDPOINT](state, endpoint) {
    state.environmentsEndpoint = endpoint;
  },
  [types.SET_DEPLOYMENTS_ENDPOINT](state, endpoint) {
    state.deploymentsEndpoint = endpoint;
  },
  [types.SET_QUERY_RESULT](state, { metricId, result }) {
    if (!metricId || !result) {
      return;
    }
    Vue.set(state.queryResults, metricId, Object.freeze(result));
    state.showEmptyState = false;
  },
  [types.SET_GROUPS](state, groups) {
    state.groups = groups;
  },
};
