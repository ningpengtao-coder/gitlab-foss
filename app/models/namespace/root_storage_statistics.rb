# frozen_string_literal: true

class Namespace::RootStorageStatistics < ApplicationRecord
  belongs_to :namespace
  has_one :route, through: :namespace

  delegate :all_projects, to: :namespace
end
