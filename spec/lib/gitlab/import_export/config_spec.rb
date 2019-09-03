# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::ImportExport::Config do
  set(:project) { create(:project) }
  let(:config) { described_class.new(project) }

  describe '#to_h' do
    it 'just returns the parsed Hash without the EE section' do
      # This test can't be run within the EE codebase
      skip if Gitlab.ee?

      expected = YAML.load_file(Gitlab::ImportExport.config_file)
      expected.delete('ee')

      expect(config.to_h).to eq(expected)
    end

    describe 'merging a feature flagged project tree' do
      before do
        allow(config)
        .to receive(:parse_yaml)
        .and_return({
          'project_tree' => [
            'issues' => %i[id]
          ],
          'feature_flagged' => {
            'feature_foo' => {
              'default_enabled' => true,
              'project_tree' => [
                'issues' => %i[description]
              ]
            }
          }
        })
      end

      it 'merges the feature flagged project tree when the feature is enabled' do
        stub_feature_flags(feature_foo: true)

        expect(config.to_h).to eq({
          'project_tree' => ['issues' => %i[id description]]
        })
      end

      it 'does not merge the feature flagged project tree when the feature is disabled' do
        stub_feature_flags(feature_foo: false)

        expect(config.to_h).to eq({
          'project_tree' => [{ 'issues' => %i[id] }]
        })
      end
    end
  end
end
