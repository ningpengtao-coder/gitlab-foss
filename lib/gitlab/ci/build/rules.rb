# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      class Rules
        def self.fabricate(rule_list)
		    	rule_list.to_a.map { |rule_hash| Rule.new(rule_hash) }.compact
        end
      end
    end
  end
end
