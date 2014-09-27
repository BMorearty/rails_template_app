FactoryGirl.define do
  factory :new_user, class: 'User' do
    sequence(:name) { |n| "Luke Skywalker ##{n}" }
    sequence(:email) { |n| "user+#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'
    role 'registered'
  end

  factory :activated_user, parent: :new_user do
    after(:build) do |user|
      # Hack to make integration_login faster: prevent sending activation_needed email
      def user.external?
        true
      end
    end
    after(:create) do |user|
      # Activate the user without sending an activation_success email, then restore normal behavior
      user.activate!
      class << user
        undef external?
      end
    end
  end

  factory :user, parent: :activated_user
end
