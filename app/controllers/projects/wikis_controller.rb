# frozen_string_literal: true

class Projects::WikisController < Projects::ApplicationController
  include HasProjectWiki
  include WikiNesting

  attr_accessor :project_wiki, :sidebar_page, :sidebar_wiki_entries

  before_action :set_nesting, only: [:pages]

  def pages
    @wiki_pages = Kaminari.paginate_array(
      @project_wiki.list_pages(sort: params[:sort], direction: params[:direction])
    ).page(params[:page])

    @wiki_entries = case @nesting
                    when ProjectWiki::NESTING_FLAT
                      @wiki_pages
                    else
                      WikiDirectory.group_by_directory(@wiki_pages)
                    end
  end

  def git_access
  end
end
