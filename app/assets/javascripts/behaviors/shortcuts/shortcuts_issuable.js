import $ from 'jquery';
import Mousetrap from 'mousetrap';
import Sidebar from '../../right_sidebar';
import Shortcuts from './shortcuts';
import { CopyAsGFM } from '../markdown/copy_as_gfm';
import { getSelectedFragment } from '~/lib/utils/common_utils';

export default class ShortcutsIssuable extends Shortcuts {
  constructor(isMergeRequest) {
    super();

    Mousetrap.bind('a', () => ShortcutsIssuable.openSidebarDropdown('assignee'));
    Mousetrap.bind('m', () => ShortcutsIssuable.openSidebarDropdown('milestone'));
    Mousetrap.bind('l', () => ShortcutsIssuable.openSidebarDropdown('labels'));
    Mousetrap.bind('r', () => ShortcutsIssuable.replyWithSelectedText());
    Mousetrap.bind('e', ShortcutsIssuable.editIssue);

    if (isMergeRequest) {
      this.enabledHelp.push('.hidden-shortcut.merge_requests');
    } else {
      this.enabledHelp.push('.hidden-shortcut.issues');
    }
  }

  static replyWithSelectedText(markdownField) {
    let field = markdownField;

    if (!field) {
      const $field = $('.js-main-target-form .js-vue-markdown-field');

      if (!$field.length || $field.is(':hidden') /* Other tab selected in MR */) {
        return false;
      }

      field = $field[0].__vue__; // eslint-disable-line no-underscore-dangle
    }

    const documentFragment = getSelectedFragment(document.querySelector('#content-body'));

    if (!documentFragment) {
      field.focus();
      return false;
    }

    // Sanity check: Make sure the selected text comes from a discussion : it can either contain a message...
    let foundMessage = !!documentFragment.querySelector('.md, .wiki');

    // ... Or come from a message
    if (!foundMessage) {
      if (documentFragment.originalNodes) {
        documentFragment.originalNodes.forEach(e => {
          let node = e;
          do {
            // Text nodes don't define the `matches` method
            if (node.matches && node.matches('.md, .wiki')) {
              foundMessage = true;
            }
            node = node.parentNode;
          } while (node && !foundMessage);
        });
      }

      // If there is no message, just select the reply field
      if (!foundMessage) {
        field.focus();
        return false;
      }
    }

    const el = CopyAsGFM.transformGFMSelection(documentFragment.cloneNode(true));
    field.quoteNode(el);

    return false;
  }

  static editIssue() {
    // Need to click the element as on issues, editing is inline
    // on merge request, editing is on a different page
    document.querySelector('.js-issuable-edit').click();

    return false;
  }

  static openSidebarDropdown(name) {
    Sidebar.instance.openDropdown(name);
    return false;
  }
}
