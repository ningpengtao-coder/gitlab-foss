# frozen_string_literal: true

class DescriptionChange < ApplicationRecord
  belongs_to :system_note, class_name: 'Note'

  validates :system_note, presence: true
end
