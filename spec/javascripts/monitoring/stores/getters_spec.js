import * as getters from '~/monitoring/stores/getters';
import state from '~/monitoring/stores/state';

describe('Monitoring store getters', () => {
  let localState;

  beforeEach(() => {
    localState = state();
  });

  describe('groups', () => {
    it('returns the current number of groups', () => {
      localState.groups = [
        { id: 1, metrics: [{ query: '' }] },
        { id: 2, metrics: [{ query: '' }] },
      ];

      expect(getters.getMetricsCount(localState)).toEqual(2);
    });
  });
});
