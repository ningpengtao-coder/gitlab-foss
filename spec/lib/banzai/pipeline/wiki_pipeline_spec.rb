require 'rails_helper'

describe Banzai::Pipeline::WikiPipeline do
  let(:namespace) { create(:namespace, name: "wiki_link_ns") }
  let(:project) { create(:project, :public, name: "wiki_link_project", namespace: namespace) }
  let(:project_wiki) { ProjectWiki.new(project, double(:user)) }
  let(:page) { build(:wiki_page, wiki: project_wiki, page: OpenStruct.new(url_path: 'nested/twice/start-page')) }
  let(:prefix) { "#{namespace.name}/#{project.name}/wikis/page" }

  describe 'TableOfContents' do
    it 'replaces the tag with the TableOfContentsFilter result' do
      markdown = <<-MD.strip_heredoc
          [[_TOC_]]

          ## Header

          Foo
      MD

      result = described_class.call(markdown, project: spy, project_wiki: spy)

      aggregate_failures do
        expect(result[:output].text).not_to include '[['
        expect(result[:output].text).not_to include 'TOC'
        expect(result[:output].to_html).to include(result[:toc])
      end
    end

    it 'is case-sensitive' do
      markdown = <<-MD.strip_heredoc
          [[_toc_]]

          # Header 1

          Foo
      MD

      output = described_class.to_html(markdown, project: spy, project_wiki: spy)

      expect(output).to include('[[<em>toc</em>]]')
    end

    it 'handles an empty pipeline result' do
      # No Markdown headers in this doc, so `result[:toc]` will be empty
      markdown = <<-MD.strip_heredoc
          [[_TOC_]]

          Foo
      MD

      output = described_class.to_html(markdown, project: spy, project_wiki: spy)

      aggregate_failures do
        expect(output).not_to include('<ul>')
        expect(output).not_to include('[[<em>TOC</em>]]')
      end
    end
  end

  describe "Links" do
    shared_examples 'a correct link rewrite' do
      it 'rewrites links correctly' do
        output = described_class.to_html(markdown, project: project, project_wiki: project_wiki, page_slug: page.slug)

        expect(output).to include("href=\"#{page_href}\"")
      end
    end

    shared_examples 'link examples' do |test_name|
      let(:page_href) { "#{relative_url_root}/#{prefix}/#{expected_page_path}" }

      context "when GitLab is hosted at a #{test_name} URL" do
        before do
          allow(Gitlab.config.gitlab).to receive(:relative_url_root).and_return(relative_url_root)
        end

        describe "linking to pages within the wiki" do
          let(:markdown) { "[Page](#{nesting}page#{extension})" }

          context "when creating hierarchical links to the current directory" do
            let(:nesting) { './' }
            context 'non file links' do
              let(:extension) { '' }
              let(:expected_page_path) { 'nested/twice/page' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'file-like links' do
              let(:extension) { '.md' }
              let(:expected_page_path) { 'nested/twice/page.md' }
              it_behaves_like 'a correct link rewrite'
            end
          end

          context "when creating hierarchical links to the parent directory" do
            let(:nesting) { '../' }
            context "non file links" do
              let(:extension) { '' }
              let(:expected_page_path) { 'nested/page' }
              it_behaves_like 'a correct link rewrite'
            end

            context "file-like links" do
              let(:extension) { '.md' }
              let(:expected_page_path) { 'nested/page.md' }
              it_behaves_like 'a correct link rewrite'
            end
          end

          context "when creating hierarchical links to a sub-directory" do
            let(:nesting) { './subdirectory/' }

            context "non file links" do
              let(:extension) { '' }
              let(:expected_page_path) { 'nested/twice/subdirectory/page' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'file-like links' do
              let(:extension) { '.md' }
              let(:expected_page_path) { 'nested/twice/subdirectory/page.md' }
              it_behaves_like 'a correct link rewrite'
            end
          end

          describe "when creating non-hierarchical links" do
            let(:nesting) { '' }

            context 'non-file links' do
              let(:extension) { '' }
              let(:expected_page_path) { 'page' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'non-file links (with spaces)' do
              let(:extension) { ' slug' }
              let(:expected_page_path) { 'page%20slug' }
              it_behaves_like 'a correct link rewrite'
            end

            context "file links" do
              let(:extension) { '.md' }
              let(:expected_page_path) { 'nested/twice/page.md' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'links with anchor' do
              let(:extension) { '#title' }
              let(:expected_page_path) { 'page#title' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'links (with spaces) with anchor' do
              let(:extension) { ' two#title' }
              let(:expected_page_path) { 'page%20two#title' }
              it_behaves_like 'a correct link rewrite'
            end
          end

          describe "when creating root links" do
            let(:nesting) { '/' }

            context 'non-file links' do
              let(:extension) { '' }
              let(:expected_page_path) { 'page' }
              it_behaves_like 'a correct link rewrite'
            end

            context 'file links' do
              let(:extension) { '.md' }
              let(:expected_page_path) { 'page.md' }
              it_behaves_like 'a correct link rewrite'
            end
          end
        end

        describe "linking to pages outside the wiki (absolute)" do
          let(:markdown) { "[Link to Page](http://example.com/page)" }
          let(:page_href)  { 'http://example.com/page' }
          it_behaves_like 'a correct link rewrite'
        end
      end
    end

    include_examples 'link examples', :root do
      let(:relative_url_root) { '/' }
    end

    include_examples 'link examples', :relative do
      let(:relative_url_root) { '/nested/relative/gitlab' }
    end
  end

  describe 'videos' do
    shared_examples 'correct video rewrite' do
      let(:markdown) { "![video_file](#{file_name})" }
      let(:video_fragment) { "<video src=\"/#{prefix}/#{expected_file_path}\"" }

      it 'generates video html structure' do
        output = described_class.to_html(markdown, project: project, project_wiki: project_wiki, page_slug: page.slug)

        expect(output).to include(video_fragment)
      end
    end

    context 'underscores' do
      let(:file_name) { 'video_file_name.mp4' }
      let(:expected_file_path) { 'nested/twice/video_file_name.mp4' }
      it_behaves_like 'correct video rewrite'
    end

    context 'spaces' do
      let(:file_name) { 'video file name.mp4' }
      let(:expected_file_path) { 'nested/twice/video%20file%20name.mp4' }
      it_behaves_like 'correct video rewrite'
    end
  end
end
