FactoryGirl.define do
  factory :industry do
    sequence(:name) { |n| "Industry#{n}" }
    protege_id
  end
end
