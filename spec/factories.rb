Factory.define :user do |f|
  f.sequence(:username){|n| "username#{n}"}
  f.sequence(:email){|n| "default#{n}@email.com"}
  f.password "abc123"
end

Factory.define :comment do |f|
  f.name "Default Factory Name"
  f.email "default@factory.mail"
  f.affiliation "Default Factory Affiliation"
  f.content "Default Factory Content"
end
