import store from '~/monitoring/stores'
import * as types from '~/monitoring/stores/mutation_types';
import testAction from '../../helpers/vuex_action_helper';
import { resetStore } from '../helpers';

describe('Monitoring store actions', () => {
  afterEach(() => {
    resetStore(store);
  });

  describe('requestMetricsData', () => {
    it('sets emptyState to loading', done => {
      store
        .dispatch('requestMetricsData')
        .then(() => {
          expect(store.state.emptyState).toEqual('loading');
          expect(store.state.showEmptyState).toBeTruthy();
          done();
        })
        .catch(done.fail);
    });
  });
});
