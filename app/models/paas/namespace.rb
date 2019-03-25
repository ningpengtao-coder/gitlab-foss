# frozen_string_literal: true

module Paas
  class Namespace < ApplicationRecord
    self.table_name = 'paas_namespaces'

    belongs_to :cluster, class_name: 'Clusters::Cluster'
    belongs_to :project

    validates :name, presence: true
  end
end
