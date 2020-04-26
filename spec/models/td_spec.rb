require 'rails_helper'

RSpec.describe Td, type: :model do
  before do
    create_webmock("recent.xml?limit=30", "recent_tds.xml")
    create_webmock("recent.xml?limit=1", "only_td.xml")
  end

  describe "WebAPI関係" do
    let(:tds) { Td.new.recent_tds(30) }
    let(:td) { Td.new.recent_tds(1) }

    it "APIレスポンスの数は正しい" do
      expect(tds.count).to be 30
      # 数は`/feature/recent_tds.xml`に依存している
    end

    it "レスポンスのkeysは変換されている" do
      # convert_key = %w[pub_date local_code company_name info_title info_url market_division]
      expect(tds[0].key?("pub_date")).to be true
      expect(tds[0].key?("local_code")).to be true
    end

    it "APIレスポンスの文書は正しい" do
      expect(tds[0]["info_title"]).to eq "テストタイトル1"
      expect(tds[29]["info_title"]).to eq "テストタイトル30"
    end

    it "APIレスポンスのURLは直URLに変換されている" do
      expect(URI.parse(tds[0]["info_url"]).host).to \
        eq "www.release.tdnet.info"
    end

    it "APIレスポンスの市場分類を変換できる" do
      expect(tds[0]["market_division"]).to eq "東証"
      expect(tds[1]["market_division"]).to eq "名証"
    end

    it "APIレスポンスが一つでも正常に処理している" do
      expect(td[0]["info_title"]).to eq "1つだけのテストタイトル"
    end

    it "企業名を変換している" do
      company = FactoryBot.create(:company)
      expect(td[0]["company_name"]).to eq company.company_name
      # fixturesの企業名は"1つだけのテストタイトル"
    end
  end
end
