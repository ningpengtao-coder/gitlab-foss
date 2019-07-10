# frozen_string_literal: true
module WikiNesting
  extend ActiveSupport::Concern

  # One of ProjectWiki::NESTINGS
  def show_children_param
    default_val = case params[:sort]
                  when ProjectWiki::CREATED_AT_ORDER
                    ProjectWiki::NESTING_FLAT
                  else
                    ProjectWiki::NESTING_CLOSED
                  end

    params.permit(:show_children).fetch(:show_children, default_val)
  end

  included do
    def set_nesting
      @nesting = show_children_param
      @show_children = @nesting != ProjectWiki::NESTING_CLOSED
    end
  end
end
