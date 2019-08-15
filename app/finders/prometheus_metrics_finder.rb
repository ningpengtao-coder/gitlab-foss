# frozen_string_literal: true

class PrometheusMetricsFinder
  ACCEPTED_PARAMS = [
    :project,
    :group,
    :title,
    :y_label,
    :identifier,
    :id,
    :common,
    :ordered
  ].freeze

  def initialize(params = {})
    validate_params!(params)

    @params = params
  end

  # @return [PrometheusMetric, PrometheusMetric::ActiveRecord_Relation]
  def execute
    metrics = by_project(::PrometheusMetric)
    metrics = by_group(metrics)
    metrics = by_title(metrics)
    metrics = by_y_label(metrics)
    metrics = common(metrics)
    metrics = ordered(metrics)
    metrics = find_identifier(metrics)
    metrics = find_id(metrics)

    metrics
  end

  private

  attr_reader :params

  def by_project(metrics)
    return metrics unless params[:project]

    metrics.for_project(params[:project])
  end

  def by_group(metrics)
    return metrics unless params[:group]

    metrics.for_group(params[:group])
  end

  def by_title(metrics)
    return metrics unless params[:title]

    metrics.for_title(params[:title])
  end

  def by_y_label(metrics)
    return metrics unless params[:y_label]

    metrics.for_y_label(params[:y_label])
  end

  def common(metrics)
    return metrics unless params[:common]

    metrics.common
  end

  def ordered(metrics)
    return metrics unless params[:ordered]

    metrics.order_created_at_asc
  end

  def find_identifier(metrics)
    return metrics unless params[:identifier]

    metrics.for_identifier(params[:identifier]).first
  end

  def find_id(metrics)
    return metrics unless params[:id]

    metrics.find(params[:id])
  end

  def validate_params!(params)
    raise ArgumentError, "Please provide one or more of: #{ACCEPTED_PARAMS}" if params.blank?
    raise ArgumentError, 'Only one of :identifier, :id is permitted' if params[:identifier] && params[:id]
    raise ArgumentError, ':identifier must be scoped to a :project or :common' if params[:identifier] && !(params[:project] || params[:common])
  end
end
