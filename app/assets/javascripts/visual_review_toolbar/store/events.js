import {
  addMr,
  authorizeUser,
  changeSelectedMr,
  logoutUser,
  postComment,
  toggleForm,
  CHANGE_MR_ID_BUTTON,
  COLLAPSE_BUTTON,
  COMMENT_BUTTON,
  LOGIN,
  LOGOUT,
  MR_ID_BUTTON,
} from '../components';

import { state } from './state';

const noop = () => {};

// State needs to be bound here to be acted on
// because these are called by click events and
// as such are called with only the `event` object
const eventLookup = ({ target: { id } }) => {
  switch (id) {
    case CHANGE_MR_ID_BUTTON:
      return changeSelectedMr.bind(null, state);
    case COLLAPSE_BUTTON:
      return toggleForm;
    case COMMENT_BUTTON:
      return postComment.bind(null, state);
    case LOGIN:
      return authorizeUser.bind(null, state);
    case LOGOUT:
      return logoutUser.bind(null, state);
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

export { eventLookup, updateWindowSize };
