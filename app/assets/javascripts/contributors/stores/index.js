import Vue from 'vue';
import Vuex from 'vuex';
import contributorsGraph from './modules/contributors';

Vue.use(Vuex);

export const createStore = () =>
  new Vuex.Store({
    modules: {
      contributors: contributorsGraph(),
    },
  });

export default createStore();
