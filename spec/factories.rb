FactoryGirl.define do
  factory :category do
    name "pdf01"
    month
  end

  factory :log do
    ip '127.0.0.1'
    #category
  end

  factory :month do
    name '1103'
  end

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
