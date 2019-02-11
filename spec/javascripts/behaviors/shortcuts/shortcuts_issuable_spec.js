/* eslint-disable
  no-underscore-dangle
*/

import Vue from 'vue';
import initCopyAsGFM, { CopyAsGFM } from '~/behaviors/markdown/copy_as_gfm';
import ShortcutsIssuable from '~/behaviors/shortcuts/shortcuts_issuable';
import fieldComponent from '~/vue_shared/components/markdown/field.vue';

describe('ShortcutsIssuable', function() {
  beforeAll(done => {
    initCopyAsGFM();

    // Fake call to nodeToGFM so the import of lazy bundle happened
    CopyAsGFM.nodeToGFM(document.createElement('div'))
      .then(done)
      .catch(done.fail);
  });

  let vm;

  beforeEach(done => {
    const Component = Vue.extend(fieldComponent);

    vm = new Component({
      propsData: {
        markdownPreviewPath: '/preview',
        markdownDocsPath: '/docs',
      },
    }).$mount();

    Vue.nextTick(done);
  });

  afterEach(() => {
    vm.$destroy();
  });

  describe('replyWithSelectedText', () => {
    // Stub window.gl.utils.getSelectedFragment to return a node with the provided HTML.
    const stubSelection = (html, invalidNode) => {
      ShortcutsIssuable.__Rewire__('getSelectedFragment', () => {
        const documentFragment = document.createDocumentFragment();
        const node = document.createElement('div');

        node.innerHTML = html;
        if (!invalidNode) node.className = 'md';

        documentFragment.appendChild(node);
        return documentFragment;
      });
    };
    describe('with empty selection', () => {
      it('does not return an error', done => {
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with any selection', () => {
      beforeEach(() => {
        stubSelection('<p>Selected text.</p>');
      });

      it('leaves existing input intact', done => {
        vm.value = 'This text was already here.';

        Vue.nextTick()
          .then(() => ShortcutsIssuable.replyWithSelectedText(vm))
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('This text was already here.\n\n> Selected text.\n\n');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with a one-line selection', () => {
      it('quotes the selection', done => {
        stubSelection('<p>This text has been selected.</p>');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('> This text has been selected.\n\n');
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with a multi-line selection', () => {
      it('quotes the selected lines as a group', done => {
        stubSelection(
          '<p>Selected line one.</p>\n<p>Selected line two.</p>\n<p>Selected line three.</p>',
        );
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe(
              '> Selected line one.\n>\n> Selected line two.\n>\n> Selected line three.\n\n',
            );
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with an invalid selection', () => {
      beforeEach(() => {
        stubSelection('<p>Selected text.</p>', true);
      });

      it('does not add anything to the input', done => {
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with a semi-valid selection', () => {
      beforeEach(() => {
        stubSelection('<div class="md">Selected text.</div><p>Invalid selected text.</p>', true);
      });

      it('only adds the valid part to the input', done => {
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('> Selected text.\n\n');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with a selection in a valid block', () => {
      beforeEach(() => {
        ShortcutsIssuable.__Rewire__('getSelectedFragment', () => {
          const documentFragment = document.createDocumentFragment();
          const node = document.createElement('div');
          const originalNode = document.createElement('body');
          originalNode.innerHTML = `<div class="issue">
            <div class="otherElem">Text...</div>
            <div class="md"><p><em>Selected text.</em></p></div>
          </div>`;
          documentFragment.originalNodes = [originalNode.querySelector('em')];

          node.innerHTML = '<em>Selected text.</em>';

          documentFragment.appendChild(node);

          return documentFragment;
        });
      });

      it('adds the quoted selection to the input', done => {
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('> *Selected text.*\n\n');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });

    describe('with a selection in an invalid block', () => {
      beforeEach(() => {
        ShortcutsIssuable.__Rewire__('getSelectedFragment', () => {
          const documentFragment = document.createDocumentFragment();
          const node = document.createElement('div');
          const originalNode = document.createElement('body');
          originalNode.innerHTML = `<div class="issue">
            <div class="otherElem"><div><b>Selected text.</b></div></div>
            <div class="md"><p><em>Valid text</em></p></div>
          </div>`;
          documentFragment.originalNodes = [originalNode.querySelector('b')];

          node.innerHTML = '<b>Selected text.</b>';

          documentFragment.appendChild(node);

          return documentFragment;
        });
      });

      it('does not add anything to the input', done => {
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.currentValue).toBe('');
          })
          .then(done)
          .catch(done.fail);
      });

      it('triggers `focus`', done => {
        const spy = spyOn(vm, 'focus');
        ShortcutsIssuable.replyWithSelectedText(vm);

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(() => {
            expect(spy).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });
    });
  });
});
