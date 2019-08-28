import Store from '~/issue_show/stores';
import * as updateDescription from '~/issue_show/utils/update_description';

describe('Store', () => {
  let store;

  beforeEach(() => {
    store = new Store({
      descriptionHtml: '<p>This is a description</p>',
    });
  });

  describe('updateState', () => {
    beforeEach(() => {
      document.body.innerHTML = `
            <div class="detail-page-description content-block">
              <details open>
                <summary>One</summary>
              </details>
              <details>
                <summary>Two</summary>
              </details>
            </div>
          `;
    });

    afterEach(() => {
      document.getElementsByTagName('html')[0].innerHTML = ''; 
    });
  

    it('calls updateDetailsState', () => {
      /*
        * need to mock 'default' because we need to test its functionality in the next test
        * so we spy on its default export and then reset the module.
      */
      const spy = jest.spyOn(updateDescription, 'default')

      store.updateState({ description: '' });

      expect(updateDescription.default).toHaveBeenCalledTimes(1);

      spy.mockRestore();
    });

    it('returns the correct value to be set as descriptionHtml', () => {
      store.updateState({ description: '<details><summary>One</summary></details><details><summary>Two</summary></details>' });

      expect(store.state.descriptionHtml).toEqual('<details open="true"><summary>One</summary></details><details><summary>Two</summary></details>');
    });

    describe('when description details returned from api is different then whats currently on the dom', () => {
      it('returns the description from the api', () => {
        const dataDescription = '<details><summary>One</summary></details>';

        store.updateState({ description: dataDescription });

        expect(store.state.descriptionHtml).toEqual(dataDescription);
      });
    });
  });
});
