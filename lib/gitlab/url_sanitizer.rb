# frozen_string_literal: true

module Gitlab
  class UrlSanitizer
    ALLOWED_SCHEMES = %w[http https ssh git].freeze
    SINGLE_QUOTE = "'"

    def self.sanitize(content)
      regexp = URI::DEFAULT_PARSER.make_regexp(ALLOWED_SCHEMES)

      content.gsub(regexp) do |url|
        # Unfortunately, URI::DEFAULT_PARSER.make_regexp returns a regular expression which hungrily consumes
        # single quotes at the end of a string. When the querystring is filtered, the quote is converted into a %27
        # which can affect error messages which quote the URL with singlequotes.
        #
        # Note the regular expression issue does not affect double-quotes nor backticks.
        if url.end_with?(SINGLE_QUOTE)
          url_without_quote = url.delete_suffix(SINGLE_QUOTE)
          masked_unquoted_url = new(url_without_quote).masked_url
          masked_unquoted_url + SINGLE_QUOTE
        else
          new(url).masked_url
        end
      end
    rescue Addressable::URI::InvalidURIError
      content.gsub(regexp, '')
    end

    def self.valid?(url)
      return false unless url.present?
      return false unless url.is_a?(String)

      uri = Addressable::URI.parse(url.strip)

      ALLOWED_SCHEMES.include?(uri.scheme)
    rescue Addressable::URI::InvalidURIError
      false
    end

    def initialize(url, credentials: nil)
      %i[user password].each do |symbol|
        credentials[symbol] = credentials[symbol].presence if credentials&.key?(symbol)
      end

      @credentials = credentials
      @url = parse_url(url)
    end

    def sanitized_url
      @sanitized_url ||= safe_url.to_s
    end

    def masked_url
      url = @url.dup
      url.password = "*****" if url.password.present?
      url.user = "*****" if url.user.present?
      url.query = filter_query(url.query) if url.query.present?
      url.to_s
    end

    def credentials
      @credentials ||= { user: @url.user.presence, password: @url.password.presence }
    end

    def full_url
      @full_url ||= generate_full_url.to_s
    end

    private

    def param_filter
      @param_filter ||= ActionDispatch::Http::ParameterFilter.new(Rails.application.config.filter_parameters)
    end

    def filter_query(query)
      qs = CGI.parse(query)
      qs = param_filter.filter(qs)
      URI.encode_www_form(qs)
    end

    def parse_url(url)
      url             = url.to_s.strip
      match           = url.match(%r{\A(?:git|ssh|http(?:s?))\://(?:(.+)(?:@))?(.+)})
      raw_credentials = match[1] if match

      if raw_credentials.present?
        url.sub!("#{raw_credentials}@", '')

        user, _, password = raw_credentials.partition(':')
        @credentials ||= { user: user.presence, password: password.presence }
      end

      url = Addressable::URI.parse(url)
      url.password = password if password.present?
      url.user = user if user.present?
      url
    end

    def generate_full_url
      return @url unless valid_credentials?

      @url.dup.tap do |generated|
        generated.password = encode_percent(credentials[:password]) if credentials[:password].present?
        generated.user = encode_percent(credentials[:user]) if credentials[:user].present?
      end
    end

    def safe_url
      safe_url = @url.dup
      safe_url.password = nil
      safe_url.user = nil
      safe_url
    end

    def valid_credentials?
      credentials && credentials.is_a?(Hash) && credentials.any?
    end

    def encode_percent(string)
      # CGI.escape converts spaces to +, but this doesn't work for git clone
      CGI.escape(string).gsub('+', '%20')
    end
  end
end
