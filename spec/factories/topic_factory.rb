FactoryGirl.define do
  factory :topic do
    sequence(:name) { |n| "Topic#{n}" }
    sector
    source
  end
end
