# frozen_string_literal: true

module Projects
  class ChartsController < Projects::ApplicationController
    before_action :authorize_read_build!

    def show
      render json: fetch_content.to_json
    end

    private

    def project_without_auth
      @project ||= Project
        .find_by_full_path("#{params[:namespace_id]}/#{params[:project_id]}")
    end

    def fetch_content
      return { error: 'No URL provided' } if params[:url].blank?

      result = Gitlab::HTTP.get(params[:url])
      JSON.parse(result.bokdy)
    rescue
      { error: 'The content is not a valid JSON' }
    end
  end
end
