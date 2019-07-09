# frozen_string_literal: true

require 'fast_spec_helper'

describe Gitlab::TimeTooltipFormatter do
  let(:timezoned) { false }
  let(:short_format) { false }
  let(:html_class) { '' }
  let(:formatter) do
    described_class.new(time: Time.now,
                        short_format: short_format,
                        timezoned: timezoned,
                        html_class: html_class)
  end

  describe '#tooltip_format' do
    it 'returns the timeago_tooltip symbol' do
      expect(formatter.tooltip_format).to eq :timeago_tooltip
    end

    context 'when timezoned attribute is set to true' do
      let(:timezoned) { true }
      it 'returns the timeago_tooltip_tz symbol' do
        expect(formatter.tooltip_format).to eq :timeago_tooltip_tz
      end
    end
  end

  describe '#css_classes' do
    it 'returns the correct array of classes' do
      expect(formatter.css_classes).to eq "js-timeago"
    end

    context 'when short_format is set to true' do
      let(:short_format) { true }
      it 'returns the correct array of classes' do
        expect(formatter.css_classes).to eq 'js-short-timeago'
      end
    end

    context 'when a random class is added' do
      let(:html_class) { 'random_class' }
      it 'returns the correct array of classes with this class in it' do
        expect(formatter.css_classes).to eq "js-timeago #{html_class}"
      end
    end
  end

  describe '#time_for_tooltip' do
    before do
      Time.zone = 'UTC'
    end

    it 'returns the time at the correct time zone' do
      expect(formatter.time_for_tooltip.to_s).to include 'UTC'
    end

    context 'when timezoned attribute is true' do
      let(:timezoned) { true }
      it 'returns the time at the correct time zone' do
        expect(formatter.time_for_tooltip.to_s).not_to include 'UTC'
      end
    end
  end
end
