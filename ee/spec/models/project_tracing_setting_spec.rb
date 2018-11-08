# frozen_string_literal: true

require 'spec_helper'

describe ProjectTracingSetting do
  describe '#external_url' do
    let(:project) { build(:project) }
    let(:tracing_setting) { project.build_tracing_setting }

    it 'accepts a valid url' do
      tracing_setting.external_url = "https://gitlab.com"

      expect(tracing_setting).to be_valid

      expect { tracing_setting.save! }.not_to raise_error
    end

    it 'fails with an invalid url' do
      tracing_setting.external_url = "gitlab.com"
      expect(tracing_setting).not_to be_valid
    end

    it 'fails with a blank string' do
      tracing_setting.external_url = " "
      expect(tracing_setting).not_to be_valid
    end
  end
end
