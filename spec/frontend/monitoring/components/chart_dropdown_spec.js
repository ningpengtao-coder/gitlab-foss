import MonitorChartDropdown from '~/monitoring/components/chart_dropdown.vue';
import { shallowMount } from '@vue/test-utils';
import { TEST_HOST } from 'helpers/test_constants';

describe('Chart Dropdown component', () => {
  const glModal = jest.fn((el, binding) => binding.value);
  let originalCreateObjectURL;
  let dropdown;

  beforeAll(() => {
    // createObjectURL is not available yet in jsdom, but support is on the way
    // see https://github.com/jsdom/jsdom/issues/1721
    originalCreateObjectURL = window.URL.createObjectURL;
    window.URL.createObjectURL = window.URL.createObjectURL || (() => {});
  });

  beforeEach(() => {
    dropdown = shallowMount(MonitorChartDropdown, {
      directives: {
        'gl-modal': glModal,
      },
      mocks: {
        $toast: {
          show: jest.fn(),
        },
      },
    });
  });

  it('renders', () => {
    expect(dropdown.exists()).toBe(true);
    expect(dropdown.isVueInstance()).toBe(true);
  });

  describe('csv download link', () => {
    const csvText = 'MOCK_CSV_TEXT';

    beforeEach(() => {
      jest.spyOn(window.URL, 'createObjectURL').mockReturnValue(`blob:${csvText}`);
      dropdown.setProps({ csvText });
    });

    it('is displayed', () => {
      const csvLinkComp = dropdown.find('.js-csv-dl-link');
      expect(csvLinkComp.isVueInstance()).toBe(true);
      expect(csvLinkComp.isEmpty()).toBe(false);
      expect(csvLinkComp.attributes('href')).toEqual(`blob:${csvText}`);
    });

    afterEach(() => {
      dropdown.setProps({ csvText: undefined });
      window.URL.createObjectURL.mockRestore();
    });
  });

  describe('chart link', () => {
    const chartUrl = `${TEST_HOST}/chart`;
    let chartLink;

    beforeEach(() => {
      dropdown.setProps({ chartLink: chartUrl });
      chartLink = dropdown.find('.js-chart-link');
      jest.spyOn(dropdown.vm.$toast, 'show');
    });

    it('is displayed', () => {
      expect(chartLink.isVueInstance()).toBe(true);
      expect(chartLink.isEmpty()).toBe(false);
      expect(chartLink.attributes('data-clipboard-text')).toEqual(chartUrl);
    });

    it('shows a toast on click', () => {
      chartLink.vm.$emit('click');
      expect(dropdown.vm.$toast.show).toHaveBeenCalled();
    });

    afterEach(() => {
      dropdown.vm.$toast.show.mockReset();
      dropdown.setProps({ csvText: undefined });
    });
  });

  describe('alert link', () => {
    const alertModalId = `modal-1-2`;
    let alertLink;

    beforeEach(() => {
      glModal.mockClear();
      dropdown.setProps({ alertModalId });
      alertLink = dropdown.find('.js-alert-link');
    });

    it('is displayed', () => {
      expect(alertLink.isVueInstance()).toBe(true);
      expect(alertLink.isEmpty()).toBe(false);
    });

    it('can open a modal with correct id', () => {
      expect(glModal).toHaveReturnedWith(alertModalId);
    });

    afterEach(() => {
      dropdown.setProps({ alertModalId: undefined });
    });
  });

  afterAll(() => {
    window.URL.createObjectURL = originalCreateObjectURL;
  });
});
