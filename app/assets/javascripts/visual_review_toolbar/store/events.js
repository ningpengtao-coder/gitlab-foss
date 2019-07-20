import {
  addMr,
  authorizeUser,
  changeSelectedMr,
  logoutUser,
  postComment,
  saveComment,
  toggleForm,
  CHANGE_MR_ID_BUTTON,
  COLLAPSE_BUTTON,
  COMMENT_BUTTON,
  LOGIN,
  LOGOUT,
  MR_ID_BUTTON,
} from '../components';

import { state } from './state';
import debounce from './utils';

const noop = () => {};

// State needs to be bound here to be acted on
// because these are called by click events and
// as such are called with only the `event` object
const eventLookup = ({ target: { id } }) => {
  switch (id) {
    case CHANGE_MR_ID_BUTTON:
      return () => {
        saveComment();
        changeSelectedMr(state);
      };
    case COLLAPSE_BUTTON:
      return toggleForm;
    case COMMENT_BUTTON:
      return postComment.bind(null, state);
    case LOGIN:
      return authorizeUser.bind(null, state);
    case LOGOUT:
      return () => {
        saveComment();
        logoutUser(state);
      };
    case MR_ID_BUTTON:
      return addMr.bind(null, state);
    default:
      return noop;
  }
};

const updateWindowSize = wind => {
  state.innerWidth = wind.innerWidth;
  state.innerHeight = wind.innerHeight;
};

const initializeGlobalListeners = () => {
  window.addEventListener('resize', debounce(updateWindowSize.bind(null, window), 200));
  window.addEventListener('beforeunload', event => {
    try {
      saveComment();
    } catch (err) {
      // in this case, if saving the comment fails,
      // the user will be warned, as recommended by MDN: https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onbeforeunload#Example
      event.preventDefault();
      /* eslint-disable-next-line no-param-reassign */
      event.returnValue = '';
    }
  });
};

export { eventLookup, initializeGlobalListeners };
