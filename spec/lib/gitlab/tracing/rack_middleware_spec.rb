# frozen_string_literal: true

require 'fast_spec_helper'

describe Gitlab::Tracing::RackMiddleware do
  describe '#call' do
    let(:env_hash) do
      {
        "REQUEST_URI": "/api/endpoint",
        "REQUEST_METHOD": "GET"
      }
    end

    context 'when an application is working' do
      let(:app_response) { [200, { 'Content-Type': 'text/plain' }, ['OK']] }
      let(:app) { lambda {|env| app_response } }

      subject { described_class.new(app) }

      it 'delegates correctly' do
        expect(subject.call(env_hash)).to eq(app_response)
      end
    end

    context 'when an application is failing' do
      let(:app_response) { [500, { 'Content-Type': 'text/plain' }, ['Error']] }
      let(:app) { lambda {|env| app_response } }

      subject { described_class.new(app) }

      it 'delegates correctly' do
        expect(subject.call(env_hash)).to eq(app_response)
      end
    end

    context 'when an application is raising an exception' do
      let(:custom_error) { Class.new(StandardError) }
      let(:app) { lambda {|env| raise custom_error } }

      subject { described_class.new(app) }

      it 'delegates propagates exceptions correctly' do
        expect { subject.call(env_hash) }.to raise_error(custom_error)
      end
    end
  end
end
