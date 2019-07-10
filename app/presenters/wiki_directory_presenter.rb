# frozen_string_literal: true

class WikiDirectoryPresenter < Gitlab::View::Presenter::Delegated
  presents :wiki_directory

  def icon(show_children = false)
    show_children ? 'folder-open' : 'folder-o'
  end

  def end_of_chain
    chain.last
  end

  def chain
    @chain ||= if page_count == 1
                 [self] + pages.first.present.chain
               else
                 [self]
               end
  end

  def link_path(project)
    project_wiki_dir_path(project, wiki_directory)
  end
end
