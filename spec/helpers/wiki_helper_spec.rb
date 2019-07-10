require 'spec_helper'

describe WikiHelper do
  describe '#breadcrumb' do
    context 'when the page is at the root level' do
      it 'returns the capitalized page name' do
        slug = 'page-name'

        expect(helper.breadcrumb(slug)).to eq('Page name')
      end
    end

    context 'when the page is inside a directory' do
      it 'returns the capitalized name of each directory and of the page itself' do
        slug = 'dir_1/page-name'

        expect(helper.breadcrumb(slug)).to eq('Dir_1 / Page name')
      end
    end
  end

  describe '#wiki_sort_controls' do
    let(:project) { create(:project) }
    let(:classes) { "btn btn-default has-tooltip reverse-sort-btn qa-reverse-sort" }
    let(:wiki_link) do
      helper.wiki_sort_controls(sort: sort, direction: direction) do |opts|
        project_wikis_pages_path(project, opts)
      end
    end

    def expected_link(sort, direction, icon_class)
      path = "/#{project.full_path}/wikis/pages?direction=#{direction}&sort=#{sort}"

      helper.link_to(path, type: 'button', class: classes, title: 'Sort direction') do
        helper.sprite_icon("sort-#{icon_class}", size: 16)
      end
    end

    context 'initial call' do
      let(:sort) { nil }
      let(:direction) { nil }

      it 'renders with default values' do
        expect(wiki_link).to eq(expected_link('title', 'desc', 'lowest'))
      end
    end

    context 'sort by title' do
      let(:sort) { 'title' }
      let(:direction) { 'asc' }

      it 'renders a link with opposite direction' do
        expect(wiki_link).to eq(expected_link('title', 'desc', 'lowest'))
      end
    end

    context 'sort by created_at' do
      let(:sort) { 'created_at' }
      let(:direction) { 'desc' }

      it 'renders a link with opposite direction' do
        expect(wiki_link).to eq(expected_link('created_at', 'asc', 'highest'))
      end
    end
  end

  describe '#wiki_show_children_title' do
    ProjectWiki::NESTINGS.each do |nesting|
      context "When the nesting parameter is `#{nesting}`" do
        let(:element) { helper.wiki_show_children_title(nesting) }

        it 'produces something that contains an SVG' do
          expect(element).to match(/svg/)
        end
      end
    end
  end

  describe '#wiki_sort_title' do
    it 'returns a title corresponding to a key' do
      expect(helper.wiki_sort_title('created_at')).to eq('Created date')
      expect(helper.wiki_sort_title('title')).to eq('Title')
    end

    it 'defaults to Title if a key is unknown' do
      expect(helper.wiki_sort_title('unknown')).to eq('Title')
    end
  end

  describe '#wiki_pages_wiki_page_link' do
    let(:project) { create(:project, :wiki_repo) }
    let(:project_wiki) { ProjectWiki.new(project, project.owner) }
    let(:page) { project_wiki.build_page(title: 'foo/bar/baz', content: 'blah') }

    let(:link) { helper.wiki_pages_wiki_page_link(page, nesting, project, current_dir) }
    let(:prefix) { "#{project.namespace.name}/#{project.name}/wikis" }
    let(:separator) { '<span class="wiki-page-name-separator">/</span>' }
    let(:foo_part) { %Q(<a class="wiki-page-dir-name" href="/#{prefix}/dir/foo">foo</a>) }
    let(:bar_part) { %Q(<a class="wiki-page-dir-name" href="/#{prefix}/dir/foo/bar">bar</a>) }
    let(:baz_part) { %Q(<a class="wiki-page-title" href="/#{prefix}/page/foo/bar/baz">foo/bar/baz</a>) }

    shared_examples 'when not flat mode' do
      [ProjectWiki::NESTING_CLOSED, ProjectWiki::NESTING_TREE].each do |nesting_mode|
        context "the nesting is #{nesting_mode}" do
          let(:nesting) { nesting_mode }

          it 'produces a good link' do
            expect(link).to eq baz_part
          end
        end
      end
    end

    context 'there is no current dir' do
      let(:current_dir) { nil }
      context 'the nesting is flat' do
        let(:nesting) { ProjectWiki::NESTING_FLAT }

        it 'produces a good link' do
          expected = [foo_part, bar_part, baz_part].join(separator)
          expect(link).to eq expected
        end
      end

      include_examples 'when not flat mode'
    end

    context 'there is a current dir' do
      let(:current_dir) { 'foo' }
      context 'the nesting is flat' do
        let(:nesting) { ProjectWiki::NESTING_FLAT }

        it 'produces a good link' do
          expected = [bar_part, baz_part].join(separator)
          expect(link).to eq expected
        end
      end

      include_examples 'when not flat mode'
    end
  end
end
