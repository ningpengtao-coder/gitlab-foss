# frozen_string_literal: true

module NullSorting
  extend ActiveSupport::Concern

  included do
    scope :order_id_asc_nulls_first, -> { order(Gitlab::Database.nulls_first_order('id', 'ASC')) }
  end
end
