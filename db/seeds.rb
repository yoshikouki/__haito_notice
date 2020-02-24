
require "csv"

CSV.foreach('db/data/company/db_init_20200224.csv', headers: true) do |row|
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

