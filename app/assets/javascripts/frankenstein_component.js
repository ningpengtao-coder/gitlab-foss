// Import LitElement base class and html helper function
import { LitElement } from 'lit-element';

export default class WrapperElement extends LitElement {
  static get properties() {
    return {
      app: {
        type: Boolean,
        value: false,
      },
    };
  }
  update(changedProperties) {
    super.update(changedProperties);
    this.moveToShadow();
  }
  firstUpdated() {
    performance.mark('Frank is firstUpdated');
    this.addEventListener('vueRenderingComplete', this.moveToShadow);
  }

  moveToShadow(ev) {
    if (this.app && ev) {
      ev.preventDefault();
      ev.stopPropagation();
      this.shadowRoot.append(ev.target);
    } else if (!this.app) {
      for (let i = 0, l = this.children.length; i < l; i += 1) {
        this.shadowRoot.append(this.children[i]);
      }
    }
  }
}
