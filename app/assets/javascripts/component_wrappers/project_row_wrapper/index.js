import { css } from 'lit-element';
import Frank from '~/frankenstein_component';

class ProjectRowWrapper extends Frank {
  static get styles() {
    return [
      css`
        :host {
          display: block;
        }
      `,
    ];
  }
}
// Register the element with the browser
customElements.define('project-row-wrapper', ProjectRowWrapper);
