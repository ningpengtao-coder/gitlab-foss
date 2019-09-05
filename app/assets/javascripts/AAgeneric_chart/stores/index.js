import Vue from 'vue';
import Vuex from 'vuex';
import dataSourceTest from './modules/generic_chart';

Vue.use(Vuex);

export const createStore = () =>
  new Vuex.Store({
    modules: {
      dataSource: dataSourceTest(),
    },
  });

export default createStore();
