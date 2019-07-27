import Vue from 'vue';
import store from '~/mr_notes/stores';
import DiffExpansionCell from '~/diffs/components/diff_expansion_cell.vue';
import { createComponentWithStore } from 'spec/helpers/vue_mount_component_helper';
import diffFileMockData from '../mock_data/diff_file';

const EXPAND_UP_TEXT = 'Expand Up';
const EXPAND_DOWN_TEXT = 'Expand Down';
const EXPAND_ALL_TEXT = 'Show';

describe('DiffExpansionCell', () => {
  const matchLine = diffFileMockData.highlighted_diff_lines[5];

  const createComponent = (options = {}) => {
    const cmp = Vue.extend(DiffExpansionCell);
    const defaults = {
      fileHash: diffFileMockData.file_hash,
      contextLinesPath: 'contextLinesPath',
      line: matchLine,
      isTop: false,
      isBottom: false,
    };
    const props = Object.assign({}, defaults, options);

    return createComponentWithStore(cmp, store, props).$mount();
  };

  describe('top row', () => {
    it('should have "expand up" and "show all" option', () => {
      const vm = createComponent({
        isTop: true,
      });
      const el = vm.$el;

      expect(el.innerText.includes(EXPAND_UP_TEXT)).toBe(true);
      expect(el.innerText.includes(EXPAND_ALL_TEXT)).toBe(true);
      expect(el.innerText.includes(EXPAND_DOWN_TEXT)).toBe(false);
    });

    it('should expand to top of lines when "show all" is clicked', () => {});
  });

  describe('middle row', () => {
    it('should have "expand down", "show all", "expand up" option', () => {
      const vm = createComponent();
      const el = vm.$el;

      expect(el.innerText.includes(EXPAND_UP_TEXT)).toBe(true);
      expect(el.innerText.includes(EXPAND_ALL_TEXT)).toBe(true);
      expect(el.innerText.includes(EXPAND_DOWN_TEXT)).toBe(true);
    });

    it('should expand upwards when "expand up" is clicked', () => {});

    it('should expnd downwards when "expand down" is clicked', () => {});

    it('should expand to end of lines when "show all" is clicked', () => {});
  });

  describe('bottom row', () => {
    it('should have "expand down" and "show all" option', () => {
      const vm = createComponent({
        isBottom: true,
      });
      const el = vm.$el;

      expect(el.innerText.includes(EXPAND_UP_TEXT)).toBe(false);
      expect(el.innerText.includes(EXPAND_ALL_TEXT)).toBe(true);
      expect(el.innerText.includes(EXPAND_DOWN_TEXT)).toBe(true);
    });

    it('should expand to end of lines when "show all" is clicked', () => {});

    it('should expnd downwards when "expand down" is clicked', () => {});
  });
});
