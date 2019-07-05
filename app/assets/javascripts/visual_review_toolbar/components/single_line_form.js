import { REMEMBER_TOKEN } from './constants';
import { buttonClearStyles } from './utils';

const singleForm = (inputId, buttonId, labelText) => {
  return `
    <div>
      <label for="${inputId}" class="gitlab-label">${labelText}</label>
      <input class="gitlab-input" type="password" id="${inputId}" name="${inputId}" aria-required="true" autocomplete="current-password">
    </div>
    <div class="gitlab-checkbox-wrapper">
      <input type="checkbox" id="${REMEMBER_TOKEN}" name="${REMEMBER_TOKEN}" value="remember">
      <label for="${REMEMBER_TOKEN}" class="gitlab-checkbox-label">Remember me</label>
    </div>
    <div class="gitlab-button-wrapper">
      <button class="gitlab-button-wide gitlab-button gitlab-button-success" style="${buttonClearStyles}" type="button" id="${buttonId}"> Submit </button>
    </div>
  `;
}

export default singleForm;
