import * as types from './mutation_types';

export default {
  [types.SET_LOADING_STATE](state, value) {
    state.loading = value;
  },
  [types.SET_CHART_DATA](state, chartData) {
    Object.assign(state, {
      chartData,
    });
  },
  [types.SET_USER_JSON](state, userJson) {
    Object.assign(state, {
      userJson: JSON.stringify(userJson.data),
    });
  },
  [types.SET_FILTERS](state, value) {
    state.filters = value;
  },
};
