# frozen_string_literal: true

module HasWikiDirectory
  extend ActiveSupport::Concern

  # The hierarchy of the directory this object is contained in.
  def directory
    ::Gitlab::WikiPath.parse(slug).dirname
  end
end
