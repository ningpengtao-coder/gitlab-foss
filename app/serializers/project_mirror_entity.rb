# frozen_string_literal: true

class ProjectMirrorEntity < Grape::Entity
  expose :id

  expose :remote_mirrors_attributes, using: RemoteMirrorEntity, &:remote_mirrors
end
