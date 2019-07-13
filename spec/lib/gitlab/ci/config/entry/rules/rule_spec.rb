require 'spec_helper'
require 'support/helpers/stub_feature_flags'
require_dependency 'active_model'

describe Gitlab::Ci::Config::Entry::Rules::Rule do
  let(:entry) { described_class.new(config) }

  describe '.new' do
    subject { entry }

    context 'when specifying an if: clause' do
      let(:config) { { if: '$THIS || $THAT' } }

      it { is_expected.to be_valid }
    end

    context 'using a list of multiple expressions' do
      let(:config) { { if: ['$MY_VAR == "this"', '$YOUR_VAR == "that"'] } }

      it { is_expected.not_to be_valid }

      it 'reports an error about invalid format' do
        expect(subject.errors).to include(/should be a string/)
      end
    end

    context 'when specifying an invalid if: clause expression' do
      let(:config) { { if: ['$MY_VAR =='] } }

      it { is_expected.not_to be_valid }

      it 'reports an error about invalid statement' do
        expect(subject.errors).to include(/invalid expression syntax/)
      end
    end

    context 'when specifying an if: clause expression with an invalid token' do
      let(:config) { { if: ['$MY_VAR == 123'] } }

      it { is_expected.not_to be_valid }

      it 'reports an error about invalid statement' do
        expect(subject.errors).to include(/invalid expression syntax/)
      end
    end

    context 'when using invalid regex in an if: clause' do
      let(:config) { { if: ['$MY_VAR =~ /some ( thing/'] } }

      it 'reports an error about invalid expression' do
        expect(subject.errors).to include(/invalid expression syntax/)
      end
    end

    context 'when using an if: clause with unsafe regex' do
      include StubFeatureFlags

      let(:config) { { if: '$CI_COMMIT_REF =~ /^(?!master).+/' } }

      context 'when allow_unsafe_ruby_regexp is disabled' do
        before do
          stub_feature_flags(allow_unsafe_ruby_regexp: false)
        end

        it { is_expected.not_to be_valid }

        it 'reports an error about invalid expression syntax' do
          expect(subject.errors).to include(/invalid expression syntax/)
        end
      end

      context 'when allow_unsafe_ruby_regexp is enabled' do
        before do
          stub_feature_flags(allow_unsafe_ruby_regexp: true)
        end

        it { is_expected.to be_valid }

        it 'stores the expression as if_expression:' do
          expect(subject.value).to eq(if_expression: '$CI_COMMIT_REF =~ /^(?!master).+/')
        end
      end
    end

    context 'when using a changes: clause' do
      let(:config) { { changes: %w[app/ lib/ spec/ other/* paths/**/*.rb] } }

      it { is_expected.to be_valid }
    end

    context 'when using a string as an invalid changes: clause' do
      let(:config) { { changes: 'a regular string' } }

      it { is_expected.not_to be_valid }

      it 'reports an error about invalid policy' do
        expect(subject.errors).to include(/should be an array of strings/)
      end
    end

    context 'when using a list as an invalid changes: clause' do
      let(:config) { { changes: [1, 2] } }

      it { is_expected.not_to be_valid }

      it 'returns errors' do
        expect(subject.errors).to include(/changes should be an array of strings/)
      end
    end

    context 'when specifying unknown policy' do
      let(:config) { { invalid: :something } }

      it { is_expected.not_to be_valid }

      it 'returns error about invalid key' do
        expect(entry.errors).to include(/unknown keys: invalid/)
      end
    end

    context 'when clause is empty' do
      let(:config) { {} }

      it { is_expected.not_to be_valid }

      it 'is not a valid configuration' do
        expect(entry.errors).to include(/can't be blank/)
      end
    end

    context 'when policy strategy does not match' do
      let(:config) { 'string strategy' }

      it { is_expected.not_to be_valid }

      it 'returns information about errors' do
        expect(entry.errors)
          .to include(/should be a hash/)
      end
    end
  end

  describe '#value' do
    subject { entry.value }

    context 'when specifying an if: clause' do
      let(:config) { { if: '$THIS || $THAT' } }

      it 'stores the expression as "if_expression"' do
        expect(subject).to eq(if_expression: '$THIS || $THAT')
      end
    end

    context 'when using a changes: clause' do
      let(:config) { { changes: %w[app/ lib/ spec/ other/* paths/**/*.rb] } }

      it { is_expected.to eq(config) }
    end

    context 'when default value has been provided' do
      let(:default) { { changes: %w[**/*] } }

      before do
        entry.default = default
      end

      context 'when user overrides default values' do
        let(:config) { { changes: %w[feature], if: %w[$VARIABLE] } }

        it { is_expected.to eq(config) }
      end

      context 'when default value has not been defined' do
        let(:config) { { if: %w[$VARIABLE] } }

        it { is_expected.to eq(config) }
      end
    end
  end

  describe '.default' do
    it 'does not have default policy' do
      expect(described_class.default).to be_nil
    end
  end
end
