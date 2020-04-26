require 'rails_helper'

RSpec.describe Td, type: :model do
  before do
    create_webmock("recent.xml?limit=30", "recent_tds.xml")
  end

  describe "WebAPI関係" do
    let(:tds) { Td.new.recent_tds(30) }

    it "APIレスポンスの数は正しい" do
      expect(tds.count).to be 30
      # 数は`/feature/recent_tds.xml`に依存している
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
  end
end
