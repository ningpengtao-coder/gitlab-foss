# frozen_string_literal: true

class WikiDirectory
  include StaticModel
  include HasWikiDirectory
  include Presentable
  include ActiveModel::Validations

  attr_accessor :slug, :pages

  validates :slug, presence: true

  # StaticModel overrides and configuration:

  def self.primary_key
    'slug'
  end

  def id
    "#{slug}@#{last_version&.sha}"
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'wiki_dir')
  end

  alias_method :to_param, :slug

  class << self
    # Sorts and groups pages by directory.
    #
    # pages - an array of WikiPage objects.
    #
    # Returns an array of WikiPage and WikiDirectory objects.
    # The entries are sorted in the order of the input array, where
    # directories appear in the position of their first member.
    def group_by_directory(pages)
      grouped = []
      dirs = grouping_map(grouped)

      (pages.presence || []).each_with_object(grouped) do |page, top_level|
        group = page.directory.present? ? dirs[page.directory] : top_level

        group << page
      end
    end

    private

    def grouping_map(top_level)
      Hash.new do |h, k|
        new(k).tap do |dir|
          h[k] = dir
          parent = dir.root_dir? ? top_level : h[dir.directory]
          parent << dir
        end
      end
    end
  end

  def initialize(slug, pages = [])
    @slug = slug
    @pages = pages
  end

  def <<(child)
    @pages << child
    @last_version = nil
  end

  def last_version
    @last_version ||= @pages.map(&:last_version).max_by(&:authored_date)
  end

  def page_count
    @pages.size
  end

  def root_dir?
    path = Gitlab::WikiPath.parse(slug)
    path.root_level?
  end

  def depth
    Gitlab::WikiPath.parse(slug).depth
  end

  def title
    Gitlab::WikiPath.parse(slug).basename
  end

  # Relative path to the partial to be used when rendering collections
  # of this object.
  def to_partial_path
    'projects/wikis/wiki_directory'
  end
end
