import $ from 'jquery';
import Vue from 'vue';
import '~/behaviors/markdown/render_gfm';
import fieldComponent from '~/vue_shared/components/markdown/field.vue';

function assertMarkdownTabs(isWrite, writeLink, previewLink, vm) {
  expect(writeLink.parentNode.classList.contains('active')).toEqual(isWrite);
  expect(previewLink.parentNode.classList.contains('active')).toEqual(!isWrite);
  expect(vm.$el.querySelector('.md-preview-holder').style.display).toEqual(isWrite ? 'none' : '');
}

describe('Markdown field component', () => {
  let vm;

  beforeEach(done => {
    vm = new Vue({
      components: {
        fieldComponent,
      },
      data() {
        return {
          text: 'testing\n123',
        };
      },
      template: `
        <field-component
          v-model="text"
          markdown-preview-path="/preview"
          markdown-docs-path="/docs"
        />
      `,
    }).$mount();

    Vue.nextTick(done);
  });

  describe('mounted', () => {
    it('renders textarea inside backdrop', () => {
      expect(vm.$el.querySelector('.zen-backdrop textarea')).not.toBeNull();
    });

    describe('markdown preview', () => {
      let previewLink;
      let writeLink;

      beforeEach(() => {
        spyOn(Vue.http, 'post').and.callFake(
          () =>
            new Promise(resolve => {
              Vue.nextTick(() => {
                resolve({
                  json() {
                    return {
                      body: '<p>markdown preview</p>',
                    };
                  },
                });
              });
            }),
        );

        previewLink = vm.$el.querySelector('.nav-links .js-preview-link');
        writeLink = vm.$el.querySelector('.nav-links .js-write-link');
      });

      it('sets preview link as active', done => {
        previewLink.click();

        Vue.nextTick(() => {
          expect(previewLink.parentNode.classList.contains('active')).toBeTruthy();

          done();
        });
      });

      it('shows preview loading text', done => {
        previewLink.click();

        Vue.nextTick(() => {
          expect(vm.$el.querySelector('.md-preview-holder').textContent.trim()).toContain(
            'Loading…',
          );

          done();
        });
      });

      it('renders markdown preview', done => {
        previewLink.click();

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect(vm.$el.querySelector('.md-preview-holder').innerHTML).toContain(
              '<p>markdown preview</p>',
            );
          })
          .then(done)
          .catch(done.fail);
      });

      it('renders GFM with jQuery', done => {
        spyOn($.fn, 'renderGFM');

        previewLink.click();

        Vue.nextTick()
          .then(Vue.nextTick)
          .then(Vue.nextTick)
          .then(() => {
            expect($.fn.renderGFM).toHaveBeenCalled();
          })
          .then(done)
          .catch(done.fail);
      });

      it('clicking already active write or preview link does nothing', done => {
        writeLink.click();
        Vue.nextTick()
          .then(() => assertMarkdownTabs(true, writeLink, previewLink, vm))
          .then(() => writeLink.click())
          .then(() => Vue.nextTick())
          .then(() => assertMarkdownTabs(true, writeLink, previewLink, vm))
          .then(() => previewLink.click())
          .then(() => Vue.nextTick())
          .then(() => assertMarkdownTabs(false, writeLink, previewLink, vm))
          .then(() => previewLink.click())
          .then(() => Vue.nextTick())
          .then(() => assertMarkdownTabs(false, writeLink, previewLink, vm))
          .then(done)
          .catch(done.fail);
      });
    });

    describe('markdown buttons', () => {
      it('converts single words', done => {
        const textarea = vm.$el.querySelector('textarea');

        textarea.setSelectionRange(0, 7);
        vm.$el.querySelector('.toolbar-btn').click();

        Vue.nextTick(() => {
          expect(textarea.value).toContain('**testing**');

          done();
        });
      });

      it('converts a line', done => {
        const textarea = vm.$el.querySelector('textarea');

        textarea.setSelectionRange(0, 0);
        vm.$el.querySelectorAll('.toolbar-btn')[5].click();

        Vue.nextTick(() => {
          expect(textarea.value).toContain('*  testing');

          done();
        });
      });

      it('converts multiple lines', done => {
        const textarea = vm.$el.querySelector('textarea');

        textarea.setSelectionRange(0, 50);
        vm.$el.querySelectorAll('.toolbar-btn')[5].click();

        Vue.nextTick(() => {
          expect(textarea.value).toContain('* testing\n* 123');

          done();
        });
      });
    });
  });
});
