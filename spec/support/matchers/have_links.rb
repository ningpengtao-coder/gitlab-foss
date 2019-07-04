# frozen_string_literal: true

require 'set'

# For use in feature tests, to test a group of link targets
module Gitlab
  module Matchers
    class HasLinks
      attr_reader :page, :links

      def initialize(page, links, prefix = nil, enforce_absolute = false)
        @page = page
        @links = links
        @prefix = prefix
        @enforce_absolute = enforce_absolute
      end

      def base
        @base ||= base_url(page)
      end

      def prefix
        @prefix.presence
      end

      def has_all_links?
        links.all? { |target| has_link(target) }
      end

      def has_link(link)
        if link[:text].present?
          page.has_link?(link[:text], href: full_url(link))
        else
          xpath_selector = "//a[href='#{full_url(link)}']"
          page.has_xpath?(xpath_selector)
        end
      end

      def missing_links
        links.reject { |link| has_link(link) }
      end

      def incorrect_links
        links.select { |link| link[:text].present? }.flat_map do |link|
          a = page.find_link link[:text]
          if a.present? && a[:href] != full_url(link)
            [{ text: link[:text], href: a[:href] }]
          else
            []
          end
        end
      end

      # Useful in debugging
      def all_links
        page.all('a').map { |a| { text: a.text, href: a[:href] } }
      end

      def full_url(path:, **_kws)
        u = URI.parse(::File.join([prefix, path].compact))
        u.relative? && @enforce_absolute ? ::File.join(base, u.to_s) : u.to_s
      end

      def base_url(page)
        uri = URI.parse(page.current_url)
        uri.path = ''
        uri.query = nil
        uri.to_s
      end
    end
  end
end

# Usage:
#
#   expect(page).to have_links({path: '/foo/bar', text: 'x'}).with_prefix(some_prefix)
#   expect(page).to have_links(path: '/foo')
#
# When no text is provided, elements will match if there is at least one link with the given
# URL. Link targets can be defined absolutely or relatively. Relative links will be expected
# to have matches for the current URL's host and port.
RSpec::Matchers.define :have_links do |*links|
  chain :with_prefix do |prefix|
    @prefix = prefix + '/'
  end

  chain :absolute do
    @enforce_absolute = true
  end

  match do |page|
    expect(Gitlab::Matchers::HasLinks.new(page, links, @prefix, @enforce_absolute)).to have_all_links
  end

  failure_message do |page|
    has_links = Gitlab::Matchers::HasLinks.new(page, links, @prefix, @enforce_absolute)
    [
      "Missing links: #{format_list(has_links.missing_links)}",
      "Found but incorrect: #{format_list(has_links.incorrect_links)}"
    ].join("\n")
  end

  failure_message_when_negated do |page|
    has_links = Gitlab::Matchers::HasLinks.new(page, links, @prefix, @enforce_absolute)
    unexpected = links.select { |target| has_links.has_link(target) }
    "expected not to find the following links: #{format_list(unexpected)}"
  end

  def format_list(things)
    return 'NONE' unless things.present?

    sep = "\n\t * "
    sep + things.map(&:to_s).join(sep)
  end
end
