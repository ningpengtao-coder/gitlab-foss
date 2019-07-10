# frozen_string_literal: true

class WikiPagePresenter < Gitlab::View::Presenter::Delegated
  presents :wiki_page

  def icon(show_children = false)
    'book'
  end

  def end_of_chain
    self
  end

  def chain
    [self]
  end

  def link_path(project)
    project_wiki_path(project, wiki_page)
  end

  def page_count
    0
  end
end
