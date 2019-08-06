# frozen_string_literal: true

class Projects::CycleAnalyticsController < Projects::ApplicationController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include CycleAnalyticsParams

  before_action :whitelist_query_limiting, only: [:show]
  before_action :authorize_read_cycle_analytics!

  def show
    @cycle_analytics = ::CycleAnalytics::ProjectLevel.new(@project, options: options(cycle_analytics_params))

    respond_to do |format|
      format.html do
        @cycle_analytics_no_data = @cycle_analytics.no_stats?

        render :show
      end
      format.json do
        if params[:new_api] # Use new API when FE is ready
          stages = ::CycleAnalytics::StageListService.new(parent: project).execute
          render json: ::CycleAnalytics::CycleAnalyticsEntity.new({
            stages: stages,
            summary: @cycle_analytics.summary,
            permissions: @cycle_analytics.permissions(user: current_user)
          })
        else
          render json: cycle_analytics_json
        end
      end
    end
  end

  def median
    stage = ::CycleAnalytics::StageFindService.new(parent: project, id: params[:stage_id]).execute
    data_collector = Gitlab::CycleAnalytics::DataCollector.new(stage, {
      from: cycle_analytics_params[:start_date],
      current_user: current_user
    })

    render json: ::CycleAnalytics::MedianEntity.new(data_collector.median.seconds)
  end

  private

  def cycle_analytics_json
    {
      summary: @cycle_analytics.summary,
      stats: @cycle_analytics.stats,
      permissions: @cycle_analytics.permissions(user: current_user)
    }
  end

  def cycle_analytics_params
    return {} unless params[:cycle_analytics].present?

    params[:cycle_analytics].permit(:start_date)
  end

  def whitelist_query_limiting
    Gitlab::QueryLimiting.whitelist('https://gitlab.com/gitlab-org/gitlab-ce/issues/42671')
  end
end
