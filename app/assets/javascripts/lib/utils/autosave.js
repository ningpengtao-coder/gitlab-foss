const autosaveStorageKey = autosaveKey => ['autosave', ...autosaveKey].join('/');

export const clearDraft = autosaveKey => {
  try {
    window.localStorage.removeItem(autosaveStorageKey(autosaveKey));
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error(e);
  }
};

export const getDraft = autosaveKey => {
  try {
    return window.localStorage.getItem(autosaveStorageKey(autosaveKey));
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error(e);
    return null;
  }
};

export const updateDraft = (autosaveKey, text) => {
  try {
    window.localStorage.setItem(autosaveStorageKey(autosaveKey), text);
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error(e);
  }
};
