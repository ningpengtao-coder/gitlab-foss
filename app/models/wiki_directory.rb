# frozen_string_literal: true

class WikiDirectory
  include ActiveModel::Validations

  attr_accessor :slug, :pages

  validates :slug, presence: true

  def initialize(slug, pages = [])
    @slug = slug
    @pages = pages
  end

  def <<(page)
    @pages << page
    @last_version = nil
  end

  def last_version
    @last_version ||= @pages.map(&:last_version).max_by(&:created_at)
  end

  def page_count
    @pages.size
  end

  # Relative path to the partial to be used when rendering collections
  # of this object.
  def to_partial_path
    'projects/wikis/wiki_directory'
  end
end
