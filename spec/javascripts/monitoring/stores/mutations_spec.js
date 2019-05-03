import mutations from '~/monitoring/stores/mutations';
import * as types from '~/monitoring/stores/mutation_types';
import state from '~/monitoring/stores/state';
import { metricsGroupsAPIResponse } from '../mock_data';

describe('Monitoring mutations', () => {
  let stateCopy;

  beforeEach(() => {
    stateCopy = state();
  });

  describe(types.RECEIVE_METRICS_DATA_SUCCESS, () => {
    it('normalizes values', () => {
      stateCopy.groups = [];
      const groups = metricsGroupsAPIResponse.data;

      mutations[types.RECEIVE_METRICS_DATA_SUCCESS](stateCopy, groups);

      const expectedTimestamp = '2017-05-25T08:22:34.925Z';
      const expectedValue = 0.0010794445585559514;
      const [timestamp, value] = stateCopy.groups[0].metrics[0].queries[0].result[0].values[0];

      expect(timestamp).toEqual(expectedTimestamp);
      expect(value).toEqual(expectedValue);
    });
  });

  describe('SET_X_ENDPOINT', () => {
    it('should set the metrics endpoint', () => {
      mutations[types.SET_METRICS_ENDPOINT](stateCopy, 'additional_metrics.json');

      expect(stateCopy.metricsEndpoint).toEqual('additional_metrics.json');
    });

    it('should set the environments endpoint', () => {
      mutations[types.SET_ENVIRONMENTS_ENDPOINT](stateCopy, 'environments.json');

      expect(stateCopy.environmentsEndpoint).toEqual('environments.json');
    });

    it('should set the deployments endpoint', () => {
      mutations[types.SET_DEPLOYMENTS_ENDPOINT](stateCopy, 'deployments.json');

      expect(stateCopy.deploymentsEndpoint).toEqual('deployments.json');
    });
  });
});
