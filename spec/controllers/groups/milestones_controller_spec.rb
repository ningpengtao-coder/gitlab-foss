# frozen_string_literal: true

require 'spec_helper'

describe Groups::MilestonesController do
  let(:group) { create(:group) }
  let!(:project) { create(:project, group: group) }
  let!(:project2) { create(:project, group: group) }
  let(:user)    { create(:user) }
  let(:title) { '肯定不是中文的问题' }
  let(:milestone) { create(:milestone, project: project) }
  let(:milestone_path) { group_milestone_path(group, milestone.safe_title, title: milestone.title) }

  let(:milestone_params) do
    {
      title: title,
      start_date: Date.today,
      due_date: 1.month.from_now.to_date
    }
  end

  before do
    sign_in(user)
    group.add_owner(user)
    project.add_maintainer(user)
  end

  describe '#index' do
    describe 'as HTML' do
      render_views

      it 'shows group milestones page' do
        milestone

        get :index, params: { group_id: group.to_param }

        expect(response).to have_gitlab_http_status(200)
        expect(response.body).to include(milestone.title)
      end

      it 'searches legacy milestones by title when search_title is given' do
        project_milestone = create(:milestone, project: project, title: 'Project milestone title')

        get :index, params: { group_id: group.to_param, search_title: 'Project mil' }

        expect(response.body).to include(project_milestone.title)
        expect(response.body).not_to include(milestone.title)
      end

      it 'searches group milestones by title when search_title is given' do
        group_milestone = create(:milestone, title: 'Group milestone title', group: group)

        get :index, params: { group_id: group.to_param, search_title: 'Group mil' }

        expect(response.body).to include(group_milestone.title)
        expect(response.body).not_to include(milestone.title)
      end
    end

    context 'as JSON' do
      let!(:milestone) { create(:milestone, group: group, title: 'group milestone') }
      let!(:project_milestone1) { create(:milestone, project: project, title: 'same name') }
      let!(:project_milestone2) { create(:milestone, project: project2, title: 'same name') }

      it 'lists project and group milestones' do
        get :index, params: { group_id: group.to_param }, format: :json

        milestones = json_response

        expect(milestones.count).to eq(3)
        expect(milestones.collect { |m| m['title'] }).to match_array(['same name', 'same name', 'group milestone'])
        expect(response).to have_gitlab_http_status(200)
        expect(response.content_type).to eq 'application/json'
      end
    end

    context 'external authorization' do
      subject { get :index, params: { group_id: group.to_param } }

      it_behaves_like 'disabled when using an external authorization service'
    end
  end

  describe '#show' do
    render_views

    let!(:group_milestone) { create(:milestone, group: group) }

    it 'renders for a group milestone' do
      get :show, params: { group_id: group.to_param, id: group_milestone.iid }

      expect(response).to have_gitlab_http_status(200)
      expect(response.body).to include(group_milestone.title)
    end
  end

  describe "#create" do
    it "creates group milestone with Chinese title" do
      post :create,
           params: {
             group_id: group.to_param,
             milestone: milestone_params
           }

      milestone = Milestone.find_by_title(title)

      expect(response).to redirect_to(group_milestone_path(group, milestone.iid))
      expect(milestone.group_id).to eq(group.id)
      expect(milestone.due_date).to eq(milestone_params[:due_date])
      expect(milestone.start_date).to eq(milestone_params[:start_date])
    end
  end

  describe "#update" do
    let(:milestone) { create(:milestone, group: group) }

    it "updates group milestone" do
      milestone_params[:title] = "title changed"

      put :update,
           params: {
             id: milestone.iid,
             group_id: group.to_param,
             milestone: milestone_params
           }

      milestone.reload
      expect(response).to redirect_to(group_milestone_path(group, milestone.iid))
      expect(milestone.title).to eq("title changed")
    end
  end

  describe "#destroy" do
    let(:milestone) { create(:milestone, group: group) }

    it "removes milestone" do
      delete :destroy, params: { group_id: group.to_param, id: milestone.iid }, format: :js

      expect(response).to be_success
      expect { Milestone.find(milestone.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe '#ensure_canonical_path' do
    before do
      sign_in(user)
    end

    context 'for a GET request' do
      context 'when requesting the canonical path' do
        context 'non-show path' do
          context 'with exactly matching casing' do
            it 'does not redirect' do
              get :index, params: { group_id: group.to_param }

              expect(response).not_to have_gitlab_http_status(301)
            end
          end

          context 'with different casing' do
            it 'redirects to the correct casing' do
              get :index, params: { group_id: group.to_param.upcase }

              expect(response).to redirect_to(group_milestones_path(group.to_param))
              expect(controller).not_to set_flash[:notice]
            end
          end
        end

        context 'show path' do
          context 'with exactly matching casing' do
            it 'does not redirect' do
              get :show, params: { group_id: group.to_param, id: title }

              expect(response).not_to have_gitlab_http_status(301)
            end
          end

          context 'with different casing' do
            it 'redirects to the correct casing' do
              get :show, params: { group_id: group.to_param.upcase, id: title }

              expect(response).to redirect_to(group_milestone_path(group.to_param, title))
              expect(controller).not_to set_flash[:notice]
            end
          end
        end
      end
    end
  end

  context 'for a non-GET request' do
    context 'when requesting the canonical path with different casing' do
      it 'does not 404' do
        post :create,
             params: {
               group_id: group.to_param,
               milestone: { title: title }
             }

        expect(response).not_to have_gitlab_http_status(404)
      end

      it 'does not redirect to the correct casing' do
        post :create,
             params: {
               group_id: group.to_param,
               milestone: { title: title }
             }

        expect(response).not_to have_gitlab_http_status(301)
      end
    end

    context 'when requesting a redirected path' do
      let(:redirect_route) { group.redirect_routes.create(path: 'old-path') }

      it 'returns not found' do
        post :create,
             params: {
               group_id: redirect_route.path,
               milestone: { title: title }
             }

        expect(response).to have_gitlab_http_status(404)
      end
    end
  end

  def group_moved_message(redirect_route, group)
    "Group '#{redirect_route.path}' was moved to '#{group.full_path}'. Please update any links and bookmarks that may still have the old path."
  end
end
