# frozen_string_literal: true

module Types
  class Types::Sort < Types::BaseEnum
    value "updated_desc", "Updated at descending order"
    value "updated_asc", "Updated at ascending order"
    value "created_desc", "Created at descending order"
    value "created_asc", "Created at ascending order"
    value "id_asc", "ID ascending order"
    value "id_desc", "ID descending order"
  end
end
