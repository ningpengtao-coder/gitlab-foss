# frozen_string_literal: true

require 'spec_helper'

describe Resolvers::MetadataResolver do
  include GraphqlHelpers

  describe '#resolve' do
    it 'resolves the current version and revision' do
      resolution = resolve(described_class)

      expect(resolution[:version]).to eq(Gitlab::VERSION)
      expect(resolution[:revision]).to eq(Gitlab.revision)
    end
  end
end
