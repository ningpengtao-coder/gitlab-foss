# frozen_string_literal: true

module Gitlab
  class BatchModelLoader
    attr_reader :model_class

    def self.for(model_class)
      Gitlab::SafeRequestStore.store.fetch("#{self}/for/#{model_class}") do
        new(model_class)
      end
    end

    def initialize(model_class)
      @model_class = model_class
    end

    # rubocop: disable CodeReuse/ActiveRecord
    def find(model_id)
      BatchLoader.for(model_id.to_i).batch(key: model_class) do |ids, found|
        model_class.where(id: ids).each { |model| found[model.id, model] }
      end
    end
    # rubocop: enable CodeReuse/ActiveRecord
  end
end
