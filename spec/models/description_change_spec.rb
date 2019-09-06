# frozen_string_literal: true

require 'spec_helper'

describe DescriptionChange do
  describe 'associations' do
    it { is_expected.to belong_to(:system_note) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:system_note) }
  end
end
