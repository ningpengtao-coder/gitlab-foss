import { nextView } from '../store';
import { COMMENT_BOX, LOGOUT } from './constants';
import { clearNote } from './note';
import { buttonClearStyles, selectCommentBox } from './utils';
import { addForm } from './wrapper';
import { changeSelectedMr, selectedMrNote } from './comment_mr_note';
import postComment from './comment_post';

const getSavedComment = () => {
  const { sessionStorage } = window;

  try {
    return sessionStorage.getItem('comment');
  } catch (err) {
    return null;
  }
};

const saveComment = (onFail = () => {}) => {
  const { sessionStorage } = window;
  const currentComment = selectCommentBox();

  // This may be added to any view via top-level beforeunload listener
  // so let's exit if it does not apply
  if (!currentComment) {
    return;
  }

  try {
    if (currentComment.value) {
      sessionStorage.setItem('comment', currentComment.value);
    }
  } catch (err) {
    onFail();
  }
};

const comment = state => {
  const savedComment = getSavedComment(state);

  return `
    <div>
      <textarea id="${COMMENT_BOX}" name="${COMMENT_BOX}" rows="3" placeholder="Enter your feedback or idea" class="gitlab-input" aria-required="true">${savedComment ||
    ''}</textarea>
      ${selectedMrNote(state)}
      <p class="gitlab-metadata-note">Additional metadata will be included: browser, OS, current page, user agent, and viewport dimensions.</p>
    </div>
    <div class="gitlab-button-wrapper">
      <button class="gitlab-button gitlab-button-secondary" style="${buttonClearStyles}" type="button" id="${LOGOUT}"> Log out </button>
      <button class="gitlab-button gitlab-button-success" style="${buttonClearStyles}" type="button" id="gitlab-comment-button"> Send feedback </button>
    </div>
  `;
};

const logoutUser = state => {
  const { localStorage } = window;

  // All the browsers we support have localStorage, so let's silently fail
  // and go on with the rest of the functionality.
  try {
    localStorage.removeItem('token');
    localStorage.removeItem('mergeRequestId');
  } finally {
    state.token = '';
    state.mergeRequestId = '';
  }

  clearNote();
  addForm(nextView(state, COMMENT_BOX));
};

export { changeSelectedMr, comment, logoutUser, postComment, saveComment };
