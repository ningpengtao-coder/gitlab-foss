# frozen_string_literal: true

class ProjectEntity < Grape::Entity
  include RequestAwareEntity

  expose :id
  expose :name

  expose :full_path do |project|
    project_path(project)
  end

  expose :full_name, &:full_name
end
