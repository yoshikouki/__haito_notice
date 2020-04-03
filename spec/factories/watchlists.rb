FactoryBot.define do
  factory :watchlist, aliases: [:testwatch] do
    association :testuser, factory: :user
    local_code { :company.local_code }
  end
end
