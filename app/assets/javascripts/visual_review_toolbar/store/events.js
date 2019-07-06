import {
  addMr,
  authorizeUser,
  logoutUser,
  postComment,
  toggleForm,
  COLLAPSE_BUTTON,
  COMMENT_BUTTON,
  LOGIN,
  LOGOUT,
  MR_ID_BUTTON,
} from '../components';

import { state } from './state';

const noop = () => {};

const eventLookup = ({ target: { id } }) => {
  switch (id) {
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
