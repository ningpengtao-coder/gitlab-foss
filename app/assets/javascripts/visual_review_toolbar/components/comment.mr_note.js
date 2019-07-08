import { nextView } from '../store'
import { CHANGE_MR_ID_BUTTON, COMMENT_BOX } from './constants';
import { clearNote, postError } from './note';
import { buttonClearStyles, selectCommentBox } from './utils';
import { addForm } from './wrapper';

const selectedMrNote = (state) => {

  const {
    mrUrl,
    projectPath,
    mergeRequestId
  } = state;

  const mrLink = `${mrUrl}/${projectPath}/merge_requests/${mergeRequestId}`;

  return `
    <p class="gitlab-metadata-note">
      This posts to merge request <a class="gitlab-link" href="${mrLink}">!${mergeRequestId}</a>.
      <button style="${buttonClearStyles}" type="button" id="${CHANGE_MR_ID_BUTTON}" class="gitlab-link gitlab-link-button">Change</button>
    </p>
  `;
}

const changeSelectedMr = (state) => {
  const { localStorage, sessionStorage } = window;
  const currentComment = selectCommentBox().value;

  // All the browsers we support have localStorage, so let's silently fail
  // and go on with the rest of the functionality.
  try {
    localStorage.removeItem('mergeRequestId');

    if (currentComment) {
      sessionStorage.setItem('comment', currentComment)
    }
  } finally {
    state.mergeRequestId = '';
  }

  clearNote();
  addForm(nextView(state, COMMENT_BOX));
}

export { changeSelectedMr, selectedMrNote }
