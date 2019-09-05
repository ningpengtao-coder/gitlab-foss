# frozen_string_literal: true

module Projects
  module Registry
    class TagsController < ::Projects::Registry::ApplicationController
      before_action :authorize_destroy_container_image!, only: [:destroy]

      LIMIT = 15

      def index
        track(:list_tags)
        respond_to do |format|
          format.json do
            render json: ContainerTagsSerializer
              .new(project: @project, current_user: @current_user)
              .with_pagination(request, response)
              .represent(tags)
          end
        end
      end

      def destroy
        if tag.delete
          track(:delete_tag)

          respond_to do |format|
            format.json { head :no_content }
          end
        else
          respond_to do |format|
            format.json { head :bad_request }
          end
        end
      end

      def bulk_destroy
        unless params[:ids].present?
          head :bad_request
          return
        end

        tag_names = params[:ids] || []
        if tag_names.size > LIMIT
          head :bad_request
          return
        end

        @tags = tag_names.map { |tag_name| image.tag(tag_name) }
        unless @tags.all? { |tag| tag.valid_name? }
          head :bad_request
          return
        end

        track(:delete_tag_bulk)
        success_count = 0
        @tags.each do |tag|
          if tag.delete
            track(:delete_tag)
            success_count += 1
          end
        end

        respond_to do |format|
          format.json { head(success_count == @tags.size ? :no_content : :bad_request) }
        end
      end

      private

      def track(action)
        Gitlab::Tracking.event('Projects::Registry::TagsController', action.to_s)
      end

      def tags
        Kaminari::PaginatableArray.new(image.tags, limit: LIMIT)
      end

      def image
        @image ||= project.container_repositories
          .find(params[:repository_id])
      end

      def tag
        @tag ||= image.tag(params[:id])
      end
    end
  end
end
