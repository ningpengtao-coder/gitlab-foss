require 'spec_helper'

describe 'Projects > Wiki > User previews markdown changes', :js do
  let(:user) { create(:user) }
  let(:project) { create(:project, :wiki_repo, namespace: user.namespace) }
  let(:project_wiki) { ProjectWiki.new(project, user) }
  let(:wiki_page) { create(:wiki_page, wiki: project.wiki, attrs: { title: 'home', content: '[some link](other-page)' }) }
  let(:wiki_content) do
    <<-HEREDOC
[regular link](regular)
[relative link 1](../relative)
[relative link 2](./relative)
[relative link 3](./e/f/relative)
[spaced link](title with spaces)
    HEREDOC
  end

  before do
    project.add_maintainer(user)

    sign_in(user)

    visit project_wiki_path(project, wiki_page)
  end

  let(:prefix) { project_wiki.wiki_page_path }

  def start_writing!
    find('.add-new-wiki').click
    page.within '#modal-new-wiki' do
      fill_in :new_wiki_path, with: new_wiki_path
      click_button 'Create page'
    end
  end

  def create_page!
    page.within '.wiki-form' do
      fill_in :wiki_page_content, with: 'content'
      click_on "Create page"
    end
  end

  def show_preview!
    page.within '.wiki-form' do
      fill_in :wiki_page_content, with: wiki_content
      click_on "Preview"
    end
  end

  def edit_page!
    click_link 'Edit'
  end

  shared_examples 'correct link relativisation' do |relativised_links|
    it "rewrites relative links as expected" do
      expect(page).to have_content("regular link")
      texts = ['regular link', 'relative link 1', 'relative link 2', 'relative link 3', 'spaced link']
      expected_links = relativised_links.zip(texts).map { |(path, text)| { path: path, text: text } }

      expect(page).to have_links(*expected_links).with_prefix(prefix)
    end
  end

  context "while creating a new wiki page" do
    before do
      start_writing!
      show_preview!
    end

    context "when there are no spaces or hyphens in the page name" do
      let(:new_wiki_path) { 'a/b/c/d' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a/b/relative', 'a/b/c/relative', 'a/b/c/e/f/relative', 'title%20with%20spaces']
    end

    context "when there are spaces in the page name" do
      let(:new_wiki_path) { 'a page/b page/c page/d page' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a-page/b-page/relative', 'a-page/b-page/c-page/relative',
         'a-page/b-page/c-page/e/f/relative', 'title%20with%20spaces']
    end

    context "when there are hyphens in the page name" do
      let(:new_wiki_path) { 'a-page/b-page/c-page/d-page' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a-page/b-page/relative', 'a-page/b-page/c-page/relative',
         'a-page/b-page/c-page/e/f/relative', 'title%20with%20spaces']
    end
  end

  context "while editing a wiki page" do
    before do
      start_writing!
      create_page!
      edit_page!
      show_preview!
    end

    context "when there are no spaces or hyphens in the page name" do
      let(:new_wiki_path) { 'a/b/c/d' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a/b/relative', 'a/b/c/relative', 'a/b/c/e/f/relative', 'title%20with%20spaces']
    end

    context "when there are spaces in the page name" do
      let(:new_wiki_path) { 'a page/b page/c page/d page' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a-page/b-page/relative', 'a-page/b-page/c-page/relative',
         'a-page/b-page/c-page/e/f/relative', 'title%20with%20spaces']
    end

    context "when there are hyphens in the page name" do
      let(:new_wiki_path) { 'a-page/b-page/c-page/d-page' }

      it_behaves_like 'correct link relativisation',
        ['regular', 'a-page/b-page/relative', 'a-page/b-page/c-page/relative',
         'a-page/b-page/c-page/e/f/relative', 'title%20with%20spaces']
    end

    context 'when rendering the preview' do
      let(:new_wiki_path) { 'a-page/b-page/c-page/common-mark' }
      let(:wiki_content) { "1. one\n  - sublist\n" }

      it 'renders content with CommonMark' do
        # the above generates two separate lists (not embedded) in CommonMark
        expect(page).to have_content("sublist")
        expect(page).not_to have_xpath("//ol//li//ul")
      end
    end
  end

  describe 'double brackets within backticks' do
    let(:new_wiki_path) { 'linkify_test' }
    let(:wiki_content) do
      <<-HEREDOC
        `[[do_not_linkify]]`
        ```
        [[also_do_not_linkify]]
        ```
      HEREDOC
    end

    it "does not linkify double brackets inside code blocks as expected" do
      start_writing!
      show_preview!

      expect(page).to have_content("do_not_linkify")

      expect(page.html).to include('[[do_not_linkify]]')
      expect(page.html).to include('[[also_do_not_linkify]]')
    end
  end
end
