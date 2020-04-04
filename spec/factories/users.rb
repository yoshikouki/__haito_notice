FactoryBot.define do
  factory :user, aliases: [:testuser] do
    sequence(:name) { |n| "テスト #{n}" }
    sequence(:email) { |n| "example-#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { 10.days.ago }
  end

  factory :jill, class: 'User' do
    name { "Jill Valentine" }
    email { "jill@email.com" }
    password { "password" }
    password_confirmation { "password" }
    activation_token { User.new_token }
    activation_digest { User.digest(:activation_token) }
    activated { true }
    activated_at { 1.day.ago }
  end

  factory :inact, class: 'User' do
    name { "Inactivate user" }
    email { "inactivate@email.com" }
    password { "password" }
    password_confirmation { "password" }
    activation_token { User.new_token }
    activation_digest { User.digest(:activation_token) }
    activated { false }
    activated_at { nil }
  end
end
