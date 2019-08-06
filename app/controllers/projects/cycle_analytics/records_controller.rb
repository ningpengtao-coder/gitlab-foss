# frozen_string_literal: true

module Projects
  module CycleAnalytics
    class RecordsController < Projects::ApplicationController
      include CycleAnalyticsParams

      before_action :authorize_read_cycle_analytics!

      def index
        stage = ::CycleAnalytics::StageFindService.new(parent: project, id: params[:stage_id]).execute
        data_collector = Gitlab::CycleAnalytics::DataCollector.new(stage, {
          from: cycle_analytics_params[:start_date],
          current_user: current_user
        })

        render json: data_collector.records_fetcher.serialized_records
      end

      def cycle_analytics_params
        return {} unless params[:cycle_analytics].present?

        params[:cycle_analytics].permit(:start_date)
      end
    end
  end
end
