# frozen_string_literal: true

class ContainerRepositoriesFinder
  # subject: group or project
  def initialize(user:, subject:)
    @user = user
    @subject = subject
  end

  def execute
    return unless allowed_subjects.include?(@subject.class)
    return unless Ability.allowed?(@user, :read_container_image, @subject)

    @subject.container_repositories
  end

  private

  def allowed_subjects
    [Project, Group]
  end
end
