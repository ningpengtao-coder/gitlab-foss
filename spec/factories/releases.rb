FactoryBot.define do
  factory :release do
    tag "v1.1.0"
    sha 'b83d6e391c22777fca1ed3012fce84f633d7fed0'
    name { tag }
    description "Awesome release"
    project
    author

    trait :legacy do
      after(:create) do |release|
        ##
        # Legacy release records do not have sha and author
        release.update_column(:sha, nil)
        release.update_column(:author_id, nil)
      end
    end
  end
end
