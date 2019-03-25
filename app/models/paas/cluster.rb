# frozen_string_literal: true

module Paas
  class Cluster < ActiveRecord::Base
    self.table_name = 'paas_clusters'

    attr_encrypted :token,
      mode: :per_attribute_iv,
      key: Settings.attr_encrypted_db_key_base_truncated,
      algorithm: 'aes-256-cbc'

    validates :name, presence: true
    validates :api_url, public_url: true, presence: true
    validates :token, presence: true
  end
end
