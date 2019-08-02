# frozen_string_literal: true

require 'rails_helper'

describe 'Multiple Issue Boards', :js do
  let(:user) { create(:user) }
  let(:project) { create(:project, :public) }
  let!(:planning) { create(:label, project: project, name: 'Planning') }
  let!(:board) { create(:board, name: 'board1', project: project) }
  let!(:board2) { create(:board, name: 'board2', project: project) }
  let(:parent) { project }
  let(:boards_path) { project_boards_path(project) }

  it_behaves_like 'multiple issue boards'
end
