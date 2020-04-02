FactoryBot.define do
  factory :watchlist, aliases: [:testwatch] do
    # user_id { 1 }
    association :testuser, factory: :user
    # :testuser
    local_code { 1001 }
  end
end
