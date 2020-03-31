FactoryBot.define do
  factory :user, class: 'User' do
    name { "テスト太郎" }
    email { "example@email.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
