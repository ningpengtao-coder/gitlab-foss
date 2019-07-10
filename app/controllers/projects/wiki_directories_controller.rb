# frozen_string_literal: true

class Projects::WikiDirectoriesController < Projects::ApplicationController
  include HasProjectWiki
  include WikiNesting

  before_action :load_dir, only: [:show_dir]
  before_action :set_nesting, only: [:show_dir]
  before_action :set_breadcrumbs, only: [:show_dir]

  # Share the templates from the wikis controller.
  def self.local_prefixes
    [controller_path, 'projects/wikis']
  end

  attr_accessor :project_wiki, :sidebar_page, :sidebar_wiki_entries

  def show_dir
    if @wiki_dir
      pages = case @nesting
              when ProjectWiki::NESTING_FLAT
                flatten_pages(@wiki_dir.pages)
              else
                @wiki_dir.pages
              end

      @wiki_pages = Kaminari
        .paginate_array(pages)
        .page(params[:page])
      @wiki_entries = @wiki_pages

      render 'show_dir'
    else
      render 'empty'
    end
  end

  private

  def set_breadcrumbs
    @breadcrumb_dirs = []
    d = @wiki_dir
    while d && !d.root_dir?
      d = WikiDirectory.new(d.directory)
      @breadcrumb_dirs.unshift(d)
    end
  end

  def flatten_pages(pages)
    pages.flat_map { |page| page.respond_to?(:pages) ? flatten_pages(page.pages) : [page] }
  end

  def load_dir
    @wiki_dir ||= @project_wiki.find_dir(*dir_params)
  end

  def dir_params
    keys = [:id, :sort, :direction]

    params.values_at(*keys)
  end
end
