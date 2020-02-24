# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Company.create!(
  pub_date: 20200131,
  local_code: 1301,
  company_name: "極洋",
  market_division: "市場第一部（内国株）",
  tsi_code: 50,
  topix_sector_indices: "水産・農林業",
  t17_code: 1,
  topix_17: "食品",
  sc_code: 7,
  size_classification: "TOPIX Small 2"
)

Company.create!(
  pub_date: "20200131",
  local_code: "3622",
  company_name: "ＧＭＯペパボ",
  market_division: "市場第二部（内国株）",
  tsi_code: "5250",
  topix_sector_indices: "情報・通信業",
  t17_code: "10",
  topix_17: "情報通信・サービスその他 ",
  sc_code: "-",
  size_classification: "-"
)
