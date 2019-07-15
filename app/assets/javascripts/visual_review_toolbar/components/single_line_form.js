import { REMEMBER_ITEM } from './constants';
import { buttonClearStyles } from './utils';

const singleForm = ({
  inputId,
  buttonId,
  type,
  autocomplete,
  labelText,
  placeholder = '',
  /* eslint-disable-next-line @gitlab/i18n/no-non-i18n-strings */
  rememberText = 'Remember me',
}) => `
  <div>
    <label for="${inputId}" class="gitlab-label">${labelText}</label>
    <input class="gitlab-input" type="${type}" id="${inputId}" name="${inputId}" placeholder="e.g., ${placeholder}" aria-required="true" autocomplete="${autocomplete}">
  </div>
  <div class="gitlab-checkbox-wrapper">
    <input type="checkbox" id="${REMEMBER_ITEM}" name="${REMEMBER_ITEM}" value="remember">
    <label for="${REMEMBER_ITEM}" class="gitlab-checkbox-label">${rememberText}</label>
  </div>
  <div class="gitlab-button-wrapper">
    <button class="gitlab-button-wide gitlab-button gitlab-button-success" style="${buttonClearStyles}" type="button" id="${buttonId}"> Submit </button>
  </div>
`;

export default singleForm;
