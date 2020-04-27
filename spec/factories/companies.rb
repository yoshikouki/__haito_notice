FactoryBot.define do
  factory :company do
    company_name { "テスト株式会社1" }
    local_code { 1001 }
    market_division { '市場第一部（内国株）' }
    tsi_code { '5250' }
    topix_sector_indices { '情報・通信業' }
    t17_code { '10' }
    topix_17 { '情報通信・サービスその他' }
    sc_code { '1' }
    size_classification { 'TOPIX Core30' }
    pub_date { '20200228' }
  end

  factory :companies, class: 'Company' do
    sequence(:company_name) { |n| "テスト株式会社#{n + 1}" }
    sequence(:local_code) { |n| n + 1001 }
    market_division { '市場第一部（内国株）' }
    tsi_code { '5250' }
    topix_sector_indices { '情報・通信業' }
    t17_code { '10' }
    topix_17 { '情報通信・サービスその他' }
    sc_code { '1' }
    size_classification { 'TOPIX Core30' }
    pub_date { '20200228' }

    trait :more_companies do
      after(:create) { create_list(:company, 50) }
    end
  end
end
