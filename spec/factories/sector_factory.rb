FactoryGirl.define do
  factory :sector do
    sequence(:name) { |n| "Sector#{n}" }
    protege_id
    industry
  end
end
