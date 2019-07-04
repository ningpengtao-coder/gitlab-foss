# frozen_string_literal: true

require 'spec_helper'

describe 'User views wiki pages' do
  include WikiHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project, :wiki_repo, namespace: user.namespace) }
  let(:project_wiki) { ProjectWiki.new(project, user) }

  let!(:wiki_page1) do
    create(:wiki_page, wiki: project.wiki, attrs: { title: '3 home', content: '3' })
  end
  let!(:wiki_page2) do
    create(:wiki_page, wiki: project.wiki, attrs: { title: '1 home', content: '1' })
  end
  let!(:wiki_page3) do
    create(:wiki_page, wiki: project.wiki, attrs: { title: '2 home', content: '2' })
  end
  let!(:wiki_page4) do
    create(:wiki_page, wiki: project.wiki, attrs: { title: 'sub-folder/0', content: 'a' })
  end
  let!(:wiki_page5) do
    create(:wiki_page, wiki: project.wiki, attrs: { title: 'sub-folder/b', content: 'b' })
  end

  let(:page_link_selector) { 'a' }

  let(:pages) do
    page.all(".wiki-pages-list li #{page_link_selector}")
  end

  before do
    project.add_maintainer(user)
    sign_in(user)
    visit(project_wikis_pages_path(project))
  end

  def sort_desc!
    page.within('.wiki-sort-dropdown') do
      page.find('.qa-reverse-sort').click
    end
  end

  def sort_by_created_at!
    page.within('.wiki-sort-dropdown') do
      click_button('Title')
      click_link('Created date')
    end
  end

  shared_examples 'correctly_sorted_pages' do
    it 'has pages displayed in correct order' do
      displayed_texts = pages.map(&:text)
      expect(displayed_texts).to eq expected_sequence.map(&:title)
    end
  end

  context 'ordered by title' do
    let(:sub_folder) { project_wiki.find_dir('sub-folder') }

    context 'asc' do
      let(:expected_sequence) { [wiki_page2, wiki_page3, wiki_page1, sub_folder, wiki_page4, wiki_page5] }

      it_behaves_like 'correctly_sorted_pages'
    end

    context 'nested' do
      before do
        page.within('.wiki-nesting-dropdown') do
          click_link 'Hide folder contents'
        end
      end

      let(:expected_sequence) { [wiki_page2, wiki_page3, wiki_page1, sub_folder] }

      it_behaves_like 'correctly_sorted_pages'

      context 'desc' do
        before do
          sort_desc!
        end

        let(:expected_sequence) { [sub_folder, wiki_page1, wiki_page3, wiki_page2] }

        it_behaves_like 'correctly_sorted_pages'
      end
    end

    context 'flat' do
      before do
        page.within('.wiki-nesting-dropdown') do
          click_link 'Show files separately'
        end
      end

      let(:page_link_selector) { 'a.wiki-page-title' }

      let(:expected_sequence) { [wiki_page2, wiki_page3, wiki_page1, wiki_page4, wiki_page5] }

      it_behaves_like 'correctly_sorted_pages'

      context 'desc' do
        before do
          sort_desc!
        end

        let(:expected_sequence) { [wiki_page5, wiki_page4, wiki_page1, wiki_page3, wiki_page2] }

        it_behaves_like 'correctly_sorted_pages'
      end
    end

    context 'desc' do
      before do
        sort_desc!
      end

      let(:expected_sequence) { [sub_folder, wiki_page5, wiki_page4, wiki_page1, wiki_page3, wiki_page2] }

      it_behaves_like 'correctly_sorted_pages'
    end
  end

  context 'ordered by created_at' do
    let(:pages_ordered_by_created_at) { [wiki_page1, wiki_page2, wiki_page3, wiki_page4, wiki_page5] }

    before do
      sort_by_created_at!
    end

    let(:page_link_selector) { 'a.wiki-page-title' }

    context 'asc' do
      let(:expected_sequence) { [wiki_page1, wiki_page2, wiki_page3, wiki_page4, wiki_page5] }

      it_behaves_like 'correctly_sorted_pages'
    end

    context 'desc' do
      before do
        sort_desc!
      end

      let(:expected_sequence) { [wiki_page5, wiki_page4, wiki_page3, wiki_page2, wiki_page1] }

      it_behaves_like 'correctly_sorted_pages'
    end
  end
end
