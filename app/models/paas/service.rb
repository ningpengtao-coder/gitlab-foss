# frozen_string_literal: true

module Paas
  class Service < ApplicationRecord
    self.table_name = 'paas_services'

    belongs_to :namespace, class_name: 'Paas::Namespace'

    delegate :project, to: :namespace

    validates :name, presence: true
    validates :image, presence: true
    validates :domain, hostname: { allow_numeric_hostname: true }
  end
end
