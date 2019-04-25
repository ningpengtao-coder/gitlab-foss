# frozen_string_literal: true

module API
  class Releases < Grape::API
    include PaginationParams

    RELEASE_ENDPOINT_REQUIREMETS = API::NAMESPACE_OR_PROJECT_REQUIREMENTS
      .merge(tag_name: API::NO_SLASH_URL_PART_REGEX)

    before { authorize_read_releases! }

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end
    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      desc 'Get a project releases' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Release
      end
      params do
        use :pagination
      end
      get ':id/releases' do
        releases = ::ReleasesFinder.new(user_project, current_user).execute

        present paginate(releases), with: Entities::Release, current_user: current_user
      end

      desc 'Get a single project release' do
        detail 'Finding release by tag name  has been deprecated in Gitlab 11.11 and will be removed in 12.0. Switch to using `GET /projects/:id/releases/:release_id` instead.'
        success Entities::Release
      end
      params do
        requires :tag_name, type: String, desc: 'The name of the tag', as: :tag
      end
      get ':id/releases/:tag_name', requirements: RELEASE_ENDPOINT_REQUIREMETS do
        # Deprecate `:id/releases/:tag_name` in GitLab 11.11.
        # We want to introduce `:id/releases/:release_id` which is basicaly the same route,
        # so for the time being we need to make this endpoint support both.
        # If release with such tag exists behave like the old endpoint,
        # otherwise act like looking up release by id.
        # Cleanup once we remove `:id/releases/:tag_name` in GitLab 12.0.
        if release_by_tag
          authorize! :download_code, release_by_tag
          present release_by_tag, with: Entities::Release, current_user: current_user
        elsif release_by_id
          authorize! :read_release, release_by_id
          present release_by_id, with: Entities::Release, current_user: current_user
        else
          forbidden!
        end
      end

      desc 'Create a new release' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Release
      end
      params do
        requires :tag_name,    type: String, desc: 'The name of the tag', as: :tag
        requires :name,        type: String, desc: 'The name of the release'
        requires :description, type: String, desc: 'The release notes'
        optional :ref,         type: String, desc: 'The commit sha or branch name'
        optional :assets, type: Hash do
          optional :links, type: Array do
            requires :name, type: String
            requires :url, type: String
          end
        end
      end
      post ':id/releases' do
        authorize_create_release!

        result = ::Releases::CreateService
          .new(user_project, current_user, declared_params(include_missing: false))
          .execute

        if result[:status] == :success
          present result[:release], with: Entities::Release, current_user: current_user
        else
          render_api_error!(result[:message], result[:http_status])
        end
      end

      desc 'Update a release' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Release
      end
      params do
        requires :tag_name,    type: String, desc: 'The name of the tag', as: :tag
        optional :name,        type: String, desc: 'The name of the release'
        optional :description, type: String, desc: 'Release notes with markdown support'
      end
      put ':id/releases/:tag_name', requirements: RELEASE_ENDPOINT_REQUIREMETS do
        authorize_update_release!

        result = ::Releases::UpdateService
          .new(user_project, current_user, declared_params(include_missing: false))
          .execute

        if result[:status] == :success
          present result[:release], with: Entities::Release, current_user: current_user
        else
          render_api_error!(result[:message], result[:http_status])
        end
      end

      desc 'Delete a release' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Release
      end
      params do
        requires :tag_name, type: String, desc: 'The name of the tag', as: :tag
      end
      delete ':id/releases/:tag_name', requirements: RELEASE_ENDPOINT_REQUIREMETS do
        authorize_destroy_release!

        result = ::Releases::DestroyService
          .new(user_project, current_user, declared_params(include_missing: false))
          .execute

        if result[:status] == :success
          present result[:release], with: Entities::Release, current_user: current_user
        else
          render_api_error!(result[:message], result[:http_status])
        end
      end
    end

    helpers do
      def authorize_create_release!
        authorize! :create_release, user_project
      end

      def authorize_read_releases!
        authorize! :read_release, user_project
      end

      def authorize_update_release!
        authorize! :update_release, release
      end

      def authorize_destroy_release!
        authorize! :destroy_release, release
      end

      def release
        @release ||= user_project.releases.find_by_tag(params[:tag])
      end

      def release_by_tag
        release
      end

      def release_by_id
        @release_by_id ||= user_project.releases.find_by_id(params[:tag])
      end
    end
  end
end
