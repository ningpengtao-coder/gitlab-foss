# frozen_string_literal: true

class Groups::MilestonesController < Groups::ApplicationController
  before_action :group_projects
  before_action :milestone, only: [:edit, :show, :update, :destroy]
  before_action :authorize_admin_milestones!, only: [:edit, :new, :create, :update, :destroy]

  def index
    respond_to do |format|
      format.html do
        @milestone_states = Milestone.states_count(group_projects, [group])
        @milestones = milestones.page(params[:page])
      end
      format.json do
        render json: milestones.to_json(only: [:id, :title], methods: :name)
      end
    end
  end

  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = Milestones::CreateService.new(group, current_user, milestone_params).execute

    if @milestone.persisted?
      redirect_to milestone_path(@milestone)
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    Milestones::UpdateService.new(@milestone.parent, current_user, milestone_params).execute(@milestone)

    redirect_to milestone_path(@milestone)
  end

  def destroy
    Milestones::DestroyService.new(group, current_user).execute(@milestone)

    respond_to do |format|
      format.html { redirect_to group_milestones_path(group), status: :see_other }
      format.js { head :ok }
    end
  end

  private

  def authorize_admin_milestones!
    return render_404 unless can?(current_user, :admin_milestone, group)
  end

  def milestone_params
    params.require(:milestone).permit(:title, :description, :start_date, :due_date, :state_event)
  end

  def milestones
    MilestonesFinder.new(search_params).execute
  end

  def milestone
    @milestone = group.milestones.find_by_iid(params[:id])

    render_404 unless @milestone
  end

  def search_params
    @sort = params[:sort] || 'due_date_asc'
    params.permit(:state, :search_title).merge(sort: @sort, group_ids: group.id, project_ids: group_projects)
  end
end
