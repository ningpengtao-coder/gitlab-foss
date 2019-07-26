# frozen_string_literal: true

require 'spec_helper'

describe BackgroundCounter do
  describe 'before_save hooks' do
    let!(:counter) { create(:background_counter) }

    it 'sets the updated_at timestamp when changed' do
      counter.counter_value = 1
      expect { counter.save }.to change { counter.updated_at }
    end
  end
end
