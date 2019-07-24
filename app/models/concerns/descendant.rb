# frozen_string_literal: true

module Descendant
  extend ActiveSupport::Concern

  class_methods do
    def supports_nested_objects?
      # TODO: Refactor and remove https://gitlab.com/gitlab-org/gitlab-ce/issues/65056
      true
    end
  end
end
