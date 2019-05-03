import mutations from '~/monitoring/stores/mutations';
import * as types from '~/monitoring/stores/mutation_types';
import { metricsGroupsAPIResponse } from '../mock_data';

describe('Monitoring mutations', () => {
  describe(types.RECEIVE_METRICS_DATA_SUCCESS, () => {
    it('normalizes values', () => {
      const state = {
        groups: [],
      };
      const groups = metricsGroupsAPIResponse.data;

      mutations[types.RECEIVE_METRICS_DATA_SUCCESS](state, groups);

      const expectedTimestamp = '2017-05-25T08:22:34.925Z';
      const expectedValue = 0.0010794445585559514;
      const [timestamp, value] = state.groups[0].metrics[0].queries[0].result[0].values[0];

      expect(timestamp).toEqual(expectedTimestamp);
      expect(value).toEqual(expectedValue);
    });
  });
});
