require 'rails_helper'

RSpec.describe "Watchlists", type: :system do
  before do
    driven_by(:rack_test)
    # 外部APIへのアクセスをモック化
    create_webmock("recent.xml?limit=10", "recent_tds.xml")
    create_webmock("1001.xml?limit=30", "feed_tds.xml")
    create_webmock("1001.xml?limit=3", "feed_tds.xml")
  end

  let(:user) { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }

  describe "ウォッチリスト機能" do
    it "企業をウォッチしてフィード確認まで" do
      visit login_path
      within("#login-form") do
        fill_in 'user-email', with: user.email
        fill_in 'user-password', with: user.password
        click_on 'commit'
      end

      # 銘柄コードで検索
      within("#ts-search") do
        fill_in 'ts-search-bar', with: company.local_code
        click_on 'ts-search-submit'
      end
      expect(page).to \
        have_current_path company_path(company.local_code)
      expect(page).to have_content "テスト株式会社1"
      # ウォッチする
      expect { click_on 'watch-btn' }.to \
        change { user.watchlists.count }.by(1)
      expect(page).to have_selector 'form button#unwatch-btn'
      # フィード確認
      within("header") { click_on user.name }
      click_on "TDフィード"
      expect(page).to have_content "フィードテストについてのお知らせ1"

      # アンウォッチする
      click_on "company-link-1"
      expect { click_on 'unwatch-btn' }.to \
        change { user.watchlists.count }.by(-1)
      expect(page).to have_selector 'form button#watch-btn'
      # フィード確認（ウォッチリストが空）
      within("header") { click_on user.name }
      click_on "TDフィード"
      expect(page).to have_content "企業を探す"
    end
  end
end
