#!/usr/bin/env ruby
# frozen_string_literal: true

class Release
  attr_reader :edition, :tag

  def initialize(edition, tag)
    @edition = edition
    @tag = tag
  end

  def valid?
    /^$/.match(tag) && /^$/.match(previous_tag)
  end

  def create
    return unless valied?

    # curl --header 'Content-Type: application/json' \
    #   --header "PRIVATE-TOKEN: $GITLAB_RELEASE_API_TOKEN" \
    #   --data '{ "name": "${name}", "tag_name": "${tag_name}", "description": "${changelog}" }' \
    #   --request POST \
    #   http://gitlab.com/api/v4/projects/$CI_PROJECT_ID/releases
  end

  private

  def previous_release

  end

  def changelog_path
    './CHANGELOG.md'
  end

  def changelog_diff

  end
end

Release.new("CE", ENV['CI_COMMIT_TAG']).create
