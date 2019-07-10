# frozen_string_literal: true

require 'fast_spec_helper'

describe Gitlab::WikiPath do
  subject { described_class.parse(path_string) }

  context 'the path is nil' do
    let(:path_string) { nil }

    it { is_expected.to have_attributes(depth: 0, dirname: '', basename: '') }
  end

  context 'the path is empty' do
    let(:path_string) { '' }

    it { is_expected.to have_attributes(depth: 0, dirname: '', basename: '') }
  end

  context 'the path is a single element' do
    let(:path_string) { 'foo' }

    it { is_expected.to have_attributes(depth: 0, dirname: '', basename: 'foo') }
  end

  context 'the path is a single element with spaces' do
    let(:path_string) { 'foo bar' }

    it { is_expected.to have_attributes(depth: 0, dirname: '', basename: 'foo bar') }

    it { is_expected.to be_root_level }
  end

  context 'the path is two elements' do
    let(:path_string) { 'foo/bar' }

    it { is_expected.to have_attributes(depth: 1, dirname: 'foo', basename: 'bar') }

    it { is_expected.not_to be_root_level }

    it 'has the right parent' do
      expect(subject.parent).to have_attributes(dirname: '', basename: 'foo')
    end
  end

  context 'the path is several elements' do
    let(:path_string) { 'foo/bar/baz' }

    it { is_expected.to have_attributes(depth: 2, dirname: 'foo/bar', basename: 'baz') }

    it { is_expected.not_to be_root_level }

    it 'has the right parent' do
      expect(subject.parent).to have_attributes(dirname: 'foo', basename: 'bar')
    end
  end
end
