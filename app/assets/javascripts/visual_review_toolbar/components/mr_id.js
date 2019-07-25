import { nextView } from '../store';
import { MR_ID, MR_ID_BUTTON, localStorage } from '../shared';
import { clearNote, postError } from './note';
import { rememberBox, submitButton } from './form_elements';
import { selectMrBox, selectRemember } from './utils';
import { addForm } from './wrapper';

/* eslint-disable-next-line @gitlab/i18n/no-non-i18n-strings */
const mrLabel = `Enter your merge request ID`;
/* eslint-disable-next-line @gitlab/i18n/no-non-i18n-strings */
const mrRememberText = `Remember this number`;

const mrForm = `
    <div>
      <label for="${MR_ID}" class="gitlab-label">${mrLabel}</label>
      <input class="gitlab-input" type="text" pattern="[1-9][0-9]*" id="${MR_ID}" name="${MR_ID}" placeholder="e.g., 321" aria-required="true">
    </div>
    ${rememberBox(mrRememberText)}
    ${submitButton(MR_ID_BUTTON)}
`;

const storeMR = (id, state) => {
  const rememberMe = selectRemember().checked;

  if (rememberMe) {
    localStorage.setItem('mergeRequestId', id);
  }

  state.mergeRequestId = id;
};

const addMr = state => {
  // Clear any old errors
  clearNote(MR_ID);

  const mrNumber = selectMrBox().value;

  if (!mrNumber) {
    /* eslint-disable-next-line @gitlab/i18n/no-non-i18n-strings */
    postError('Please enter your merge request ID number.', MR_ID);
    return;
  }

  storeMR(mrNumber, state);
  addForm(nextView(state, MR_ID));
};

export { addMr, mrForm };
