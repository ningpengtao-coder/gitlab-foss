<script>
import createFlash from '~/flash';
import { s__ } from '~/locale';
import { mapState, mapActions } from 'vuex';
import Icon from '~/vue_shared/components/icon.vue';
import { MATCH_LINE_TYPE, UNFOLD_COUNT } from '../constants';
import * as utils from '../store/utils';

export default {
  components: {
    Icon,
  },
  props: {
    fileHash: {
      type: String,
      required: true,
    },
    contextLinesPath: {
      type: String,
      required: true,
    },
    line: {
      type: Object,
      required: true,
    },
    isTop: {
      type: Boolean,
      required: false,
      default: false,
    },
    isBottom: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  computed: {
    ...mapState({
      diffViewType: state => state.diffs.diffViewType,
      diffFiles: state => state.diffs.diffFiles,
    }),
    isMatchLine() {
      return this.line.type === MATCH_LINE_TYPE;
    },
    canExpandUp() {
      return !this.isBottom;
    },
    canExpandDown() {
      return this.isBottom || !this.isTop;
    },
  },
  methods: {
    ...mapActions('diffs', ['loadMoreLines']),
    handleExpandUpLines() {
      if (this.isRequesting) {
        return;
      }

      this.isRequesting = true;
      const endpoint = this.contextLinesPath;
      const oldLineNumber = this.line.meta_data.old_pos || 0;
      const newLineNumber = this.line.meta_data.new_pos || 0;
      const offset = newLineNumber - oldLineNumber;
      const bottom = this.isBottom;
      const { fileHash } = this;
      const view = this.diffViewType;
      // LET
      let unfold = true;
      const lineNumber = newLineNumber - 1;
      let since = lineNumber - UNFOLD_COUNT;
      const to = lineNumber;

      const diffFile = utils.findDiffFile(this.diffFiles, this.fileHash);
      const indexForInline = utils.findIndexInInlineLines(diffFile.highlighted_diff_lines, {
        oldLineNumber,
        newLineNumber,
      });
      const prevLine = diffFile.highlighted_diff_lines[indexForInline - 2];
      const prevLineNumber = (prevLine && prevLine.new_line) || 0;

      if (since <= prevLineNumber + 1) {
        since = prevLineNumber + 1;
        unfold = false;
      }

      const params = { since, to, bottom, offset, unfold, view };
      const lineNumbers = { oldLineNumber, newLineNumber };

      console.log('params', params);
      console.log('lineNumbers', lineNumbers);

      this.loadMoreLines({ endpoint, params, lineNumbers, fileHash })
        .then(() => {
          this.isRequesting = false;
        })
        .catch(() => {
          createFlash(s__('Diffs|Something went wrong while fetching diff lines.'));
          this.isRequesting = false;
        });
    },
    handleShowAllLines() {
      console.log('%c===============', 'color:DodgerBlue');
      // if (this.isRequesting) {
      //   return;
      // }

      this.isRequesting = true;
      const endpoint = this.contextLinesPath;
      let oldLineNumber = this.line.meta_data.old_pos || 0;
      let newLineNumber = this.line.meta_data.new_pos || 0;
      const offset = newLineNumber - oldLineNumber;
      const bottom = this.isBottom;
      const { fileHash } = this;
      const view = this.diffViewType;
      const unfold = false;
      // Yes Bottom
      const lineNumber = newLineNumber + 1;
      let since = lineNumber;
      let to = 'some number???'; // how to get the last

      if (!bottom) {
        // Do some logic to find "prevLineNumber"
        const diffFile = utils.findDiffFile(this.diffFiles, this.fileHash);
        const indexForInline = utils.findIndexInInlineLines(diffFile.highlighted_diff_lines, {
          oldLineNumber,
          newLineNumber,
        });
        const prevLine = diffFile.highlighted_diff_lines[indexForInline - 2];
        const prevLineNumber = (prevLine && prevLine.new_line) || 0;

        since = prevLineNumber + 1;
        to = newLineNumber - 1;

        // This will adjust it to be the top:
        newLineNumber = prevLineNumber;
        oldLineNumber = prevLineNumber - offset;
      }

      const params = { since, to, bottom, offset, unfold, view };
      const lineNumbers = { oldLineNumber, newLineNumber };

      console.log('params', params);
      console.log('lineNumbers', lineNumbers);

      // this.loadMoreLines({ endpoint, params, lineNumbers, fileHash })
      //   .then(() => {
      //     this.isRequesting = false;
      //   })
      //   .catch(() => {
      //     createFlash(s__('Diffs|Something went wrong while fetching diff lines.'));
      //     this.isRequesting = false;
      //   });
    },
    handleExpandDownLines() {
      console.log('%c===============', 'color:DodgerBlue');
      // if (this.isRequesting) {
      //   return;
      // }

      this.isRequesting = true;
      const endpoint = this.contextLinesPath;
      let oldLineNumber = this.line.meta_data.old_pos || 0;
      let newLineNumber = this.line.meta_data.new_pos || 0;
      const offset = newLineNumber - oldLineNumber;
      const bottom = this.isBottom;
      const { fileHash } = this;
      const view = this.diffViewType;
      // LET
      let unfold = true;

      // YES bottom
      let lineNumber = newLineNumber + 1;
      let since = lineNumber;
      let to = lineNumber + UNFOLD_COUNT;

      // NOT bottom
      if (!bottom) {
        console.log('if(!bottom) >> bottom:', bottom);
        // Do some logic to find "prevLineNumber"
        const diffFile = utils.findDiffFile(this.diffFiles, this.fileHash);
        const indexForInline = utils.findIndexInInlineLines(diffFile.highlighted_diff_lines, {
          oldLineNumber,
          newLineNumber,
        });
        const prevLine = diffFile.highlighted_diff_lines[indexForInline - 2];
        const prevLineNumber = (prevLine && prevLine.new_line) || 0;

        console.log('prevLine', prevLine);
        console.log('prevLineNumber', prevLineNumber);

        // This will adjust it to be the top:
        newLineNumber = prevLineNumber;
        oldLineNumber = prevLineNumber - offset;

        lineNumber = prevLineNumber + 1;
        since = lineNumber;
        to = lineNumber + UNFOLD_COUNT;

        if (to >= this.line.meta_data.new_pos) {
          to = this.line.meta_data.new_pos - 1;
          unfold = false;
        }
      }

      const params = { since, to, bottom, offset, unfold, view };
      const lineNumbers = { oldLineNumber, newLineNumber };

      console.log('params', params);
      console.log('lineNumbers', lineNumbers);

      // this.loadMoreLines({ endpoint, params, lineNumbers, fileHash })
      //   .then(() => {
      //     this.isRequesting = false;
      //   })
      //   .catch(() => {
      //     createFlash(s__('Diffs|Something went wrong while fetching diff lines.'));
      //     this.isRequesting = false;
      //   });
    },
  },
};
</script>

<template>
  <tr v-if="isMatchLine" class="line_expansion">
    <td colspan="3">
      <div class="content">
        <a v-if="canExpandUp" @click="handleExpandUpLines" class="cursor-pointer">
          <icon
            :size="12"
            name="expand-left"
            aria-hidden="true"
            style="transform: rotate(270deg);"
          />
          <span>Expand Up</span>
        </a>
        <a class="mx-2 cursor-pointer" @click="handleShowAllLines">
          <span>Show all</span>
        </a>
        <a v-if="canExpandDown" class="cursor-pointer" @click="handleExpandDownLines">
          <icon
            :size="12"
            name="expand-left"
            aria-hidden="true"
            style="transform: rotate(90deg);"
          />
          <span>Expand Down</span>
        </a>
      </div>
    </td>
  </tr>
</template>
