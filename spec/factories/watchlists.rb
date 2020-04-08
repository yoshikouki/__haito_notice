FactoryBot.define do
  factory :watchlist, aliases: [:testwatch] do
    user_id { 50 }
    local_code { 9999 }
  end
end
