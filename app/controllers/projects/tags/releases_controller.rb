# frozen_string_literal: true

class Projects::Tags::ReleasesController < Projects::ApplicationController
  # Authorize
  before_action :require_non_empty_project
  before_action :authorize_download_code!
  before_action :authorize_update_release!
  before_action :tag
  before_action :release

  def edit
  end

  def update
    ##
    # Previously, we destroyed release object when description is empty,
    # however, this is not the case anymore because releases persist variaous
    # information, such as assets, today.
    if release.update(release_params)
      redirect_to project_tag_path(@project, @tag.name)
    else
      render :edit
    end
  end

  private

  def tag
    @tag ||= @repository.find_tag(params[:tag_id])
  end

  def sha
    @sha ||= tag.dereferenced_target.id
  end

  def release
    @release ||= @project.releases.find_by_tag(tag.name) || build_release
  end

  def release_params
    params.require(:release).permit(:description)
  end

  ##
  # Legacy release creation form does not have `name` input.
  # We should fill it with tag_name because `name` is requied parameter today.
  def build_release
    @project.releases.build(tag: tag.name, name: tag.name, sha: sha)
  end

  def authorize_update_release!
    return access_denied! unless can?(current_user, :update_release, release)
  end
end
