import Vue from 'vue';
import Vuex from 'vuex';
import dataSourceTest from './modules/issue_analytics';

Vue.use(Vuex);

export const createStore = () =>
  new Vuex.Store({
    modules: {
      dataSource: dataSourceTest(),
    },
  });

export default createStore();
