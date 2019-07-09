# frozen_string_literal: true

class Gitlab::TimeTooltipFormatter
  attr_reader :time, :placement, :html_class, :short_format, :timezoned

  TIME_FORMAT = '%b %d, %Y'

  def initialize(time:, placement: 'top', html_class: '', short_format: false, timezoned: false)
    @time = time
    @placement = placement
    @html_class = html_class
    @short_format = short_format
    @timezoned = timezoned
  end

  def time_format
    TIME_FORMAT
  end

  def tooltip_format
    format = timezoned ? 'timeago_tooltip_tz' : 'timeago_tooltip'
    format.to_sym
  end

  def css_classes
    classes = [short_format ? 'js-short-timeago' : 'js-timeago']
    classes << html_class unless html_class.blank?
    classes.join(' ')
  end

  def time_for_tooltip
    t = time.to_time
    timezoned ? t.localtime : t.in_time_zone
  end

  def time_to_datetime
    time.to_time.getutc.iso8601
  end

  def element_data
    {
      toggle: 'tooltip',
      placement: placement,
      container: 'body'
    }
  end
end
