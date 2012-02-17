FactoryGirl.define do
  factory :user do
    sequence(:username){|n| "username#{n}"}
    sequence(:email){|n| "default#{n}@email.com"}
    password "abc123"
  end

  factory :comment do
    name "Default Factory Name"
    email "default@factory.mail"
    affiliation "Default Factory Affiliation"
    content "Default Factory Content"
  end
end
