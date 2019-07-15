# frozen_string_literal: true

require 'fast_spec_helper'
require_relative '../../../app/models/pages/lookup_path'

describe Pages::LookupPath do
  let(:project) do
    double(
      id: 12345,
      private_pages?: true,
      pages_https_only?: true,
      https?: false,
      full_path: 'the/full/path'
    )
  end

  subject(:lookup_path) { described_class.new(project) }

  describe '#project_id' do
    it 'delegates to Project#id' do
      expect(lookup_path.project_id).to eq(12345)
    end
  end

  describe '#access_control' do
    it 'delegates to Project#private_pages?' do
      expect(lookup_path.access_control).to eq(true)
    end
  end

  describe '#https_only' do
    subject(:lookup_path) { described_class.new(project, domain: domain) }

    context 'when no domain provided' do
      let(:domain) { nil }

      it 'delegates to Project#pages_https_only?' do
        expect(lookup_path.https_only).to eq(true)
      end
    end

    context 'when there is domain provided' do
      let(:domain) { double(https?: false) }

      it 'takes into account the https setting of the domain' do
        expect(lookup_path.https_only).to eq(false)
      end
    end
  end

  describe '#source' do
    it 'sets the source type to "file"' do
      expect(lookup_path.source[:type]).to eq('file')
    end

    it 'sets the source path to the project full path suffixed with "public/' do
      expect(lookup_path.source[:path]).to eq('the/full/path/public/')
    end
  end

  describe '#prefix' do
    it 'returns "/" for pages group root projects' do
      project = double(pages_group_root?: true)
      lookup_path = described_class.new(project, trim_prefix: 'mygroup')

      expect(lookup_path.prefix).to eq('/')
    end

    it 'returns the project full path wth the provided prefix removed' do
      project = double(pages_group_root?: false, full_path: 'mygroup/myproject')
      lookup_path = described_class.new(project, trim_prefix: 'mygroup')

      expect(lookup_path.prefix).to eq('/myproject/')
    end
  end
end
