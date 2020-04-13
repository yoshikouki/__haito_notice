require 'rails_helper'

RSpec.describe "Companies", type: :system do
  let(:company) { FactoryBot.create(:company) }

  before do
    driven_by(:rack_test)
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
    create_webmock("#{company.local_code}.xml?limit=30", "feed_tds.xml")
    company.company_name = "フィードテスト株式会社1"
  end

  describe "企業一覧" do
    it "全企業一覧からセクター一覧経由の企業個別ページまで" do
      visit root_path
      # 全企業一覧
      within("header") { click_on 'companies-link' }
      expect(page).to have_current_path companies_path
      # セクター一覧
      click_on "tsi-code-#{company.tsi_code}"
      expect(page).to have_current_path sectors_path(company.tsi_code)

      # 企業個別ページ
      click_on "company-link-#{company.local_code}"
      expect(page).to \
        have_current_path company_path(company.local_code)
      expect(find("#company-name")).to \
        have_content company.company_name
      # 未ログインの場合はウォッチボタンが表示されない
      expect(find("#login-to-watch")).to \
        have_content "ログインしてウォッチ"
    end

    it "検索バーから企業個別ページまで" do
      visit root_path
      # 企業検索バーから銘柄コードで検索
      within("#ts-search") do
        fill_in 'ts-search-bar', with: company.local_code
        click_on 'ts-search-submit'
      end

      # 企業個別ページ
      expect(page).to \
        have_current_path company_path(company.local_code)
      expect(find("#company-name")).to \
        have_content company.company_name
    end
  end
end
