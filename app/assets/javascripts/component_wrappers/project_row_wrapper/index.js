import Frank from '~/frankenstein_component';

import styles from './styles.scss';

class ProjectRowWrapper extends Frank {
  static get styles() {
    return [styles];
  }
}
// Register the element with the browser
customElements.define('project-row-wrapper', ProjectRowWrapper);
