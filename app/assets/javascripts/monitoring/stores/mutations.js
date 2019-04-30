import * as types from './mutation_types';

export default {
  // I understand now
  [types.REQUEST_METRICS_DATA](state) {
    state.emptyState = 'loading';
    state.showEmptyState = true;
  },
  [types.RECEIVE_METRICS_DATA_SUCCESS](state, data) {
    state.groups = data; // TODO: Transform the data from the backend response
    state.showEmptyState = false;
  },
  [types.RECEIVE_METRICS_DATA_FAILURE](state, error) {
    state.emptyState = error ? 'unableToConnect' : 'noData'; // TODO: use error to deterine the appropiately determine which empty state to use
    state.showEmptyState = true;
  },
};
