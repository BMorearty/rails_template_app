FactoryGirl.define do
  factory :new_user, class: 'User' do
    sequence(:name) { |n| "Luke Skywalker ##{n}" }
    sequence(:email) { |n| "user+#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'
    role 'registered'
  end

  factory :activated_user, parent: :new_user do
    after(:create) do |user|
      user.activate!
    end
  end

  factory :user, parent: :activated_user
end
