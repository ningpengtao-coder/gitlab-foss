import $ from 'jquery';

import { isScrolledToBottom } from '~/lib/utils/scroll_utils';
import axios from './lib/utils/axios_utils';
import syntaxHighlight from './syntax_highlight';
import FilesCommentButton from './files_comment_button';

export default class CommitPageLoader {
  constructor() {
    this.currentBatch = 0;
  }

  bindNextBatchLoader() {
    $(window).on('scroll', () => {
      if (isScrolledToBottom()) {
        this.currentBatch += 1;
        // console.log(`nextBatch: ${this.currentBatch}`);
        this.callDiffForPaths();
      }
    });
  }

  callDiffForPaths() {
    const url = `/${gon.project_full_path}/commit/${gon.commit_sha}/diffs_per_batch`;
    const divID = `.next-batch-section[data-next-batch="${this.currentBatch}"]`;

    return axios
      .get(url, {
        params: {
          batch_number: this.currentBatch,
        },
      })
      .then(({ data }) => {
        if (data.html) {
          $(divID).html(data.html);
          syntaxHighlight($(divID));
          this.bindDiffFiles();
        }
      });
  }

  bindDiffFiles() {
    const divID = `.next-batch-section[data-next-batch="${this.currentBatch}"] .diff-file`;
    const $batchOfFiles = $(divID);

    FilesCommentButton.init($batchOfFiles);
  }
}
