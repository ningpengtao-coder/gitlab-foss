import Visibility from 'visibilityjs';
import Poll from '~/lib/utils/poll';
import flash from '~/flash';
import CommitPipelineStatus from '~/projects/tree/components/commit_pipeline_status_component.vue';

import { shallowMount } from '@vue/test-utils';

jest.mock('~/lib/utils/poll');
jest.mock('visibilityjs');
jest.mock('~/flash');
/* eslint-disable-next-line prefer-arrow-callback */
jest.mock('~/projects/tree/services/commit_pipeline_service', function PipelineService() {
  return jest.fn().mockImplementation(() => ({
    fetchData: jest.fn().mockReturnValue(Promise.resolve()),
  }));
});

describe('Commit pipeline status component', () => {
  let wrapper;
  const mockCiStatus = {
    details_path: '/root/hello-world/pipelines/1',
    favicon: 'canceled.ico',
    group: 'canceled',
    has_details: true,
    icon: 'status_canceled',
    label: 'canceled',
    text: 'canceled',
  };

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

  beforeEach(() => {});

  afterEach(() => {
    jest.clearAllMocks();
    if (wrapper) {
      wrapper.destroy();
      wrapper = null;
    }
  });

  afterAll(() => {
    jest.restoreAllMocks();
  });

  describe('Visibility management', () => {
    describe('when component is hidden', () => {
      beforeEach(() => {
        Visibility.hidden.mockReturnValue(true);
        createComponent();
      });

      it('does not starts polling', () => {
        const [pollInstance] = Poll.mock.instances;
        expect(pollInstance.makeRequest).not.toHaveBeenCalled();
      });

      it('requests pipeline data', () => {
        const [pollInstance] = Poll.mock.instances;
        expect(pollInstance.makeRequest).not.toHaveBeenCalled();
      });
    });

    describe('when component is visible', () => {
      beforeEach(() => {
        Visibility.hidden.mockReturnValue(false);
        createComponent();
      });

      it('starts polling', () => {
        const [pollInstance] = Poll.mock.instances;
        expect(pollInstance.makeRequest).toHaveBeenCalled();
      });
    });

    describe('when component changes its visibility', () => {
      let visibilityHandler;
      beforeEach(() => {
        Visibility.change.mockImplementation(handler => {
          visibilityHandler = handler;
        });
      });

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

    afterEach(() => {
      Poll.mockReset();
    });

    describe('is successful', () => {
      beforeEach(() => {
        pollConfig.successCallback({
          data: { pipelines: [{ details: { status: mockCiStatus } }] },
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
