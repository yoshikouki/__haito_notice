
# 企業（東証公表資料から）
require "csv"
CSV.foreach('db/data/company/db_init.csv', headers: true) do |row|
  Company.create!(
    pub_date: row['pub_date'],
    local_code: row['local_code'],
    company_name: row['company_name'],
    market_division: row['market_division'],
    tsi_code: row['tsi_code'],
    topix_sector_indices: row['topix_sector_indices'],
    t17_code: row['t17_code'],
    topix_17: row['topix_17'],
    sc_code: row['sc_code'],
    size_classification: row['size_classification']
  )
end

# ユーザー
User.create!(name:  "駄味小太郎",
  email: "example@email.com",
  password:              "password",
  password_confirmation: "password",
  admin:     false,
  activated: true,
  activated_at: Time.zone.now)
User.create!(name:  "yoshiko",
  email: "yoshikouki@gmail.com",
  password:              "password",
  password_confirmation: "password",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)


# リレーションシップ
user1 = User.first
user2 = User.last
companies = Company.all
watchlists1 = companies[1..50]
watchlists2 = companies[-1..-50]
watchlists1.each{ |c| user1.watch(c) }
watchlists2.each{ |c| user2.watch(c) }

