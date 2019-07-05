# frozen_string_literal: true

require 'fast_spec_helper'

describe Gitlab::TimeTooltipFormatter do
  let(:formatter) { described_class.new(time: Time.now) }

  describe '#tooltip_format' do
    it 'returns the correct symbol based on timezoned attribute' do
      formatter.timezoned = false
      expect(formatter.tooltip_format).to eq :timeago_tooltip

      formatter.timezoned = true
      expect(formatter.tooltip_format).to eq :timeago_tooltip_tz
    end
  end

  describe '#css_classes' do
    let(:random_class) { 'random-class' }

    it 'returns the correct array of classes' do
      formatter.short_format = true
      expect(formatter.css_classes).to eq 'js-short-timeago'
      formatter.html_class = random_class
      expect(formatter.css_classes).to eq "js-short-timeago #{random_class}"
      formatter.short_format = false
      expect(formatter.css_classes).to eq "js-timeago #{random_class}"
    end
  end

  describe '#time_for_tooltip' do
    before do
      Time.zone = 'UTC'
    end

    it 'returns the time at the correct time zone' do
      formatter = described_class.new(time: Time.now)
      formatter.timezoned = true
      expect(formatter.time_for_tooltip.to_s).not_to include 'UTC'
      formatter.timezoned = false
      expect(formatter.time_for_tooltip.to_s).to include 'UTC'
    end
  end
end
