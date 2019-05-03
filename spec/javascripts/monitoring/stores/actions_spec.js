import axios from '~/lib/utils/axios_utils';
import MockAdapter from 'axios-mock-adapter';
import store from '~/monitoring/stores'
import * as types from '~/monitoring/stores/mutation_types';
import { resetStore } from '../helpers';
import MonitoringMock, { deploymentData, environmentData } from '../mock_data';
import {
  fetchDeploymentsData,
  fetchEnvironmentsData,
  requestMetricsData,
} from '~/monitoring/stores/actions';

describe('Monitoring store actions', () => {
  let mock;

  beforeEach(() => {
    mock = new MockAdapter(axios);
  });

  afterEach(() => {
    resetStore(store);
    mock.restore();
  });

  describe('requestMetricsData', () => {
    it('sets emptyState to loading', () => {
      const commit = jasmine.createSpy();
      const state = store.state;

      requestMetricsData({ state, commit });

      expect(commit).toHaveBeenCalledWith(types.REQUEST_METRICS_DATA);
    });
  });

  describe('fetchDeploymentsData', () => {
    it('commits RECEIVE_DEPLOYMENTS_DATA_SUCCESS on error', (done) => {
      const commit = jasmine.createSpy();
      const state = store.state;
      state.deploymentEndpoint = '/success'

      mock.onGet(state.deploymentEndpoint).reply(200, {
        deployments: deploymentData,
      });

      fetchDeploymentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(types.RECEIVE_DEPLOYMENTS_DATA_SUCCESS, deploymentData);
          done();
        })
        .catch(done.fail);
    });

    it('commits RECEIVE_DEPLOYMENTS_DATA_FAILURE on error', (done) => {
      const commit = jasmine.createSpy();
      const state = store.state;
      state.deploymentEndpoint = '/error'

      mock.onGet(state.deploymentEndpoint).reply(500);

      fetchDeploymentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(types.RECEIVE_DEPLOYMENTS_DATA_FAILURE);
          done();
        })
        .catch(done.fail);
    });
  });

  describe('fetchEnvironmentsData', () => {
    it('commits RECEIVE_ENVIRONMENTS_DATA_SUCCESS on error', (done) => {
      const commit = jasmine.createSpy();
      const state = store.state;
      state.environmentsEndpoint = '/success'

      mock.onGet(state.environmentsEndpoint).reply(200, {
        environments: environmentData,
      });

      fetchEnvironmentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(types.RECEIVE_ENVIRONMENTS_DATA_SUCCESS, environmentData);
          done();
        })
        .catch(done.fail);
    });

    it('commits RECEIVE_ENVIRONMENTS_DATA_FAILURE on error', (done) => {
      const commit = jasmine.createSpy();
      const state = store.state;
      state.environmentsEndpoint = '/error'

      mock.onGet(state.environmentsEndpoint).reply(500);

      fetchEnvironmentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(types.RECEIVE_ENVIRONMENTS_DATA_FAILURE);
          done();
        })
        .catch(done.fail);
    });
  });
});
