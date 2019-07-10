# frozen_string_literal: true

module EmptyActions
  extend ActiveSupport::Concern

  included do
    def self.empty_action(*syms)
      syms.each do |sym|
        self.define_method(sym) { }
      end
    end
  end
end
