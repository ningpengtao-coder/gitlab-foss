# frozen_string_literal: true

class ProjectSetting < ApplicationRecord
  belongs_to :project

  validates :forking_access_level, presence: true
  validates :fork_visibility_level, presence: true
end
