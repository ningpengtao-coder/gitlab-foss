import Visibility from 'visibilityjs';
import Poll from '~/lib/utils/poll';
import flash from '~/flash';
import CommitPipelineStatus from '~/projects/tree/components/commit_pipeline_status_component.vue';
import { shallowMount } from '@vue/test-utils';
import { getJSONFixture } from '../helpers/fixtures';

jest.mock('~/lib/utils/poll');
jest.mock('visibilityjs');
jest.mock('~/flash');

const mockFetchData = jest.fn();
/* eslint-disable-next-line prefer-arrow-callback */
jest.mock('~/projects/tree/services/commit_pipeline_service', function PipelineService() {
  return jest.fn().mockImplementation(() => ({
    fetchData: mockFetchData.mockReturnValue(Promise.resolve()),
  }));
});

describe('Commit pipeline status component', () => {
  let wrapper;
  const { pipelines } = getJSONFixture('pipelines/pipelines.json');
  const { status: mockCiStatus } = pipelines[0].details;

  const defaultProps = {
    endpoint: 'endpoint',
  };

  const createComponent = (props = {}) => {
    wrapper = shallowMount(CommitPipelineStatus, {
      propsData: {
        ...defaultProps,
        ...props,
      },
      sync: false,
    });
  };

  afterEach(() => {
    wrapper.destroy();
    wrapper = null;
  });

  describe('Visibility management', () => {
    describe('when component is hidden', () => {
      beforeEach(() => {
        Visibility.hidden.mockReturnValue(true);
        createComponent();
      });

      it('does not start polling', () => {
        const [pollInstance] = Poll.mock.instances;
        expect(pollInstance.makeRequest).not.toHaveBeenCalled();
      });

      it('requests pipeline data', () => {
        expect(mockFetchData).toHaveBeenCalled();
      });
    });

    describe('when component is visible', () => {
      beforeEach(() => {
        Visibility.hidden.mockReturnValue(false);
        createComponent();
      });

      it('starts polling', () => {
        const [pollInstance] = [...Poll.mock.instances].reverse();
        expect(pollInstance.makeRequest).toHaveBeenCalled();
      });
    });

    describe('when component changes its visibility', () => {
      it.each`
        visibility | action
        ${false}   | ${'restart'}
        ${true}    | ${'stop'}
      `(
        '$action polling when component visibility becomes $visibility',
        ({ visibility, action }) => {
          Visibility.hidden.mockReturnValue(!visibility);
          createComponent();
          Visibility.hidden.mockReturnValue(visibility);
          const [visibilityHandler] = Visibility.change.mock.calls[0];
          visibilityHandler();
          const [pollInstance] = Poll.mock.instances;
          expect(pollInstance[action]).toHaveBeenCalled();
        },
      );
    });
  });

  it('stops polling when component is destroyed', () => {
    createComponent();
    wrapper.destroy();
    const [pollInstance] = Poll.mock.instances;
    expect(pollInstance.stop).toHaveBeenCalled();
  });

  describe('when polling', () => {
    let pollConfig;
    beforeEach(() => {
      Poll.mockImplementation(config => {
        pollConfig = config;
        return { makeRequest: jest.fn(), restart: jest.fn(), stop: jest.fn() };
      });
      createComponent();
    });

    describe('is successful', () => {
      beforeEach(() => {
        pollConfig.successCallback({
          data: { pipelines: [...pipelines[0]] },
        });
        return wrapper.vm.$nextTick();
      });

      it('renders CI icon without loader', () => {
        expect(wrapper.element).toMatchSnapshot();
      });
    });

    describe('is not successful', () => {
      beforeEach(() => {
        pollConfig.errorCallback();
      });

      it('renders not found CI icon without loader', () => {
        expect(wrapper.element).toMatchSnapshot();
      });

      it('displays flash error message', () => {
        expect(flash).toHaveBeenCalled();
      });
    });
  });
});
