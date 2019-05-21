import axios from '~/lib/utils/axios_utils';
import MockAdapter from 'axios-mock-adapter';
import store from '~/monitoring/stores';
import * as types from '~/monitoring/stores/mutation_types';
import {
  fetchDeploymentsData,
  fetchEnvironmentsData,
  requestMetricsData,
  setMetricsEndpoint,
  setEnvironmentsEndpoint,
  setDeploymentsEndpoint,
  setGettingStartedEmptyState,
} from '~/monitoring/stores/actions';
import storeState from '~/monitoring/stores/state';
import testAction from 'spec/helpers/vuex_action_helper';
import { resetStore } from '../helpers';
import { deploymentData, environmentData } from '../mock_data';

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
      const { state } = store;

      requestMetricsData({ state, commit });

      expect(commit).toHaveBeenCalledWith(types.REQUEST_METRICS_DATA);
    });
  });

  describe('fetchDeploymentsData', () => {
    it('commits RECEIVE_DEPLOYMENTS_DATA_SUCCESS on error', done => {
      const commit = jasmine.createSpy();
      const { state } = store;
      state.deploymentEndpoint = '/success';

      mock.onGet(state.deploymentEndpoint).reply(200, {
        deployments: deploymentData,
      });

      fetchDeploymentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(
            types.RECEIVE_DEPLOYMENTS_DATA_SUCCESS,
            deploymentData,
          );
          done();
        })
        .catch(done.fail);
    });

    it('commits RECEIVE_DEPLOYMENTS_DATA_FAILURE on error', done => {
      const commit = jasmine.createSpy();
      const { state } = store;
      state.deploymentEndpoint = '/error';

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
    it('commits RECEIVE_ENVIRONMENTS_DATA_SUCCESS on error', done => {
      const commit = jasmine.createSpy();
      const { state } = store;
      state.environmentsEndpoint = '/success';

      mock.onGet(state.environmentsEndpoint).reply(200, {
        environments: environmentData,
      });

      fetchEnvironmentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(
            types.RECEIVE_ENVIRONMENTS_DATA_SUCCESS,
            environmentData,
          );
          done();
        })
        .catch(done.fail);
    });

    it('commits RECEIVE_ENVIRONMENTS_DATA_FAILURE on error', done => {
      const commit = jasmine.createSpy();
      const { state } = store;
      state.environmentsEndpoint = '/error';

      mock.onGet(state.environmentsEndpoint).reply(500);

      fetchEnvironmentsData({ state, commit })
        .then(() => {
          expect(commit).toHaveBeenCalledWith(types.RECEIVE_ENVIRONMENTS_DATA_FAILURE);
          done();
        })
        .catch(done.fail);
    });
  });

  describe('Set endpoints', () => {
    let mockedState;

    beforeEach(() => {
      mockedState = storeState();
    });

    it('should commit SET_METRICS_ENDPOINT mutation', done => {
      testAction(
        setMetricsEndpoint,
        'additional_metrics.json',
        mockedState,
        [{ type: types.SET_METRICS_ENDPOINT, payload: 'additional_metrics.json' }],
        [],
        done,
      );
    });

    it('should commit SET_ENVIRONMENTS_ENDPOINT mutation', done => {
      testAction(
        setEnvironmentsEndpoint,
        'environments.json',
        mockedState,
        [{ type: types.SET_ENVIRONMENTS_ENDPOINT, payload: 'environments.json' }],
        [],
        done,
      );
    });

    it('should commit SET_DEPLOYMENTS_ENDPOINT mutation', done => {
      testAction(
        setDeploymentsEndpoint,
        'deployments.json',
        mockedState,
        [{ type: types.SET_DEPLOYMENTS_ENDPOINT, payload: 'deployments.json' }],
        [],
        done,
      );
    });
  });

  describe('Set empty states', () => {
    let mockedState;

    beforeEach(() => {
      mockedState = storeState();
    });

    it('should commit SET_METRICS_ENDPOINT mutation', done => {
      testAction(
        setGettingStartedEmptyState,
        null,
        mockedState,
        [{ type: types.SET_GETTING_STARTED_EMPTY_STATE }],
        [],
        done,
      );
    });
  });
});
