import Frank from '~/frankenstein_component';

import styles from './styles.scss';

class MRWidgetOptionsWrapper extends Frank {
  static get styles() {
    return [styles];
  }
}
// Register the element with the browser
customElements.define('mr-widget-options-wrapper', MRWidgetOptionsWrapper);
