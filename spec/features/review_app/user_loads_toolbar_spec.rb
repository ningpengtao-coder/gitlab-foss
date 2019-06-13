# frozen_string_literal: true
require 'spec_helper'

describe 'Toolbar', :js do
  describe 'injected toolbar' do
    add_script = %q(
      const scriptEl = document.createElement('script');
      scriptEl.setAttribute('src', 'https://host-island.sarahghp.now.sh/review-toolbar.js');
      scriptEl.setAttribute('data-project-id' , '11790219');
      scriptEl.setAttribute('data-merge-request-id' , '1');
      scriptEl.setAttribute('id' , 'review-app-toolbar-script');
      scriptEl.setAttribute('data-mr-url' , 'https://gitlab.com');
      document.head.appendChild(scriptEl);
    )

    load_script = %q(
      const newLoad = new Event('load');
      window.dispatchEvent(newLoad);
    )

    it 'loads the login screen' do
      visit root_path
      find('body')
      evaluate_script(add_script)
      evaluate_script(load_script)
      expect(find('#gitlab-review-container')).to exist
    end
  end
end
