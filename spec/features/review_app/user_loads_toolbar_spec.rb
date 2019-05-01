require 'spec_helper'

describe 'Toolbar', :js do

  describe 'injected toolbar' do
    it 'loads the login screen' do
      visit root_path
      find('body')
      evaluate_script("document.body.innerHTML = 'hi winnie and sarah, but for real'")
      live_debug
    end
  end
end
