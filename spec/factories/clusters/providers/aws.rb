# frozen_string_literal: true

FactoryBot.define do
  factory :cluster_provider_aws, class: Clusters::Providers::Aws do
    cluster
    aws_account_id '123456789012'

    trait :scheduled do
      access_key_id 'access_key_id'
      secret_access_key 'secret_access_key'
    end

    trait :creating do
      access_key_id 'access_key_id'
      secret_access_key 'secret_access_key'

      after(:build) do |provider|
        provider.make_creating
      end
    end

    trait :created do
      after(:build) do |provider|
        provider.make_created
      end
    end

    trait :errored do
      after(:build) do |provider|
        provider.make_errored('An error occurred')
      end
    end
  end
end
