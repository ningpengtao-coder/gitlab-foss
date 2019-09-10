import flash from '~/flash';
import { __ } from '~/locale';
import service from '../../../services/chart_data_service';
import * as types from './mutation_types';


const removeFlashError = () => {
  const flashError = document.querySelector('.flash-container');
  if (flashError) {
    flashError.innerHTML = '';
  }
};

export const setFilters = ({ commit }, value) => {
  commit(types.SET_FILTERS, value);
};

export const setLoadingState = ({ commit }, value) => {
  commit(types.SET_LOADING_STATE, value);
};

export const fetchChartData = ({ commit, dispatch, getters }, url) => {
  dispatch('setLoadingState', true);

  removeFlashError();

  return service
    .fetchChartData(url)
    .then(res => res)
    .then(data => commit(types.SET_CHART_DATA, data))
    .catch(() => {
      commit(types.SET_CHART_DATA, null);
      flash(__('An error occurred while loading chart data'));
      setTimeout(removeFlashError, 2000);
    })
    .finally(() => dispatch('setLoadingState', false));

};

export const setChartData = ({ commit }, data) => {
  commit(types.SET_CHART_DATA, data);
};

// prevent babel-plugin-rewire from generating an invalid default during karma tests
export default () => {};
