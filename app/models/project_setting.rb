# frozen_string_literal: true

class ProjectSetting < ActiveRecord::Base
  belongs_to :project

  validates :forking_access_level, presence: true
end
