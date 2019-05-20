import $ from 'jquery';

import { isScrolledToBottom } from '~/lib/utils/scroll_utils';
import axios from './lib/utils/axios_utils';

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
    const url = `/${gon.project_full_path}/commit/${gon.commit_sha}/diff_for_paths`;
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
        }
      });
  }
}
