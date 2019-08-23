# frozen_string_literal: true

module Clusters
  module Providers
    class Aws < ApplicationRecord
      include Clusters::Concerns::ProviderStatus

      self.table_name = 'cluster_providers_aws'

      belongs_to :cluster, inverse_of: :provider_aws, class_name: 'Clusters::Cluster'

      default_value_for :region, 'us-east-1'
      default_value_for :num_nodes, 3
      default_value_for :machine_type, 'm5.large'

      attr_encrypted :secret_access_key,
        mode: :per_attribute_iv,
        key: Settings.attr_encrypted_db_key_base_truncated,
        algorithm: 'aes-256-cbc'

      validates :aws_account_id,
        length: { is: 12 },
        format: {
          with: Gitlab::Regex.aws_account_id_regex,
          message: Gitlab::Regex.aws_account_id_regex_message
        }

      validates :num_nodes,
        presence: true,
        numericality: {
          only_integer: true,
          greater_than: 0
        }

      validates :region, :machine_type, presence: true

      before_validation :sanitize_aws_account_id

      def nullify_credentials
        assign_attributes(
          access_key_id: nil,
          secret_access_key: nil
        )
      end

      private

      def sanitize_aws_account_id
        self.aws_account_id&.gsub!(/\D/, '')
      end
    end
  end
end
