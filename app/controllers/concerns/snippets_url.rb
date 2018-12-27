# frozen_string_literal: true

module SnippetsUrl
  extend ActiveSupport::Concern

  SNIPPETS_SECRET_KEYWORD = 'secret'

  private

  attr_reader :snippet

  def authorize_secret_snippet!
    if snippet_is_secret?
      return if secrets_match?(params[SNIPPETS_SECRET_KEYWORD])

      return render_404
    end

    current_user ? render_404 : authenticate_user!
  end

  def snippet_is_secret?
    snippet&.secret?
  end

  def secrets_match?(secret)
    ActiveSupport::SecurityUtils.secure_compare(secret.to_s, snippet.secret)
  end

  def ensure_complete_url
    redirect_to(complete_full_path.to_s) if redirect_to_complete_full_path?
  end

  def redirect_to_complete_full_path?
    return unless snippet_is_secret?

    complete_full_path != current_full_path
  end

  def complete_full_path
    @complete_full_path ||= begin
      path = current_full_path.clone
      secret_query = { SNIPPETS_SECRET_KEYWORD => snippet.secret }
      path.query = current_url_query_hash.merge(secret_query).to_query
      path
    end
  end

  def current_full_path
    @current_full_path ||= begin
      path = URI.parse(current_url.path.chomp('/'))
      path.query = current_url_query_hash.to_query unless current_url_query_hash.empty?
      path
    end
  end

  def current_url
    @current_url ||= URI.parse(request.original_url)
  end

  def current_url_query_hash
    @current_url_query_hash ||= Rack::Utils.parse_nested_query(current_url.query)
  end
end
